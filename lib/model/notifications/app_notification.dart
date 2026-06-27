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

  factory AppNotification.fromRemoteData(
    Map<String, dynamic> data, {
    String? fallbackId,
    String? fallbackTitle,
    String? fallbackMessage,
  }) {
    final type = _parseType(data['notification_type'] ?? data['type']);
    final id =
        _stringValue(
          data['id'] ?? data['notification_id'] ?? data['message_id'],
        ) ??
        fallbackId ??
        '${type.name}-${DateTime.now().millisecondsSinceEpoch}';

    return AppNotification(
      id: id,
      type: type,
      title:
          _stringValue(data['title'] ?? data['notification_title']) ??
          fallbackTitle ??
          'Kalivra notification',
      message:
          _stringValue(
            data['message'] ?? data['body'] ?? data['notification_body'],
          ) ??
          fallbackMessage ??
          '',
      createdAt: _parseDate(data['created_at']) ?? DateTime.now(),
      sourceEvent:
          _stringValue(data['source_event']) ?? _sourceEventForType(type),
      status: _parseStatus(data['status']),
      sourceType: _parseSourceType(data['source_type']),
      channels: _parseChannels(data['channels'] ?? data['channel']),
      priority: _parsePriority(data['priority']),
      relatedEntity: _parseRelatedEntity(data['related_entity']),
      relatedEntityId: _stringValue(data['related_entity_id']),
      isMandatory: _parseBool(data['is_mandatory'] ?? data['mandatory']),
      expiredAt: _parseDate(data['expired_at'] ?? data['expiration_date']),
    );
  }

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

  static AppNotificationType _parseType(Object? value) {
    final normalized = _normalize(value);
    switch (normalized) {
      case 'memberoperation':
      case 'member_operation':
      case 'membership':
      case 'member':
        return AppNotificationType.memberOperation;
      case 'financialoperation':
      case 'financial_operation':
      case 'payment':
      case 'obligation':
      case 'finance':
        return AppNotificationType.financialOperation;
      case 'decisionsession':
      case 'decision_session':
      case 'decision':
      case 'session':
      case 'meeting':
        return AppNotificationType.decisionSession;
      case 'officialannouncement':
      case 'official_announcement':
      case 'announcement':
        return AppNotificationType.officialAnnouncement;
      case 'legaldeadline':
      case 'legal_deadline':
      case 'deadline':
        return AppNotificationType.legalDeadline;
      case 'deliveryfailure':
      case 'delivery_failure':
      case 'delivery_failed':
      case 'failed':
        return AppNotificationType.deliveryFailure;
      case 'manualsystemnotice':
      case 'manual_system_notice':
      case 'system_notice':
      case 'manual':
      default:
        return AppNotificationType.manualSystemNotice;
    }
  }

  static AppNotificationPriority _parsePriority(Object? value) {
    switch (_normalize(value)) {
      case 'important':
      case 'high':
        return AppNotificationPriority.important;
      case 'critical':
      case 'urgent':
        return AppNotificationPriority.critical;
      case 'normal':
      case 'low':
      default:
        return AppNotificationPriority.normal;
    }
  }

  static AppNotificationStatus _parseStatus(Object? value) {
    switch (_normalize(value)) {
      case 'created':
      case 'pending':
        return AppNotificationStatus.created;
      case 'failed':
      case 'failure':
        return AppNotificationStatus.failed;
      case 'sent':
      case 'delivered':
      default:
        return AppNotificationStatus.sent;
    }
  }

  static AppNotificationSourceType _parseSourceType(Object? value) {
    switch (_normalize(value)) {
      case 'manual':
        return AppNotificationSourceType.manual;
      case 'system':
      default:
        return AppNotificationSourceType.system;
    }
  }

  static AppNotificationRelatedEntity _parseRelatedEntity(Object? value) {
    switch (_normalize(value)) {
      case 'person':
      case 'user':
        return AppNotificationRelatedEntity.person;
      case 'membership':
      case 'member':
        return AppNotificationRelatedEntity.membership;
      case 'project':
        return AppNotificationRelatedEntity.project;
      case 'payment':
        return AppNotificationRelatedEntity.payment;
      case 'obligation':
        return AppNotificationRelatedEntity.obligation;
      case 'announcement':
      case 'official_announcement':
        return AppNotificationRelatedEntity.announcement;
      case 'none':
      default:
        return AppNotificationRelatedEntity.none;
    }
  }

  static List<AppNotificationDeliveryChannel> _parseChannels(Object? value) {
    if (value is Iterable) {
      return value.map(_parseChannel).toSet().toList(growable: false);
    }
    if (value is String && value.contains(',')) {
      return value
          .split(',')
          .map(_parseChannel)
          .toSet()
          .toList(growable: false);
    }

    return [_parseChannel(value)];
  }

  static AppNotificationDeliveryChannel _parseChannel(Object? value) {
    switch (_normalize(value)) {
      case 'sms':
        return AppNotificationDeliveryChannel.sms;
      case 'email':
      case 'mail':
        return AppNotificationDeliveryChannel.email;
      case 'whatsapp':
      case 'whats_app':
        return AppNotificationDeliveryChannel.whatsapp;
      case 'inapp':
      case 'in_app':
      default:
        return AppNotificationDeliveryChannel.inApp;
    }
  }

  static bool _parseBool(Object? value) {
    if (value is bool) {
      return value;
    }
    if (value is num) {
      return value != 0;
    }

    switch (_normalize(value)) {
      case 'true':
      case 'yes':
      case '1':
        return true;
      default:
        return false;
    }
  }

  static DateTime? _parseDate(Object? value) {
    final stringValue = _stringValue(value);
    if (stringValue == null || stringValue.isEmpty) {
      return null;
    }
    return DateTime.tryParse(stringValue);
  }

  static String? _stringValue(Object? value) {
    if (value == null) {
      return null;
    }
    final stringValue = value.toString().trim();
    return stringValue.isEmpty ? null : stringValue;
  }

  static String _normalize(Object? value) {
    return _stringValue(
          value,
        )?.toLowerCase().replaceAll('-', '_').replaceAll(' ', '_') ??
        '';
  }

  static String _sourceEventForType(AppNotificationType type) {
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
        return 'manual_notification';
      case AppNotificationType.deliveryFailure:
        return 'notification_delivery_failed';
    }
  }
}
