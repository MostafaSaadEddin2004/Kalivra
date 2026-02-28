import 'package:flutter/material.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/views/widgets/buttons/custom_icon_button.dart';
import 'package:kalivra/views/widgets/custom_snack_bar.dart';
import '../../widgets/drawer/drawer_screen_app_bar.dart';

/// Rate the app: stars and feedback.
class RateScreen extends StatelessWidget {
  const RateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: const DrawerScreenAppBar(title: 'تقييم'),
      body: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.star_rounded,
              size: 80.r,
              color: isDark ? AppColors.goldLight : AppColors.burgundy,
            ),
            SizedBox(height: 24.h),
            Text(
              'كيف تقيم تجربتك معنا؟',
              style: theme.textTheme.titleLarge?.copyWith(
                color: isDark ? AppColors.offWhite : AppColors.burgundy,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (i) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: CustomIconButton(
                    icon: Icons.star_rounded,
                    iconSize: 40.r,
                    color: isDark ? AppColors.goldLight : AppColors.burgundy,
                    onPressed: () {
                      CustomSnackBar.show(
                        context,
                        'شكراً لتقييمك! (${i + 1} نجوم)',
                      );
                    },
                  ),
                );
              }),
            ),
            SizedBox(height: 32.h),
            FilledButton(
              onPressed: () {
                CustomSnackBar.show(context, 'شكراً لتقييمك');
              },
              style: FilledButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
                minimumSize: Size(double.infinity, 52.h),
              ),
              child: Text(AppLocalizations.of(context)!.submitRating),
            ),
          ],
        ),
      ),
    );
  }
}
