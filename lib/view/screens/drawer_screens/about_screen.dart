import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import '../../widgets/drawer/drawer_screen_app_bar.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: DrawerScreenAppBar(title: l10n.drawerAboutApp),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Column(
          children: [
            SizedBox(height: 24.h),
            Container(
              padding: EdgeInsets.all(24.r),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.burgundy.withValues(alpha: 0.25)
                    : AppColors.burgundy.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.store_rounded,
                size: 64.r,
                color: isDark ? AppColors.goldLight : AppColors.burgundy,
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'Kalivra',
              style: theme.textTheme.headlineMedium?.copyWith(
                color: isDark ? AppColors.offWhite : AppColors.burgundy,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              l10n.version,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark ? AppColors.taupe : AppColors.black,
              ),
            ),
            SizedBox(height: 28.h),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
              child: Padding(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.drawerAboutApp,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: isDark ? AppColors.goldLight : AppColors.burgundy,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      l10n.aboutAppDescription,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: isDark ? AppColors.offWhite : AppColors.black,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}