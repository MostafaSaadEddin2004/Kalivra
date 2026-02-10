import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/core/app_theme.dart';
import '../../widgets/drawer/drawer_screen_app_bar.dart';

/// Share: invite others to the app.
class ShareScreen extends StatelessWidget {
  const ShareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: const DrawerScreenAppBar(title: 'مشاركة'),
      body: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.share_rounded,
              size: 80.r,
              color: isDark ? AppColors.goldLight : AppColors.burgundy,
            ),
            SizedBox(height: 24.h),
            Text(
              'شارك التطبيق مع أصدقائك',
              style: theme.textTheme.titleLarge?.copyWith(
                color: isDark ? AppColors.offWhite : AppColors.burgundy,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              'ساعد الآخرين على اكتشاف كليفرة واستمتع بتجربة التسوق معاً',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark ? AppColors.taupe : AppColors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.h),
            FilledButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم نسخ الرابط'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              icon: Icon(Icons.share_rounded, size: 24.r),
              label: const Text('مشاركة التطبيق'),
              style: FilledButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
                minimumSize: Size(double.infinity, 52.h),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
