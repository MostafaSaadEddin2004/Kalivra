import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/l10n/app_localizations.dart';

class CheckoutStepIndicator extends StatelessWidget {
  const CheckoutStepIndicator({
    super.key,
    required this.currentStep,
    this.onStepTap,
  });

  final int currentStep;
  final ValueChanged<int>? onStepTap;

  static const _icons = [
    Icons.person_outline_rounded,
    Icons.local_shipping_outlined,
    Icons.payment_rounded,
    Icons.shopping_cart_outlined,
  ];

  static List<String> _labels(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return [l10n.checkoutStepAddress, l10n.checkoutStepShipping, l10n.checkoutStepPayment, l10n.checkoutStepComplete];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final activeColor = AppColors.offWhite;
    final inactiveColor = isDark
        ? AppColors.taupe.withValues(alpha: 0.5)
        : AppColors.burgundy.withValues(alpha: 0.5);
    final labels = _labels(context);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
      color: isDark
          ? const Color(0xFF1A1918)
          : AppColors.burgundy.withValues(alpha: 0.06),
      child: Row(
        children: List.generate(7, (i) {
          if (i.isOdd) {
            final stepIndex = i ~/ 2;
            final isPast = stepIndex < currentStep;
            return Expanded(
              child: Container(
                height: 2.h,
                margin: EdgeInsets.only(bottom: 28.h),
                color: isPast ? activeColor : inactiveColor,
              ),
            );
          }
          final index = i ~/ 2;
          final isActive = index == currentStep;
          final isPast = index < currentStep;
          final color = isActive || isPast ? activeColor : inactiveColor;
          return InkWell(
            onTap: onStepTap != null && (isPast || isActive)
                ? () => onStepTap!(index)
                : null,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40.r,
                  height: 40.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive
                        ? (isDark ? AppColors.taupe : AppColors.burgundy)
                        : (isDark ? const Color(0xFF2A2928) : Colors.white),
                    border: Border.all(color: color, width: 1.5),
                  ),
                  child: Icon(_icons[index], size: 20.r, color: color),
                ),
                SizedBox(height: 6.h),
                Text(
                  labels[index],
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: color,
                    fontSize: 11.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
