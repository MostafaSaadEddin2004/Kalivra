import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/core/app_theme.dart';
import '../../widgets/drawer/drawer_screen_app_bar.dart';

/// Contact Us: phone, email, and optional form.
class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: const DrawerScreenAppBar(title: 'تواصل معنا'),
      body: ListView(
        padding: EdgeInsets.all(20.w),
        children: [
          Text(
            'نسعد بتواصلك معنا',
            style: theme.textTheme.titleMedium?.copyWith(
              color: isDark ? AppColors.offWhite : AppColors.burgundy,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'يمكنك التواصل معنا عبر القنوات التالية أو إرسال رسالة',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isDark ? AppColors.taupe : AppColors.black,
            ),
          ),
          SizedBox(height: 24.h),
          _ContactCard(
            icon: Icons.phone_rounded,
            title: 'الهاتف',
            value: '+966 XX XXX XXXX',
            onTap: () {},
          ),
          SizedBox(height: 12.h),
          _ContactCard(
            icon: Icons.email_rounded,
            title: 'البريد الإلكتروني',
            value: 'support@kalivra.com',
            onTap: () {},
          ),
          SizedBox(height: 12.h),
          _ContactCard(
            icon: Icons.schedule_rounded,
            title: 'ساعات العمل',
            value: 'السبت - الخميس: 9 ص - 9 م',
            onTap: null,
          ),
          SizedBox(height: 28.h),
          Text(
            'أرسل رسالة',
            style: theme.textTheme.titleSmall?.copyWith(
              color: isDark ? AppColors.goldLight : AppColors.burgundy,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 12.h),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'الموضوع',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
                      filled: true,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  TextField(
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: 'الرسالة',
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
                      filled: true,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {},
                      style: FilledButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                      ),
                      child: const Text('إرسال'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  const _ContactCard({
    required this.icon,
    required this.title,
    required this.value,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final child = Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.burgundy.withValues(alpha: 0.3)
                    : AppColors.burgundy.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, size: 28.r, color: isDark ? AppColors.goldLight : AppColors.burgundy),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark ? AppColors.taupe : AppColors.burgundy,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    value,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: isDark ? AppColors.offWhite : AppColors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 18.r,
                color: isDark ? AppColors.taupe : AppColors.burgundy,
              ),
          ],
        ),
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: child,
      );
    }
    return child;
  }
}
