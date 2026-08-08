import 'package:kalivra/model/notifications/app_notification.dart';

class NotificationsState {
  const NotificationsState({
    this.loginRequired = false,
    this.notifications = const [],
    this.isLoading = false,
    this.errorMessage = '',
  });

  final bool loginRequired;
  final List<AppNotification> notifications;
  final bool isLoading;
  final String errorMessage;

  int get unreadCount =>
      notifications.where((notification) => !notification.isRead).length;

  NotificationsState copyWith({
    bool? loginRequired,
    List<AppNotification>? notifications,
    bool? isLoading,
    String? errorMessage,
  }) {
    return NotificationsState(
      loginRequired: loginRequired ?? this.loginRequired,
      notifications: notifications ?? this.notifications,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
