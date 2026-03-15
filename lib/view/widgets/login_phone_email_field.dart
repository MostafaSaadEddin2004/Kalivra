import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/view/widgets/app_text_field.dart';

class LoginPhoneEmailField extends StatelessWidget {
  const LoginPhoneEmailField({
    super.key,
    required this.controller,
    required this.isEmailMode,
    required this.onToggleMode,
  });

  final TextEditingController controller;
  final bool isEmailMode;
  final VoidCallback onToggleMode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final labelColor = isDark ? AppColors.taupe : AppColors.burgundy;
    final l10n = AppLocalizations.of(context)!;

    final label = isEmailMode ? l10n.email : l10n.phoneLabel;
    final hint = isEmailMode ? l10n.emailHint : '+963 9XX XXX XXX';
    final keyboardType =
        isEmailMode ? TextInputType.emailAddress : TextInputType.phone;
    final prefixIcon = Icon(
      isEmailMode ? Icons.email_outlined : Icons.phone_android_rounded,
      size: 22.r,
      color: labelColor,
    );
    final suffixIcon = IconButton(
      onPressed: onToggleMode,
      icon: Icon(
        isEmailMode ? Icons.phone_android_rounded : Icons.email_outlined,
        size: 22.r,
        color: labelColor,
      ),
      tooltip: isEmailMode ? l10n.phoneLabel : l10n.email,
    );

    return AppTextField(
      controller: controller,
      label: label,
      hint: hint,
      keyboardType: keyboardType,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      validator: (v) {
        if (v == null || v.trim().isEmpty) {
          return isEmailMode ? l10n.enterEmailShort : l10n.enterPhone;
        }
        if (isEmailMode) {
          final emailValid =
              RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v.trim());
          if (!emailValid) return l10n.invalidEmail;
        } else if (v.trim().length < 8) {
          return l10n.invalidPhoneShort;
        }
        return null;
      },
    );
  }
}
