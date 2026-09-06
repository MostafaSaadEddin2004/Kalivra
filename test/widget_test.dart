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

  test('AppNotification parses customer notification API payload data', () {
    final notification = AppNotification.fromRemoteData({
      'id': 'e9d2a2f4-be6c-473b-bd68-8f7e6727e731',
      'title': 'تم إلغاء طلب جديد',
      'body': 'تم إلغاء طلبك #15 المنجز في 2026-08-27 00:14:48',
      'type': 'order_canceled',
      'source': 'kalivra',
      'source_label': 'كاليفرا',
      'reference_id': 15,
      'read': false,
      'created_at': '2026-09-06T22:59:49+03:00',
      'url': 'https://test2.kalivra-world.com/customer/account/orders/view/15',
    });

    expect(notification.id, 'e9d2a2f4-be6c-473b-bd68-8f7e6727e731');
    expect(notification.type, AppNotificationType.orderCanceled);
    expect(notification.rawType, 'order_canceled');
    expect(notification.source, 'kalivra');
    expect(notification.sourceLabel, 'كاليفرا');
    expect(notification.referenceId, '15');
    expect(notification.relatedEntityId, '15');
    expect(notification.isRead, isFalse);
    expect(
      notification.url,
      'https://test2.kalivra-world.com/customer/account/orders/view/15',
    );
  });
}
