import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kalivra/controller/blocs/cubit/notifications_cubit/notifications_state.dart';
import 'package:kalivra/controller/prefs/local_store.dart';
import 'package:kalivra/model/notifications/app_notification.dart';
import 'package:kalivra/model/services/api/notification_preferences_api_service.dart';

export 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit({NotificationPreferencesApiService? service})
    : _service = service ?? NotificationPreferencesApiService(),
      super(const NotificationsState()) {
    _updateLoginRequired();
  }

  final NotificationPreferencesApiService _service;

  Future<void> _updateLoginRequired({bool showLoading = true}) async {
    final token = await LocalStore.getToken();
    final loginRequired = token == null || token.isEmpty;
    if (loginRequired) {
      emit(
        state.copyWith(
          loginRequired: true,
          notifications: const [],
          isLoading: false,
          errorMessage: '',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        loginRequired: false,
        isLoading: showLoading,
        errorMessage: '',
      ),
    );

    try {
      final fetchedNotifications = await _service.getNotificationHistory();
      final notifications = showLoading
          ? fetchedNotifications
          : _mergeNotifications(
              fetchedNotifications,
              fallbackNotifications: state.notifications,
            );
      emit(
        state.copyWith(
          loginRequired: false,
          notifications: notifications,
          isLoading: false,
          errorMessage: '',
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          loginRequired: false,
          isLoading: false,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> refresh() => _updateLoginRequired();

  Future<void> syncFromServer() => _updateLoginRequired(showLoading: false);

  void markAsRead(String notificationId) {
    final readAt = DateTime.now();
    final notifications = state.notifications
        .map((notification) {
          if (notification.id != notificationId || notification.isRead) {
            return notification;
          }
          return notification.copyWith(readAt: readAt);
        })
        .toList(growable: false);

    emit(state.copyWith(notifications: notifications));
  }

  AppNotification receiveRemoteNotification(
    Map<String, dynamic> data, {
    String? fallbackId,
    String? fallbackTitle,
    String? fallbackMessage,
  }) {
    final notification = AppNotification.fromRemoteData(
      data,
      fallbackId: fallbackId,
      fallbackTitle: fallbackTitle,
      fallbackMessage: fallbackMessage,
    );
    addOrUpdateNotification(notification);
    return notification;
  }

  void addOrUpdateNotification(AppNotification notification) {
    final currentNotifications = state.notifications;
    final existingIndex = currentNotifications.indexWhere(
      (item) => item.id == notification.id,
    );

    final notifications = List<AppNotification>.of(currentNotifications);
    if (existingIndex == -1) {
      notifications.insert(0, notification);
    } else {
      notifications[existingIndex] = notification;
    }

    emit(state.copyWith(notifications: notifications));
  }

  List<AppNotification> _mergeNotifications(
    List<AppNotification> fetchedNotifications, {
    required List<AppNotification> fallbackNotifications,
  }) {
    final byId = <String, AppNotification>{};

    for (final notification in fallbackNotifications) {
      byId[notification.id] = notification;
    }

    for (final notification in fetchedNotifications.reversed) {
      byId[notification.id] = notification;
    }

    return byId.values.toList()
      ..sort((left, right) => right.createdAt.compareTo(left.createdAt));
  }
}
