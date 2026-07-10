import 'package:dropdown_search/dropdown_search.dart';
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
    this.hintText,
    this.trailing,
    this.itemLabelBuilder,
    this.validator,
  });

  final String label;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final bool enabled;
  final String? hintText;
  final Widget? trailing;
  final String Function(String item)? itemLabelBuilder;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final border = isDark
        ? AppColors.taupe.withValues(alpha: 0.5)
        : AppColors.burgundy.withValues(alpha: 0.4);
    final fill = isDark
        ? AppColors.black.withValues(alpha: 0.08)
        : AppColors.offWhite;
    final labelColor = isDark ? AppColors.taupe : AppColors.burgundy;
    final radius = 14.r;
    final canSelect = enabled && items.isNotEmpty;
    final selectedValue =
        value != null && value!.isNotEmpty && items.contains(value)
        ? value
        : null;

    return AdaptiveDropdownSearch<String>(
      context: context,
      key: ValueKey('$label-$value-${items.join('|')}'),
      selectedItem: selectedValue,
      enabled: canSelect,
      items: (_, _) => items,
      itemAsString: (item) => itemLabelBuilder?.call(item) ?? item,
      onSelected: onChanged,
      validator: validator,
      popupProps: AdaptivePopupProps(
        cupertinoProps: CupertinoPopupProps.bottomSheet(showSearchBox: true),
        materialProps: PopupProps.menu(showSearchBox: true,fit: FlexFit.tight),
      ),
      decoratorProps: DropDownDecoratorProps(
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
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
            borderSide: BorderSide(color: theme.colorScheme.error),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
            borderSide: BorderSide(color: theme.colorScheme.error),
          ),
          labelStyle: TextStyle(color: labelColor),
          hintText: hintText,
          suffixIcon: trailing,
          suffixIconConstraints: trailing == null
              ? null
              : BoxConstraints(minWidth: 48.w, minHeight: 48.h),
        ),
      ),
    );
  }
}
