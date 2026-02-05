import 'package:flutter/material.dart';
import 'package:kalivra/views/widgets/notification_card.dart';
import '../../../core/app_theme.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate([
            NotificationCard(
              title: 'مرحباً بك في Kalivra',
              body: 'اكتشف منتجات البناء والديكور بأسعار منافسة.',
              time: 'الآن',
              icon: Icons.campaign_rounded,
            ),
            NotificationCard(
              title: 'عرض خاص على الدهانات',
              body: 'خصم حتى 20% على تشكيلة الدهانات هذا الأسبوع.',
              time: 'أمس',
              icon: Icons.local_offer_rounded,
            ),
            NotificationCard(
              title: 'طلبك قيد التجهيز',
              body: 'تم استلام طلبك وسيتم الشحن خلال 24 ساعة.',
              time: 'منذ يومين',
              icon: Icons.inventory_2_outlined,
            ),
          ]),
        ),
      ],
    );
  }
}

