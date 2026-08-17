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
    this.showDropdownIcon = true,
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
  final bool showDropdownIcon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
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
      textProps: TextProps(
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.primaryFixed,
        ),
      ),
      suffixProps: DropdownSuffixProps(
        dropdownButtonProps: DropdownButtonProps(
          isVisible: showDropdownIcon,
          iconClosed: Icon(Icons.arrow_drop_down_rounded, size: 24.r),
          color: canSelect
              ? theme.colorScheme.onTertiaryFixed
              : AppColors.lightGray,
          disabledColor: AppColors.lightGray,
        ),
      ),
      popupProps: AdaptivePopupProps(
        cupertinoProps: CupertinoPopupProps.bottomSheet(showSearchBox: true),
        materialProps: PopupProps.menu(
          showSearchBox: true,
          fit: FlexFit.loose,
          searchFieldProps: TextFieldProps(
            cursorColor: theme.colorScheme.onTertiaryFixedVariant,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onTertiaryFixedVariant,
            ),
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: theme.colorScheme.secondaryFixed.withValues(
                alpha: 0.05,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(radius),
                borderSide: BorderSide(
                  color: theme.colorScheme.onTertiaryFixedVariant.withValues(
                    alpha: 0.6,
                  ),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(radius),
                borderSide: BorderSide(
                  color: theme.colorScheme.onTertiaryFixedVariant.withValues(
                    alpha: 0.6,
                  ),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(radius),
                borderSide: BorderSide(
                  color: theme.colorScheme.onTertiaryFixedVariant.withValues(
                    alpha: 0.6,
                  ),
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(radius),
                borderSide: BorderSide(
                  color: theme.colorScheme.onTertiaryFixedVariant.withValues(
                    alpha: 0.3,
                  ),
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(radius),
                borderSide: BorderSide(color: theme.colorScheme.onError),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(radius),
                borderSide: BorderSide(color: theme.colorScheme.onError),
              ),
              hintText: l10n.search,
              hintStyle: theme.textTheme.bodyMedium!.copyWith(
                color: theme.colorScheme.onTertiaryFixedVariant.withValues(
                  alpha: 0.7,
                ),
              ),
              labelStyle: theme.textTheme.bodyMedium!.copyWith(
                color: theme.colorScheme.onTertiaryFixedVariant.withValues(
                  alpha: 0.7,
                ),
              ),
              prefixIconConstraints: BoxConstraints(
                minWidth: 40.w,
                minHeight: 40.h,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 10.w,
                vertical: 8.h,
              ),
              prefixIcon: Icon(
                Icons.search_rounded,
                color: theme.colorScheme.onTertiaryFixedVariant,
              ),
            ),
          ),
          itemBuilder: (context, item, isDisabled, isSelected) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
              child: Text(
                itemLabelBuilder?.call(item) ?? item,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onTertiaryFixedVariant,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            );
          },
        ),
      ),
      decoratorProps: DropDownDecoratorProps(
        baseStyle: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onTertiaryFixed,
        ),
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          fillColor: theme.colorScheme.secondaryFixed.withValues(alpha: 0.05),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
            borderSide: BorderSide(
              color: theme.colorScheme.onTertiaryFixed.withValues(alpha: 0.6),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
            borderSide: BorderSide(
              color: theme.colorScheme.onTertiaryFixed.withValues(alpha: 0.6),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
            borderSide: BorderSide(
              color: theme.colorScheme.onTertiaryFixed.withValues(alpha: 0.6),
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
            borderSide: BorderSide(
              color: theme.colorScheme.onTertiaryFixed.withValues(alpha: 0.3),
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
            borderSide: BorderSide(color: theme.colorScheme.onError),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
            borderSide: BorderSide(color: theme.colorScheme.onError),
          ),
          hintText: label,
          hintStyle: theme.textTheme.bodyMedium!.copyWith(
            color: theme.colorScheme.onTertiaryFixed.withValues(alpha: 0.7),
          ),
          labelStyle: theme.textTheme.bodyMedium!.copyWith(
            color: theme.colorScheme.onTertiaryFixed.withValues(alpha: 0.7),
          ),
          prefixIcon: trailing,
          prefixIconConstraints: BoxConstraints(
            minWidth: 40.w,
            minHeight: 40.h,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
        ),
      ),
    );
  }
}
