import 'package:flutter/material.dart';
import '../../../core/app_theme.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Text(
              'الإشعارات',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.burgundy,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            _NotificationTile(
              title: 'مرحباً بك في Kalivra',
              body: 'اكتشف منتجات البناء والديكور بأسعار منافسة.',
              time: 'الآن',
              icon: Icons.campaign_rounded,
            ),
            _NotificationTile(
              title: 'عرض خاص على الدهانات',
              body: 'خصم حتى 20% على تشكيلة الدهانات هذا الأسبوع.',
              time: 'أمس',
              icon: Icons.local_offer_rounded,
            ),
            _NotificationTile(
              title: 'طلبك قيد التجهيز',
              body: 'تم استلام طلبك وسيتم الشحن خلال 24 ساعة.',
              time: 'منذ يومين',
              icon: Icons.inventory_2_outlined,
            ),
          ]),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Text(
                'لا توجد المزيد من الإشعارات',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.taupe,
                    ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({
    required this.title,
    required this.body,
    required this.time,
    required this.icon,
  });

  final String title;
  final String body;
  final String time;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.goldLight.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.goldDark, size: 24),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppColors.burgundy,
                fontWeight: FontWeight.w600,
              ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            body,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.black.withValues(alpha: 0.7),
                ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        trailing: Text(
          time,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.taupe,
              ),
        ),
        onTap: () {},
      ),
    );
  }
}
