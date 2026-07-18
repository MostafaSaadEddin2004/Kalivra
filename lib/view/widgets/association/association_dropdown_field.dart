import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/l10n/app_localizations.dart';

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
    final activeColor = isDark ? AppColors.goldLight : AppColors.burgundy;
    final disabledIconColor = AppColors.lightGray;
    final radius = 14.r;
    final canSelect = enabled && items.isNotEmpty;
    final selectedValue =
        value != null && value!.isNotEmpty && items.contains(value)
        ? value
        : null;
    final searchHint = AppLocalizations.of(context)?.navSearch ?? 'Search';

    InputDecoration dropdownDecoration({String? hint}) {
      return InputDecoration(
        isDense: true,
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
          borderSide: BorderSide(color: activeColor),
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
        hintText: hint,
        hintStyle: TextStyle(color: activeColor.withValues(alpha: 0.72)),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      );
    }

    return AdaptiveDropdownSearch<String>(
      context: context,
      key: ValueKey('$label-$value-${items.join('|')}'),
      selectedItem: selectedValue,
      enabled: canSelect,
      items: (_, _) => items,
      itemAsString: (item) => itemLabelBuilder?.call(item) ?? item,
      onSelected: onChanged,
      validator: validator,
      textProps: TextProps(
        style: theme.textTheme.bodyMedium?.copyWith(color: activeColor),
      ),
      suffixProps: DropdownSuffixProps(
        dropdownButtonProps: DropdownButtonProps(
          iconClosed: Icon(Icons.arrow_drop_down_rounded, size: 24.r),
          color: canSelect ? activeColor : disabledIconColor,
          disabledColor: disabledIconColor,
        ),
      ),
      popupProps: AdaptivePopupProps(
        cupertinoProps: CupertinoPopupProps.bottomSheet(showSearchBox: true),
        materialProps: PopupProps.menu(
          showSearchBox: true,
          fit: FlexFit.loose,
          searchFieldProps: TextFieldProps(
            cursorColor: activeColor,
            style: theme.textTheme.bodyMedium?.copyWith(color: activeColor),
            decoration: dropdownDecoration(hint: searchHint).copyWith(
              prefixIcon: Icon(Icons.search_rounded, color: activeColor),
              prefixIconConstraints: BoxConstraints(
                minWidth: 40.w,
                minHeight: 40.h,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 10.w,
                vertical: 8.h,
              ),
            ),
          ),
          itemBuilder: (context, item, isDisabled, isSelected) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
              child: Text(
                itemLabelBuilder?.call(item) ?? item,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: activeColor,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            );
          },
        ),
      ),
      decoratorProps: DropDownDecoratorProps(
        baseStyle: theme.textTheme.bodyMedium?.copyWith(color: activeColor),
        decoration: dropdownDecoration(hint: hintText).copyWith(
          labelText: label,
          suffixIcon: trailing,
          suffixIconConstraints: trailing == null
              ? null
              : BoxConstraints(minWidth: 48.w, minHeight: 48.h),
        ),
      ),
    );
  }
}
