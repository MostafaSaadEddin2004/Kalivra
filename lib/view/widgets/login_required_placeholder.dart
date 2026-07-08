import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/l10n/app_localizations.dart';

class LoginRequiredPlaceholder extends StatelessWidget {
  const LoginRequiredPlaceholder({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.onLoginTap,
  });

  final IconData icon;
  final String title;
  final String description;
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
              icon,
              size: 64.r,
              color: isDark
                  ? AppColors.taupe
                  : AppColors.burgundy.withValues(alpha: 0.6),
            ),
            SizedBox(height: 20.h),
            Text(
              title,
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),
            Text(
              description,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark
                    ? AppColors.taupe
                    : AppColors.burgundy.withValues(alpha: 0.8),
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
              child: Text(AppLocalizations.of(context)!.signIn),
            ),
          ],
        ),
      ),
    );
  }
}
