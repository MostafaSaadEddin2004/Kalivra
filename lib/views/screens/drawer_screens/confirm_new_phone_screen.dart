import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/views/widgets/drawer/drawer_screen_app_bar.dart';

/// Onboarding step 3 for change phone: show verified number and confirm.
class ConfirmNewPhoneScreen extends StatelessWidget {
  const ConfirmNewPhoneScreen({super.key, required this.phone});

  final String phone;

  void _confirm(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('تم تغيير رقم الجوال بنجاح'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark
        ? AppColors.taupe.withValues(alpha: 0.5)
        : AppColors.burgundy.withValues(alpha: 0.4);
    final fillColor = isDark
        ? AppColors.burgundy.withValues(alpha: 0.08)
        : AppColors.offWhite;

    return Scaffold(
      appBar: const DrawerScreenAppBar(title: 'تغيير رقم الجوال'),
      body: ListView(
        padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 32.h),
        children: [
          _StepIndicator(step: 3, total: 3),
          SizedBox(height: 24.h),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'تم التحقق من رقم الجوال بنجاح',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isDark ? AppColors.taupe : AppColors.burgundy,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                    decoration: BoxDecoration(
                      color: fillColor,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: borderColor),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.phone_android_rounded,
                          size: 24.r,
                          color: isDark ? AppColors.goldLight : AppColors.burgundy,
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Text(
                            phone,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: isDark ? AppColors.offWhite : AppColors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'اضغط تأكيد لتحديث رقم الجوال في حسابك',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark ? AppColors.taupe : AppColors.burgundy,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 24.h),
          FilledButton.icon(
            onPressed: () => _confirm(context),
            icon: Icon(Icons.check_rounded, size: 22.r),
            label: Text(
              'تأكيد تغيير الرقم',
              style: theme.textTheme.titleMedium?.copyWith(
                color: AppColors.offWhite,
                fontWeight: FontWeight.w700,
              ),
            ),
            style: FilledButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.r),
              ),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({required this.step, required this.total});

  final int step;
  final int total;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final activeColor = isDark ? AppColors.goldLight : AppColors.burgundy;

    return Row(
      children: List.generate(total * 2 - 1, (i) {
        if (i.isOdd) {
          return Expanded(
            child: Container(
              height: 2,
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              color: i ~/ 2 < step ? activeColor : activeColor.withValues(alpha: 0.3),
            ),
          );
        }
        final s = i ~/ 2 + 1;
        final isActive = s <= step;
        return Container(
          width: 28.r,
          height: 28.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? activeColor : activeColor.withValues(alpha: 0.3),
          ),
          child: Center(
            child: isActive
                ? Icon(Icons.check_rounded, size: 16.r, color: AppColors.offWhite)
                : Text(
                    '$s',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: isDark ? AppColors.offWhite : AppColors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
        );
      }),
    );
  }
}
