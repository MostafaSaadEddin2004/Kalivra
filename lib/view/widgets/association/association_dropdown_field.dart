import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/core/app_theme.dart';

class AssociationDropdownField extends StatelessWidget {
  const AssociationDropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.enabled = true,
    this.validator,
  });

  final String label;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final bool enabled;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final border = isDark
        ? AppColors.taupe.withValues(alpha: 0.5)
        : AppColors.burgundy.withValues(alpha: 0.4);
    final fill = isDark
        ? AppColors.burgundy.withValues(alpha: 0.08)
        : AppColors.offWhite;
    final labelColor = isDark ? AppColors.taupe : AppColors.burgundy;
    final radius = 14.r;
    final canSelect = enabled && items.isNotEmpty;

    return DropdownButtonFormField<String?>(
      key: ValueKey('$label-$value-${items.join('|')}'),
      initialValue: value != null && value!.isNotEmpty ? value : null,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: fill,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(
            color: isDark ? AppColors.goldLight : AppColors.burgundy,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(color: border.withValues(alpha: 0.35)),
        ),
        labelStyle: TextStyle(color: labelColor),
      ),
      items: items
          .map(
            (item) => DropdownMenuItem<String?>(value: item, child: Text(item)),
          )
          .toList(),
      onChanged: canSelect ? onChanged : null,
      validator: validator,
    );
  }
}
