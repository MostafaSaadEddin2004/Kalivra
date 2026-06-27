import 'package:flutter_test/flutter_test.dart';
import 'package:kalivra/model/notifications/app_notification.dart';

void main() {
  test('AppNotification parses Firebase payload data', () {
    final notification = AppNotification.fromRemoteData({
      'message_id': 'message-1',
      'notification_type': 'financial_operation',
      'title': 'Payment due',
      'body': 'A financial obligation requires review.',
      'priority': 'critical',
      'related_entity': 'obligation',
      'related_entity_id': 'obligation-1',
      'is_mandatory': 'true',
      'channels': 'in_app,sms,email',
      'created_at': '2026-06-27T10:00:00.000Z',
    });

    expect(notification.id, 'message-1');
    expect(notification.type, AppNotificationType.financialOperation);
    expect(notification.priority, AppNotificationPriority.critical);
    expect(notification.relatedEntity, AppNotificationRelatedEntity.obligation);
    expect(notification.relatedEntityId, 'obligation-1');
    expect(notification.isMandatory, isTrue);
    expect(notification.channels, contains(AppNotificationDeliveryChannel.sms));
  });
}
