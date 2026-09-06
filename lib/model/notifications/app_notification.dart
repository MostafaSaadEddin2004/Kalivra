import 'package:flutter/material.dart';

enum AppNotificationType {
  orderPlaced,
  orderCanceled,
  shipment,
  associationRequest,
  membership,
  paymentConfirmation,
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

enum AppNotificationDeliveryChannel { inApp, push, sms, email, whatsapp }

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
    required this.rawType,
    this.source,
    this.sourceLabel,
    this.referenceId,
    this.url,
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
  final String rawType;
  final String? source;
  final String? sourceLabel;
  final String? referenceId;
  final String? url;
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
    final rawType = _stringValue(data['notification_type'] ?? data['type']);
    final type = _parseType(rawType);
    final createdAt = _parseDate(data['created_at']) ?? DateTime.now();
    final readAt = _parseDate(data['read_at']);
    final isRead = _parseBool(data['read']);
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
      createdAt: createdAt,
      sourceEvent:
          _stringValue(data['source_event']) ??
          rawType ??
          _sourceEventForType(type),
      rawType: rawType ?? _sourceEventForType(type),
      source: _stringValue(data['source']),
      sourceLabel: _stringValue(data['source_label']),
      referenceId: _stringValue(data['reference_id']),
      url: _stringValue(data['url']),
      status: _parseStatus(data['status']),
      sourceType: _parseSourceType(data['source_type'] ?? data['source']),
      channels: _parseChannels(data['channels'] ?? data['channel']),
      priority: _parsePriority(data['priority']),
      relatedEntity: _parseRelatedEntity(data['related_entity'] ?? rawType),
      relatedEntityId:
          _stringValue(data['related_entity_id']) ??
          _stringValue(data['reference_id']),
      isMandatory: _parseBool(data['is_mandatory'] ?? data['mandatory']),
      expiredAt: _parseDate(data['expired_at'] ?? data['expiration_date']),
      readAt: readAt ?? (isRead ? createdAt : null),
    );
  }

  String get code {
    switch (type) {
      case AppNotificationType.orderPlaced:
        return 'order_placed';
      case AppNotificationType.orderCanceled:
        return 'order_canceled';
      case AppNotificationType.shipment:
        return 'shipment';
      case AppNotificationType.associationRequest:
        return 'association_request';
      case AppNotificationType.membership:
        return 'membership';
      case AppNotificationType.paymentConfirmation:
        return 'payment_confirmation';
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
      case AppNotificationType.orderPlaced:
        return Icons.shopping_bag_outlined;
      case AppNotificationType.orderCanceled:
        return Icons.cancel_outlined;
      case AppNotificationType.shipment:
        return Icons.local_shipping_outlined;
      case AppNotificationType.associationRequest:
        return Icons.fact_check_outlined;
      case AppNotificationType.membership:
        return Icons.home_work_outlined;
      case AppNotificationType.paymentConfirmation:
        return Icons.payments_outlined;
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
      case AppNotificationType.orderPlaced:
        return 'Order placed';
      case AppNotificationType.orderCanceled:
        return 'Order canceled';
      case AppNotificationType.shipment:
        return 'Shipment';
      case AppNotificationType.associationRequest:
        return 'Association request';
      case AppNotificationType.membership:
        return 'Membership';
      case AppNotificationType.paymentConfirmation:
        return 'Payment confirmation';
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
      rawType: rawType,
      source: source,
      sourceLabel: sourceLabel,
      referenceId: referenceId,
      url: url,
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
      case 'orderplaced':
      case 'order_placed':
        return AppNotificationType.orderPlaced;
      case 'ordercanceled':
      case 'order_canceled':
      case 'order_cancelled':
        return AppNotificationType.orderCanceled;
      case 'shipment':
      case 'shipping':
      case 'order_shipped':
        return AppNotificationType.shipment;
      case 'associationrequest':
      case 'association_request':
        return AppNotificationType.associationRequest;
      case 'membership':
        return AppNotificationType.membership;
      case 'paymentconfirmation':
      case 'payment_confirmation':
        return AppNotificationType.paymentConfirmation;
      case 'memberoperation':
      case 'member_operation':
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
      case 'association_request':
      case 'person':
      case 'user':
        return AppNotificationRelatedEntity.person;
      case 'membership':
      case 'member':
        return AppNotificationRelatedEntity.membership;
      case 'project':
        return AppNotificationRelatedEntity.project;
      case 'payment':
      case 'payment_confirmation':
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
      case 'push':
      case 'fcm':
        return AppNotificationDeliveryChannel.push;
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
      case AppNotificationType.orderPlaced:
        return 'order_placed';
      case AppNotificationType.orderCanceled:
        return 'order_canceled';
      case AppNotificationType.shipment:
        return 'shipment';
      case AppNotificationType.associationRequest:
        return 'association_request';
      case AppNotificationType.membership:
        return 'membership';
      case AppNotificationType.paymentConfirmation:
        return 'payment_confirmation';
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
