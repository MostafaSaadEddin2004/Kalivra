import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import '../../widgets/drawer/drawer_screen_app_bar.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: DrawerScreenAppBar(title: l10n.drawerPrivacyPolicy),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Text(
              l10n.privacyPolicyContent,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: isDark ? AppColors.offWhite : AppColors.black,
                height: 1.6,
              ),
            ),
          ),
        ),
      ),
    );
  }
}