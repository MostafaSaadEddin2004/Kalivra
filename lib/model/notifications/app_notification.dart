import 'package:flutter/material.dart';

enum AppNotificationType {
  memberOperation,
  financialOperation,
  decisionSession,
  officialAnnouncement,
  legalDeadline,
  manualSystemNotice,
  deliveryFailure,
}

enum AppNotificationPriority { normal, important, critical }

enum AppNotificationStatus { created, sent, failed }

enum AppNotificationSourceType { system, manual }

enum AppNotificationDeliveryChannel { inApp, sms, email, whatsapp }

enum AppNotificationRelatedEntity {
  person,
  membership,
  project,
  payment,
  obligation,
  announcement,
  none,
}

class AppNotification {
  const AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.createdAt,
    required this.sourceEvent,
    this.status = AppNotificationStatus.sent,
    this.sourceType = AppNotificationSourceType.system,
    this.channels = const [AppNotificationDeliveryChannel.inApp],
    this.priority = AppNotificationPriority.normal,
    this.relatedEntity = AppNotificationRelatedEntity.none,
    this.relatedEntityId,
    this.isMandatory = false,
    this.expiredAt,
    this.readAt,
  });

  final String id;
  final AppNotificationType type;
  final String title;
  final String message;
  final DateTime createdAt;
  final String sourceEvent;
  final AppNotificationStatus status;
  final AppNotificationSourceType sourceType;
  final List<AppNotificationDeliveryChannel> channels;
  final AppNotificationPriority priority;
  final AppNotificationRelatedEntity relatedEntity;
  final String? relatedEntityId;
  final bool isMandatory;
  final DateTime? expiredAt;
  final DateTime? readAt;

  bool get isRead => readAt != null;

  String get code {
    switch (type) {
      case AppNotificationType.memberOperation:
        return 'member_operation';
      case AppNotificationType.financialOperation:
        return 'financial_operation';
      case AppNotificationType.decisionSession:
        return 'decision_session';
      case AppNotificationType.officialAnnouncement:
        return 'official_announcement';
      case AppNotificationType.legalDeadline:
        return 'legal_deadline';
      case AppNotificationType.manualSystemNotice:
        return 'manual_system_notice';
      case AppNotificationType.deliveryFailure:
        return 'delivery_failure';
    }
  }

  IconData get icon {
    switch (type) {
      case AppNotificationType.memberOperation:
        return Icons.groups_rounded;
      case AppNotificationType.financialOperation:
        return Icons.payments_outlined;
      case AppNotificationType.decisionSession:
        return Icons.event_note_rounded;
      case AppNotificationType.officialAnnouncement:
        return Icons.campaign_rounded;
      case AppNotificationType.legalDeadline:
        return Icons.timer_outlined;
      case AppNotificationType.manualSystemNotice:
        return Icons.info_outline_rounded;
      case AppNotificationType.deliveryFailure:
        return Icons.error_outline_rounded;
    }
  }

  String get typeLabel {
    switch (type) {
      case AppNotificationType.memberOperation:
        return 'Member operation';
      case AppNotificationType.financialOperation:
        return 'Financial operation';
      case AppNotificationType.decisionSession:
        return 'Decision or session';
      case AppNotificationType.officialAnnouncement:
        return 'Official announcement';
      case AppNotificationType.legalDeadline:
        return 'Legal deadline';
      case AppNotificationType.manualSystemNotice:
        return 'System notice';
      case AppNotificationType.deliveryFailure:
        return 'Delivery status';
    }
  }

  String get priorityLabel {
    switch (priority) {
      case AppNotificationPriority.normal:
        return 'Normal';
      case AppNotificationPriority.important:
        return 'Important';
      case AppNotificationPriority.critical:
        return 'Critical';
    }
  }

  String get statusLabel {
    switch (status) {
      case AppNotificationStatus.created:
        return 'Created';
      case AppNotificationStatus.sent:
        return 'Sent';
      case AppNotificationStatus.failed:
        return 'Failed';
    }
  }

  String get sourceTypeLabel {
    switch (sourceType) {
      case AppNotificationSourceType.system:
        return 'System';
      case AppNotificationSourceType.manual:
        return 'Manual';
    }
  }

  AppNotification copyWith({DateTime? readAt}) {
    return AppNotification(
      id: id,
      type: type,
      title: title,
      message: message,
      createdAt: createdAt,
      sourceEvent: sourceEvent,
      status: status,
      sourceType: sourceType,
      channels: channels,
      priority: priority,
      relatedEntity: relatedEntity,
      relatedEntityId: relatedEntityId,
      isMandatory: isMandatory,
      expiredAt: expiredAt,
      readAt: readAt ?? this.readAt,
    );
  }
}
