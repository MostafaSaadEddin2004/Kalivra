import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/view/widgets/buttons/counter_button.dart';

class QuantityCounter extends StatelessWidget {
  const QuantityCounter({
    super.key,
    required this.value,
    required this.onChanged,
    this.maxQuantity,
    this.enabled = true,
  });

  final int value;
  final int? maxQuantity;
  final bool enabled;
  final void Function(int) onChanged;

  void _showQuantityLimitDialog(BuildContext context) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final limit = maxQuantity;
    if (limit == null) return;

    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(ctx).cardTheme.color,
        title: Text(
          l10n.quantityLimitTitle,
          style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
            color: isDark ? AppColors.offWhite : AppColors.burgundy,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          l10n.quantityLimitMessage(limit),
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
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final limit = maxQuantity;
    final atMax = limit != null && value >= limit;

    return Opacity(
      opacity: enabled ? 1 : 0.55,
      child: Row(
        spacing: 4.w,
        mainAxisSize: MainAxisSize.min,
        children: [
          CounterButton(
            icon: Icons.remove_rounded,
            onTap: () {
              if (!enabled) return;
              if (value > 1) onChanged(value - 1);
            },
          ),
          SizedBox(
            width: 28.w,
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ),
          CounterButton(
            icon: Icons.add_rounded,
            onTap: () {
              if (!enabled) return;
              if (atMax) {
                _showQuantityLimitDialog(context);
              } else {
                onChanged(value + 1);
              }
            },
          ),
        ],
      ),
    );
  }
}
