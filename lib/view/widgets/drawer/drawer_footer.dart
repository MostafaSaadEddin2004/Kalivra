import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/l10n/app_localizations.dart';

class DrawerFooter extends StatelessWidget {
  const DrawerFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            isDark ? 'assets/images/light_logo.png' : 'assets/images/coloured_logo.png',
            height: 16.h,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Icon(
              Icons.store_rounded,
              size: 24.r,
              color: theme.colorScheme.onSecondaryFixed,
            ),
          ),
          Text(AppLocalizations.of(context)!.version, style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}
