import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/view/widgets/app_text_field.dart';
import 'package:kalivra/view/widgets/buttons/custom_icon_button.dart';
import 'package:kalivra/view/widgets/custom_snack_bar.dart';
import 'package:kalivra/view/widgets/drawer/drawer_screen_app_bar.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _update() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    CustomSnackBar.show(context, AppLocalizations.of(context)!.passwordUpdatedSuccess);
    context.pop();
  }

  void _forgotPassword() {
    context.push(AppRoutes.otp, extra: OtpScreenMode.forgotPassword);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final labelColor = isDark ? AppColors.taupe : AppColors.burgundy;

    return Scaffold(
      appBar: DrawerScreenAppBar(title: l10n.changePasswordTitle),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 32.h),
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Padding(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextField(
                      controller: _currentController,
                      label: l10n.currentPassword,
                      hint: '••••••••',
                      obscureText: _obscureCurrent,
                      prefixIcon: Icon(Icons.lock_outline_rounded, size: 22.r, color: labelColor),
                      suffixIcon: CustomIconButton(
                        icon: _obscureCurrent
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded,
                        iconSize: 22.r,
                        color: labelColor,
                        onPressed: () =>
                            setState(() => _obscureCurrent = !_obscureCurrent),
                      ),
                      borderRadius: 12.r,
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? l10n.enterCurrentPassword
                          : null,
                    ),
                    SizedBox(height: 20.h),
                    AppTextField(
                      controller: _newController,
                      label: l10n.newPassword,
                      hint: '••••••••',
                      obscureText: _obscureNew,
                      prefixIcon: Icon(Icons.lock_rounded, size: 22.r, color: labelColor),
                      suffixIcon: CustomIconButton(
                        icon: _obscureNew
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded,
                        iconSize: 22.r,
                        color: labelColor,
                        onPressed: () =>
                            setState(() => _obscureNew = !_obscureNew),
                      ),
                      borderRadius: 12.r,
                      validator: (v) {
                        if (v == null || v.length < 6) {
                          return l10n.passwordMinLength;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20.h),
                    AppTextField(
                      controller: _confirmController,
                      label: l10n.newPasswordConfirm,
                      hint: '••••••••',
                      obscureText: _obscureConfirm,
                      prefixIcon: Icon(Icons.lock_rounded, size: 22.r, color: labelColor),
                      suffixIcon: CustomIconButton(
                        icon: _obscureConfirm
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded,
                        iconSize: 22.r,
                        color: labelColor,
                        onPressed: () =>
                            setState(() => _obscureConfirm = !_obscureConfirm),
                      ),
                      borderRadius: 12.r,
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return l10n.confirmPasswordRequired;
                        }
                        if (v != _newController.text) {
                          return l10n.confirmPasswordMismatch;
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.h),
            FilledButton.icon(
              onPressed: _update,
              icon: Icon(Icons.check_rounded, size: 22.r),
              label: Text(
                l10n.updatePasswordButton,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.offWhite,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: FilledButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
                elevation: 0,
              ),
            ),
            SizedBox(height: 16.h),
            Center(
              child: TextButton.icon(
                onPressed: _forgotPassword,
                icon: Icon(
                  Icons.help_outline_rounded,
                  size: 20.r,
                  color: isDark ? AppColors.goldLight : AppColors.burgundy,
                ),
                label: Text(
                  l10n.forgotPassword,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: isDark ? AppColors.goldLight : AppColors.burgundy,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum OtpScreenMode { forgotPassword, changePhone, signUp }

class OtpOnboardingArgs {
  const OtpOnboardingArgs({
    required this.mode,
    required this.phone,
    this.name,
    this.password,
    this.referralCode,
  });
  final OtpScreenMode mode;
  final String phone;
  final String? name;
  final String? password;
  final String? referralCode;
}