import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/view/screens/drawer_screens/change_password_screen.dart';
import 'package:kalivra/view/widgets/buttons/custom_icon_button.dart';
import 'package:kalivra/view/widgets/referral/referral_code_field.dart';

/// Sign up: phone, name, password, confirm password. On submit → OTP phone (signup).
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _referralCodeController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _referralCodeController.dispose();
    super.dispose();
  }

  void _signUp() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
      final referralCode = _referralCodeController.text.trim();
      context.push(
        AppRoutes.otp,
        extra: OtpOnboardingArgs(
          mode: OtpScreenMode.signUp,
          phone: _phoneController.text.trim(),
          name: _nameController.text.trim(),
          password: _passwordController.text,
          referralCode: referralCode.isEmpty ? null : referralCode,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark
        ? AppColors.taupe.withValues(alpha: 0.5)
        : AppColors.burgundy.withValues(alpha: 0.4);
    final fillColor = isDark
        ? AppColors.burgundy.withValues(alpha: 0.08)
        : AppColors.offWhite;
    final labelColor = isDark ? AppColors.taupe : AppColors.burgundy;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
         padding: EdgeInsets.only(left: 24.w,top: 40.h,right: 24.w,bottom: 32.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  AppLocalizations.of(context)!.signUp,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: isDark ? AppColors.offWhite : AppColors.burgundy,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  AppLocalizations.of(context)!.signUpHint,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isDark ? AppColors.taupe : AppColors.burgundy,
                  ),
                ),
                SizedBox(height: 32.h),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return AppLocalizations.of(context)!.enterPhone;
                    if (v.trim().length < 8) return AppLocalizations.of(context)!.invalidPhoneShort;
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.phoneLabel,
                    hintText: '+963 9XX XXX XXX',
                    prefixIcon: Icon(
                      Icons.phone_android_rounded,
                      size: 22.r,
                      color: labelColor,
                    ),
                    filled: true,
                    fillColor: fillColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: BorderSide(color: borderColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: BorderSide(color: borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: BorderSide(
                        color: isDark
                            ? AppColors.goldLight
                            : AppColors.burgundy,
                        width: 1.5,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: const BorderSide(color: AppColors.red),
                    ),
                    labelStyle: TextStyle(color: labelColor),
                    hintStyle: TextStyle(
                      color: labelColor.withValues(alpha: 0.6),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                TextFormField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return AppLocalizations.of(context)!.enterName;
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.fullName,
                    hintText: AppLocalizations.of(context)!.enterName,
                    prefixIcon: Icon(
                      Icons.person_outline_rounded,
                      size: 22.r,
                      color: labelColor,
                    ),
                    filled: true,
                    fillColor: fillColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: BorderSide(color: borderColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: BorderSide(color: borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: BorderSide(
                        color: isDark
                            ? AppColors.goldLight
                            : AppColors.burgundy,
                        width: 1.5,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: const BorderSide(color: AppColors.red),
                    ),
                    labelStyle: TextStyle(color: labelColor),
                    hintStyle: TextStyle(
                      color: labelColor.withValues(alpha: 0.6),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  validator: (v) {
                    if (v == null || v.isEmpty) return AppLocalizations.of(context)!.enterPassword;
                    if (v.length < 6) return AppLocalizations.of(context)!.passwordMinLength;
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.passwordLabel,
                    hintText: '••••••••',
                    prefixIcon: Icon(
                      Icons.lock_outline_rounded,
                      size: 22.r,
                      color: labelColor,
                    ),
                    suffixIcon: CustomIconButton(
                      icon: _obscurePassword
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                      iconSize: 22.r,
                      color: labelColor,
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    filled: true,
                    fillColor: fillColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: BorderSide(color: borderColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: BorderSide(color: borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: BorderSide(
                        color: isDark
                            ? AppColors.goldLight
                            : AppColors.burgundy,
                        width: 1.5,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: const BorderSide(color: AppColors.red),
                    ),
                    labelStyle: TextStyle(color: labelColor),
                    hintStyle: TextStyle(
                      color: labelColor.withValues(alpha: 0.6),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),

                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirm,
                  validator: (v) {
                    if (v == null || v.isEmpty) return AppLocalizations.of(context)!.confirmPasswordRequired;
                    if (v != _passwordController.text) {
                      return AppLocalizations.of(context)!.passwordsDoNotMatch;
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.confirmPassword,
                    hintText: '••••••••',
                    prefixIcon: Icon(
                      Icons.lock_outline_rounded,
                      size: 22.r,
                      color: labelColor,
                    ),
                    suffixIcon: CustomIconButton(
                      icon: _obscureConfirm
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                      iconSize: 22.r,
                      color: labelColor,
                      onPressed: () =>
                          setState(() => _obscureConfirm = !_obscureConfirm),
                    ),
                    filled: true,
                    fillColor: fillColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: BorderSide(color: borderColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: BorderSide(color: borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: BorderSide(
                        color: isDark
                            ? AppColors.goldLight
                            : AppColors.burgundy,
                        width: 1.5,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: const BorderSide(color: AppColors.red),
                    ),
                    labelStyle: TextStyle(color: labelColor),
                    hintStyle: TextStyle(
                      color: labelColor.withValues(alpha: 0.6),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                ReferralCodeField(
                  controller: _referralCodeController,
                  bottomSpacing: 20,
                ),
                SizedBox(height: 32.h),
                FilledButton(
                  onPressed: _isLoading ? null : _signUp,
                  style: FilledButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? SizedBox(
                          height: 24.h,
                          width: 24.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.offWhite,
                          ),
                        )
                      : Text(
                          AppLocalizations.of(context)!.continueVerification,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: AppColors.offWhite,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
                SizedBox(height: 24.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.haveAccount,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDark ? AppColors.taupe : AppColors.burgundy,
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.go(AppRoutes.login),
                      child: Text(
                        AppLocalizations.of(context)!.login,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: AppColors.goldLight,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
