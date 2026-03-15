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
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final border = borderColor ??
        (isDark ? AppColors.taupe.withValues(alpha: 0.5) : AppColors.burgundy.withValues(alpha: 0.4));
    final fill = fillColor ??
        (isDark ? AppColors.burgundy.withValues(alpha: 0.08) : AppColors.offWhite);
    final label = labelColor ?? (isDark ? AppColors.taupe : AppColors.burgundy);
    final radius = borderRadius ?? 14.r;

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      maxLines: obscureText ? 1 : maxLines,
      enabled: enabled,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      maxLength: maxLength,
      decoration: InputDecoration(
        labelText: this.label,
        hintText: hint,
        counterText: maxLength != null ? '' : null,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
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
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: const BorderSide(color: AppColors.red),
        ),
        labelStyle: TextStyle(color: label),
        hintStyle: TextStyle(color: label.withValues(alpha: 0.6)),
      ),
    );
  }
}
