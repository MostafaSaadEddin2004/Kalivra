import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/core/app_theme.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    this.label = '',
    this.hint = '',
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.enabled = true,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.maxLength,
    this.borderColor,
    this.fillColor,
    this.labelColor,
    this.borderRadius,
    this.textDirection,
    this.readOnly = false,
    this.onTap,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String? value)? validator;
  final void Function(String)? onChanged;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int maxLines;
  final bool enabled;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final int? maxLength;
  final Color? borderColor;
  final Color? fillColor;
  final Color? labelColor;
  final double? borderRadius;
  final TextDirection? textDirection;
  final bool readOnly;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radius = borderRadius ?? 14.r;

    return TextFormField(
      onEditingComplete: () => FocusScope.of(context).nextFocus(),
      textDirection: textDirection,
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      maxLines: obscureText ? 1 : maxLines,
      enabled: enabled,
      readOnly: readOnly,
      onTap: onTap,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      maxLength: maxLength,
      cursorColor: Theme.of(context).colorScheme.inversePrimary,
      cursorWidth: .5.w,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        counterText: maxLength != null ? '' : null,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: theme.colorScheme.secondaryFixed.withValues(alpha: 0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(color: theme.colorScheme.onTertiaryFixed.withValues(alpha: 0.6)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(color: theme.colorScheme.onTertiaryFixed.withValues(alpha: 0.6)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(
            color: theme.colorScheme.onTertiaryFixed.withValues(alpha: 0.6),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: const BorderSide(color: AppColors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: const BorderSide(color: AppColors.red),
        ),
        errorStyle: const TextStyle(color: AppColors.red),
        labelStyle:  theme.textTheme.bodyMedium!.copyWith(
                        color: theme.colorScheme.onTertiaryFixed.withValues(alpha: 0.7),
                      ),
        hintStyle: theme.textTheme.bodyMedium!.copyWith(
                        color: theme.colorScheme.onTertiaryFixed.withValues(alpha: 0.7),
                      ),
          contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      ),
    );
  }
}
