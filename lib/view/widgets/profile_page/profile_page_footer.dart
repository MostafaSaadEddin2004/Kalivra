import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/l10n/app_localizations.dart';

class ProfilePageFooter extends StatelessWidget {
  const ProfilePageFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context)!.version,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.primaryFixed.withValues(alpha: 0.55),
            ),
          ),
          SizedBox(height: 4.h),
          Image.asset(
            isDark
                ? 'assets/images/light_logo.png'
                : 'assets/images/coloured_logo.png',
            height: 18.h,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Icon(
              Icons.store_rounded,
              size: 24.r,
              color: theme.colorScheme.onSecondaryFixed,
            ),
          ),
        ],
      ),
    );
  }
}
