import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kalivra/firebase_options.dart';

typedef FirebaseNotificationTapCallback =
    void Function(Map<String, dynamic> data);
typedef FirebaseNotificationReceivedCallback =
    void Function(Map<String, dynamic> data);

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (!FirebaseHelper.isSupportedPlatform) {
    return;
  }

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } on FirebaseException catch (error) {
    if (error.code != 'duplicate-app') {
      rethrow;
    }
  }
}

class FirebaseHelper {
  FirebaseHelper._();

  static const String highImportanceChannelId =
      'kalivra_high_importance_channel';

  static const AndroidNotificationChannel _androidChannel =
      AndroidNotificationChannel(
        highImportanceChannelId,
        'Kalivra notifications',
        description: 'High importance notifications for Kalivra.',
        importance: Importance.high,
      );

  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  static final StreamController<Map<String, dynamic>>
  _notificationTapController =
      StreamController<Map<String, dynamic>>.broadcast();
  static final StreamController<Map<String, dynamic>>
  _notificationReceivedController =
      StreamController<Map<String, dynamic>>.broadcast();

  static bool _initialized = false;
  static FirebaseNotificationTapCallback? _onNotificationTap;
  static FirebaseNotificationReceivedCallback? _onNotificationReceived;
  static final List<Map<String, dynamic>> _pendingTapData = [];

  static Stream<Map<String, dynamic>> get notificationTapStream =>
      _notificationTapController.stream;
  static Stream<Map<String, dynamic>> get notificationReceivedStream =>
      _notificationReceivedController.stream;

  static bool get isSupportedPlatform {
    if (kIsWeb) {
      return false;
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
        return true;
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        return false;
    }
  }

  static Future<bool> initialize({
    FirebaseNotificationTapCallback? onNotificationTap,
    FirebaseNotificationReceivedCallback? onNotificationReceived,
  }) async {
    _onNotificationTap = onNotificationTap ?? _onNotificationTap;
    _onNotificationReceived = onNotificationReceived ?? _onNotificationReceived;

    if (_initialized) {
      _flushPendingTapData();
      return true;
    }

    if (!isSupportedPlatform) {
      return false;
    }

    await _initializeFirebaseApp();
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    await _initializeLocalNotifications();
    await requestNotificationPermission();
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleRemoteMessageTap);

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleRemoteMessageTap(initialMessage);
    }

    _initialized = true;
    _flushPendingTapData();
    return true;
  }

  static Future<String?> getFcmToken() async {
    if (!isSupportedPlatform) {
      return null;
    }

    await initialize();
    return _messaging.getToken();
  }

  static Stream<String> get tokenRefreshStream {
    if (!isSupportedPlatform) {
      return const Stream<String>.empty();
    }

    return _messaging.onTokenRefresh;
  }

  static Future<NotificationSettings?> requestNotificationPermission() async {
    if (!isSupportedPlatform) {
      return null;
    }

    final settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    return settings;
  }

  static Future<void> subscribeToTopic(String topic) async {
    if (!isSupportedPlatform) {
      return;
    }

    await initialize();
    await _messaging.subscribeToTopic(topic);
  }

  static Future<void> unsubscribeFromTopic(String topic) async {
    if (!isSupportedPlatform) {
      return;
    }

    await initialize();
    await _messaging.unsubscribeFromTopic(topic);
  }

  static Future<void> showLocalNotification({
    required String title,
    required String body,
    Map<String, dynamic> data = const {},
  }) async {
    if (!isSupportedPlatform) {
      return;
    }

    await _localNotifications.show(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: title,
      body: body,
      notificationDetails: _notificationDetails(),
      payload: jsonEncode(data),
    );
  }

  static Future<void> _initializeFirebaseApp() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } on FirebaseException catch (error) {
      if (error.code != 'duplicate-app') {
        rethrow;
      }
    }
  }

  static Future<void> _initializeLocalNotifications() async {
    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
    );

    await _localNotifications.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: _handleLocalNotificationTap,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_androidChannel);
  }

  static Future<void> _handleForegroundMessage(RemoteMessage message) async {
    final data = _dataFromRemoteMessage(message);
    _emitNotificationReceived(data);

    final notification = message.notification;
    final title = notification?.title ?? message.data['title']?.toString();
    final body = notification?.body ?? message.data['body']?.toString();

    if (title == null || body == null) {
      return;
    }

    await _localNotifications.show(
      id: message.messageId.hashCode,
      title: title,
      body: body,
      notificationDetails: _notificationDetails(),
      payload: jsonEncode(data),
    );
  }

  static NotificationDetails _notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        highImportanceChannelId,
        'Kalivra notifications',
        channelDescription: 'High importance notifications for Kalivra.',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
  }

  static void _handleRemoteMessageTap(RemoteMessage message) {
    _emitNotificationTap(_dataFromRemoteMessage(message));
  }

  static void _handleLocalNotificationTap(NotificationResponse response) {
    final payload = response.payload;
    if (payload == null || payload.isEmpty) {
      return;
    }

    final decoded = jsonDecode(payload);
    if (decoded is Map<String, dynamic>) {
      _emitNotificationTap(decoded);
    } else if (decoded is Map) {
      _emitNotificationTap(Map<String, dynamic>.from(decoded));
    }
  }

  static void _emitNotificationTap(Map<String, dynamic> data) {
    if (_onNotificationTap == null) {
      _pendingTapData.add(data);
      return;
    }

    _notificationTapController.add(data);
    _onNotificationTap?.call(data);
  }

  static void _emitNotificationReceived(Map<String, dynamic> data) {
    _notificationReceivedController.add(data);
    _onNotificationReceived?.call(data);
  }

  static void _flushPendingTapData() {
    if (_onNotificationTap == null || _pendingTapData.isEmpty) {
      return;
    }

    final pendingData = List<Map<String, dynamic>>.of(_pendingTapData);
    _pendingTapData.clear();
    for (final data in pendingData) {
      _emitNotificationTap(data);
    }
  }

  static Map<String, dynamic> _dataFromRemoteMessage(RemoteMessage message) {
    final notification = message.notification;
    return <String, dynamic>{
      ...message.data,
      if (message.messageId != null) 'message_id': message.messageId,
      if (notification?.title != null) 'title': notification!.title,
      if (notification?.body != null) 'body': notification!.body,
      if (message.sentTime != null)
        'created_at': message.sentTime!.toIso8601String(),
    };
  }
}
