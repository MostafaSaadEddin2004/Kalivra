import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/controllers/blocs/cubit/notifications_cubit/notifications_cubit.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/views/widgets/cards/notification_card.dart';

/// Notifications tab. Login-required check is in [NotificationsCubit].
class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationsCubit>().refresh();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsCubit, NotificationsState>(
      builder: (context, state) {
        if (state.loginRequired) {
          return _LoginRequiredPlaceholder(
            onLoginTap: () => context.push(AppRoutes.login),
          );
        }
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
      },
    );
  }
}

class _LoginRequiredPlaceholder extends StatelessWidget {
  const _LoginRequiredPlaceholder({required this.onLoginTap});

  final VoidCallback onLoginTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_off_outlined,
              size: 64.r,
              color: isDark ? AppColors.taupe : AppColors.burgundy.withValues(alpha: 0.6),
            ),
            SizedBox(height: 20.h),
            Text(
              'يجب تسجيل الدخول لعرض الإشعارات',
              style: theme.textTheme.titleMedium?.copyWith(
                color: isDark ? AppColors.offWhite : AppColors.burgundy,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),
            Text(
              'سجّل الدخول أو أنشئ حساباً لاستلام إشعارات الطلبات والعروض.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark ? AppColors.taupe : AppColors.burgundy.withValues(alpha: 0.8),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            FilledButton(
              onPressed: onLoginTap,
              style: FilledButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: const Text('تسجيل الدخول'),
            ),
          ],
        ),
      ),
    );
  }
}
