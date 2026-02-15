import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/views/widgets/buttons/custom_icon_button.dart';

class CustomDrawerHeader extends StatelessWidget {
  const CustomDrawerHeader({super.key, required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final topPadding = MediaQuery.paddingOf(context).top;
    final statusBarBrightness = ThemeData.estimateBrightnessForColor(primary) == Brightness.dark
        ? Brightness.light
        : Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: primary,
        statusBarIconBrightness: statusBarBrightness,
        statusBarBrightness: statusBarBrightness,
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(
          top: topPadding + 12.h,
          bottom: 12.h,
          left: 16.w,
          right: 16.w,
        ),
        color: primary,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'القائمة',
              style: theme.textTheme.headlineLarge,
            ),
            const Spacer(),
            CustomIconButton(
              icon: Icons.close_rounded,
              color: AppColors.offWhite,
              iconSize: 26.r,
              onPressed: onClose,
              tooltip: 'إغلاق',
            ),
          ],
        ),
      ),
    );
  }
}
