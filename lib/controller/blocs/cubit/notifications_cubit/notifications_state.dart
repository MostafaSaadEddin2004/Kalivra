import 'package:kalivra/model/notifications/app_notification.dart';

class NotificationsState {
  const NotificationsState({
    this.loginRequired = false,
    this.notifications = const [],
  });

  final bool loginRequired;
  final List<AppNotification> notifications;

  int get unreadCount =>
      notifications.where((notification) => !notification.isRead).length;

  NotificationsState copyWith({
    bool? loginRequired,
    List<AppNotification>? notifications,
  }) {
    return NotificationsState(
      loginRequired: loginRequired ?? this.loginRequired,
      notifications: notifications ?? this.notifications,
    );
  }
}
