import 'package:kalivra/core/network/dio_client.dart';
import 'package:kalivra/model/notifications/app_notification.dart';
import 'package:kalivra/model/notifications/notification_preference.dart';

class NotificationPreferencesApiService {
  NotificationPreferencesApiService({DioClient? client})
    : _client = client ?? DioClient();

  final DioClient _client;

  Future<List<AppNotification>> getNotificationHistory() async {
    final response = await _client.get('customer/notification-preferences');
    final rawNotifications = _rawListFromPayload(
      response.data,
      keys: const ['notifications', 'notification_history', 'history', 'items'],
    );

    return rawNotifications
        .whereType<Map>()
        .where(_looksLikeNotification)
        .map((item) => AppNotification.fromRemoteData(Map.from(item)))
        .toList(growable: false);
  }

  Future<NotificationPreference> getAnnouncementPreference() async {
    final response = await _client.get('customer/notification-preferences');
    final data = _unwrapData(response.data);
    if (data is Map && data['notification_type'] != null) {
      return NotificationPreference.fromJson(data);
    }

    final rawPreferences = _rawListFromPayload(
      data,
      keys: const ['preferences', 'notification_preferences'],
    );

    for (final item in rawPreferences.whereType<Map>()) {
      final preference = NotificationPreference.fromJson(item);
      if (preference.notificationType ==
          NotificationPreference.announcementType) {
        return preference;
      }
    }

    return NotificationPreference.announcementDefault();
  }

  Future<void> updatePreference(NotificationPreference preference) async {
    await _client.put(
      'customer/notification-preferences',
      data: {
        'preferences': [preference.toJson()],
      },
    );
  }

  List<dynamic> _rawListFromPayload(
    Object? payload, {
    required List<String> keys,
  }) {
    final data = _unwrapData(payload);
    if (data is List) return data;
    if (data is! Map) return const [];

    for (final key in keys) {
      final value = data[key];
      if (value is List) return value;
    }

    return const [];
  }

  Object? _unwrapData(Object? payload) {
    if (payload is Map && payload['data'] != null) {
      return payload['data'];
    }
    return payload;
  }

  bool _looksLikeNotification(Map<dynamic, dynamic> item) {
    return item.containsKey('title') ||
        item.containsKey('notification_title') ||
        item.containsKey('message') ||
        item.containsKey('body') ||
        item.containsKey('notification_body') ||
        item.containsKey('message_id') ||
        item.containsKey('notification_id');
  }
}
