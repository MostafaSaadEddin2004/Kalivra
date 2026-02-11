import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/core/app_theme.dart';
import '../../widgets/drawer/drawer_screen_app_bar.dart';

/// My Account: profile info, contact details, address, and actions.
class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final isDark = theme.brightness == Brightness.dark;
    final labelColor = isDark ? AppColors.taupe : AppColors.burgundy;
    final valueColor = isDark ? AppColors.offWhite : AppColors.black;

    return Scaffold(
      appBar: const DrawerScreenAppBar(title: 'حسابي'),
      body: ListView(
        padding: EdgeInsets.all(20.w),
        children: [
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 48.r,
                  backgroundColor: isDark
                      ? AppColors.burgundy.withValues(alpha: 0.3)
                      : AppColors.burgundy.withValues(alpha: 0.15),
                  child: Icon(
                    Icons.person_rounded,
                    size: 56.r,
                    color: isDark ? AppColors.goldLight : AppColors.burgundy,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  'أحمد محمد',
                  style: textTheme.headlineSmall?.copyWith(
                    color: valueColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'عميل منذ 2024',
                  style: textTheme.bodySmall?.copyWith(
                    color: labelColor,
                  ),
                ),
                SizedBox(height: 8.h),
                FilledButton.icon(
                  onPressed: () => context.push(AppRoutes.editProfile),
                  icon: Icon(Icons.edit_rounded, size: 18.r),
                  label: const Text('تعديل الملف الشخصي'),
                  style: FilledButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 28.h),
          _SectionCard(
            title: 'معلومات الحساب',
            children: [
              _InfoRow(label: 'الاسم الكامل', value: 'أحمد محمد علي', icon: Icons.person_outline_rounded),
              _InfoRow(label: 'البريد الإلكتروني', value: 'ahmed@example.com', icon: Icons.email_outlined),
              _InfoRow(label: 'رقم الجوال', value: '+966 5XX XXX XXXX', icon: Icons.phone_android_rounded),
              _InfoRow(label: 'تاريخ التسجيل', value: 'يناير 2024', icon: Icons.calendar_today_rounded),
            ],
          ),
          SizedBox(height: 16.h),
          _SectionCard(
            title: 'العنوان',
            children: [
              _InfoRow(
                label: 'العنوان الرئيسي',
                value: 'الرياض، حي النخيل، شارع الملك فهد',
                icon: Icons.location_on_outlined,
              ),
              _InfoRow(label: 'الرمز البريدي', value: '12345', icon: Icons.markunread_mailbox_rounded),
            ],
          ),
          SizedBox(height: 16.h),
          _SectionCard(
            title: 'إحصائيات',
            children: [
              _StatRow(label: 'عدد الطلبات', value: '12', icon: Icons.receipt_long_rounded),
              _StatRow(label: 'طلبات قيد التنفيذ', value: '2', icon: Icons.hourglass_top_rounded),
            ],
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                color: isDark ? AppColors.goldLight : AppColors.burgundy,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 12.h),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final labelColor = isDark ? AppColors.taupe : AppColors.burgundy;
    final valueColor = isDark ? AppColors.offWhite : AppColors.black;

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22.r, color: labelColor),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(color: labelColor),
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: valueColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          Icon(icon, size: 22.r, color: isDark ? AppColors.goldLight : AppColors.burgundy),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: isDark ? AppColors.offWhite : AppColors.black,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.burgundy.withValues(alpha: 0.3)
                  : AppColors.burgundy.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                color: isDark ? AppColors.goldLight : AppColors.burgundy,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
