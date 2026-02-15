import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/views/widgets/buttons/counter_button.dart';

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
    final atMax = value >= maxQuantity;
    return Row(
      spacing: 4.w,
      mainAxisSize: MainAxisSize.min,
      children: [
        CounterButton(
          icon: Icons.remove_rounded,
          onTap: () {
            if (value > 1) onChanged(value - 1);
          },
        ),
        SizedBox(
          width: 18.w,
          child: Text(
            '$value',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
        CounterButton(
          icon: Icons.add_rounded,
          onTap: () {
            if (atMax) {
              _showQuantityLimitDialog(context);
            } else {
              onChanged(value + 1);
            }
          },
        ),
      ],
    );
  }
}
