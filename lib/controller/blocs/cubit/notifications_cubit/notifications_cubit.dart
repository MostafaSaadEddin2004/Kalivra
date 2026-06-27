import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kalivra/controller/blocs/cubit/notifications_cubit/notifications_state.dart';
import 'package:kalivra/controller/prefs/local_store.dart';
import 'package:kalivra/model/notifications/app_notification.dart';

export 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit() : super(const NotificationsState()) {
    _updateLoginRequired();
  }

  Future<void> _updateLoginRequired() async {
    final token = await LocalStore.getToken();
    final loginRequired = token == null || token.isEmpty;
    emit(
      state.copyWith(
        loginRequired: loginRequired,
        notifications: loginRequired ? const [] : _seedNotifications(),
      ),
    );
  }

  Future<void> refresh() => _updateLoginRequired();

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

  List<AppNotification> _seedNotifications() {
    final now = DateTime.now();
    return [
      AppNotification(
        id: 'member-link-approved',
        type: AppNotificationType.memberOperation,
        title: 'Member profile update',
        message:
            'A member operation was completed and linked to your association profile.',
        createdAt: now.subtract(const Duration(minutes: 8)),
        sourceEvent: 'member_link_approved',
        priority: AppNotificationPriority.important,
        relatedEntity: AppNotificationRelatedEntity.membership,
        relatedEntityId: 'current-member',
      ),
      AppNotification(
        id: 'payment-obligation-due',
        type: AppNotificationType.financialOperation,
        title: 'Financial obligation is due',
        message:
            'A payment or obligation requires your review. Financial and legal notifications are mandatory.',
        createdAt: now.subtract(const Duration(hours: 2)),
        sourceEvent: 'obligation_due',
        channels: const [
          AppNotificationDeliveryChannel.inApp,
          AppNotificationDeliveryChannel.sms,
          AppNotificationDeliveryChannel.email,
        ],
        priority: AppNotificationPriority.critical,
        relatedEntity: AppNotificationRelatedEntity.obligation,
        relatedEntityId: 'current-obligation',
        isMandatory: true,
      ),
      AppNotification(
        id: 'session-decision-issued',
        type: AppNotificationType.decisionSession,
        title: 'New decision or session update',
        message:
            'A related association decision or meeting session update has been published.',
        createdAt: now.subtract(const Duration(days: 1)),
        sourceEvent: 'decision_published',
        relatedEntity: AppNotificationRelatedEntity.project,
        relatedEntityId: 'association-services',
      ),
      AppNotification(
        id: 'announcement-sent',
        type: AppNotificationType.officialAnnouncement,
        title: 'Official announcement sent',
        message:
            'An official announcement was sent to the selected recipients and remains linked to its source record.',
        createdAt: now.subtract(const Duration(days: 2)),
        sourceEvent: 'announcement_sent',
        channels: const [
          AppNotificationDeliveryChannel.inApp,
          AppNotificationDeliveryChannel.sms,
          AppNotificationDeliveryChannel.email,
          AppNotificationDeliveryChannel.whatsapp,
        ],
        priority: AppNotificationPriority.important,
        relatedEntity: AppNotificationRelatedEntity.announcement,
        relatedEntityId: 'announcement-001',
      ),
      AppNotification(
        id: 'announcement-deadline-warning',
        type: AppNotificationType.legalDeadline,
        title: 'Announcement deadline is near',
        message:
            'The legal deadline attached to an announcement is approaching. Please review the remaining time.',
        createdAt: now.subtract(const Duration(days: 2, hours: 6)),
        sourceEvent: 'announcement_deadline_near',
        priority: AppNotificationPriority.critical,
        relatedEntity: AppNotificationRelatedEntity.announcement,
        relatedEntityId: 'announcement-deadline-001',
        isMandatory: true,
        expiredAt: now.add(const Duration(days: 1)),
      ),
      AppNotification(
        id: 'manual-notice',
        type: AppNotificationType.manualSystemNotice,
        title: 'System notice',
        message:
            'This is a manual in-app notification created by an authorized user.',
        createdAt: now.subtract(const Duration(days: 3)),
        sourceEvent: 'manual_notification',
        sourceType: AppNotificationSourceType.manual,
        status: AppNotificationStatus.created,
        readAt: now.subtract(const Duration(days: 2, hours: 22)),
      ),
      AppNotification(
        id: 'delivery-failed',
        type: AppNotificationType.deliveryFailure,
        title: 'External delivery failed',
        message:
            'An external notification channel failed. The in-app notification remains available.',
        createdAt: now.subtract(const Duration(days: 4)),
        sourceEvent: 'notification_delivery_failed',
        status: AppNotificationStatus.failed,
        channels: const [
          AppNotificationDeliveryChannel.sms,
          AppNotificationDeliveryChannel.whatsapp,
        ],
        priority: AppNotificationPriority.important,
      ),
    ];
  }
}
