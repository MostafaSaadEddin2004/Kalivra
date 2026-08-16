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
    Icons.receipt_long_outlined,
  ];

  static List<String> _labels(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return [
      l10n.checkoutStepAddress,
      l10n.checkoutStepShipping,
      l10n.checkoutStepPayment,
      l10n.orderSummary,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final labels = _labels(context);
    final inactive = colorScheme.primaryFixed.withValues(alpha: 0.18);

    return Padding(
      padding: EdgeInsets.fromLTRB(12.w, 18.h, 12.w, 8.h),
      child: Row(
        children: List.generate(7, (i) {
          if (i.isOdd) {
            final stepIndex = i ~/ 2;
            final filled = stepIndex < currentStep;
            return Expanded(
              child: Container(
                height: 1.2.h,
                margin: EdgeInsets.only(bottom: 28.h),
                color: filled ? AppColors.burgundy : inactive,
              ),
            );
          }

          final index = i ~/ 2;
          final isActive = index == currentStep;
          final isPast = index < currentStep;
          final iconColor = isActive
              ? colorScheme.secondaryFixed
              : AppColors.burgundy;

          return InkWell(
            onTap: onStepTap != null && (isPast || isActive)
                ? () => onStepTap!(index)
                : null,
            borderRadius: BorderRadius.circular(28.r),
            child: SizedBox(
              width: 64.w,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40.r,
                    height: 40.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActive ? AppColors.burgundy : Colors.white,
                      border: Border.all(
                        color: isActive ? AppColors.burgundy : inactive,
                        width: 1.2.w,
                      ),
                    ),
                    child: Icon(_icons[index], size: 19.r, color: iconColor),
                  ),
                  SizedBox(height: 7.h),
                  Text(
                    labels[index],
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: isActive
                          ? AppColors.burgundy
                          : colorScheme.primaryFixed.withValues(alpha: 0.62),
                      fontWeight: isActive ? FontWeight.w800 : FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
