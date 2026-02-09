import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/core/app_theme.dart';

class QuantityCounter extends StatelessWidget {
  const QuantityCounter({
    super.key,
    required this.value,
    required this.maxQuantity,
    required this.onChanged,
  });

  final int value;
  final int maxQuantity;
  final void Function(int) onChanged;

  Future<void> _showQuantityLimitDialog(BuildContext context) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(ctx).cardTheme.color,
        title: Text(
          'الحد الأقصى للكمية',
          style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
            color: isDark ? AppColors.offWhite : AppColors.burgundy,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          'عذراً، الحد الأقصى للكمية المتاحة لهذا المنتج هو $maxQuantity.',
          textAlign: TextAlign.center,
          style: Theme.of(ctx).textTheme.bodyLarge?.copyWith(
            color: isDark ? AppColors.taupe : AppColors.black,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final atMax = value >= maxQuantity;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            onPressed: value <= 1 ? null : () => onChanged(value - 1),
            icon: Icon(Icons.remove, size: 18.r),
            color: AppColors.offWhite,
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            style: IconButton.styleFrom(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          SizedBox(
            width: 28.w,
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(color: AppColors.offWhite),
            ),
          ),
          IconButton(
            onPressed: () {
              if (atMax) {
                _showQuantityLimitDialog(context);
              } else {
                onChanged(value + 1);
              }
            },
            icon: Icon(Icons.add, size: 18.r),
            color: AppColors.offWhite,
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            style: IconButton.styleFrom(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }
}
