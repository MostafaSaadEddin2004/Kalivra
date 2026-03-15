import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/view/screens/drawer_screens/change_password_screen.dart';
import 'package:kalivra/view/widgets/app_text_field.dart';
import 'package:kalivra/view/widgets/buttons/custom_icon_button.dart';
import 'package:kalivra/view/widgets/referral/referral_code_field.dart';

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
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
                AppTextField(
                  controller: _phoneController,
                  label: AppLocalizations.of(context)!.phoneLabel,
                  hint: '+963 9XX XXX XXX',
                  keyboardType: TextInputType.phone,
                  prefixIcon: Icon(
                    Icons.phone_android_rounded,
                    size: 22.r,
                    color: labelColor,
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return AppLocalizations.of(context)!.enterPhone;
                    if (v.trim().length < 8) return AppLocalizations.of(context)!.invalidPhoneShort;
                    return null;
                  },
                ),
                SizedBox(height: 20.h),
                AppTextField(
                  controller: _nameController,
                  label: AppLocalizations.of(context)!.fullName,
                  hint: AppLocalizations.of(context)!.enterName,
                  textCapitalization: TextCapitalization.words,
                  prefixIcon: Icon(
                    Icons.person_outline_rounded,
                    size: 22.r,
                    color: labelColor,
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return AppLocalizations.of(context)!.enterName;
                    return null;
                  },
                ),
                SizedBox(height: 20.h),
                AppTextField(
                  controller: _passwordController,
                  label: AppLocalizations.of(context)!.passwordLabel,
                  hint: '••••••••',
                  obscureText: _obscurePassword,
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
                  validator: (v) {
                    if (v == null || v.isEmpty) return AppLocalizations.of(context)!.enterPassword;
                    if (v.length < 6) return AppLocalizations.of(context)!.passwordMinLength;
                    return null;
                  },
                ),
                SizedBox(height: 20.h),
                AppTextField(
                  controller: _confirmPasswordController,
                  label: AppLocalizations.of(context)!.confirmPassword,
                  hint: '••••••••',
                  obscureText: _obscureConfirm,
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
                  validator: (v) {
                    if (v == null || v.isEmpty) return AppLocalizations.of(context)!.confirmPasswordRequired;
                    if (v != _passwordController.text) return AppLocalizations.of(context)!.passwordsDoNotMatch;
                    return null;
                  },
                ),
                SizedBox(height: 20.h),
                ReferralCodeField(
                  controller: _referralCodeController,
                  bottomSpacing: 20,
                ),
                SizedBox(height: 32.h),
                FilledButton(
                  onPressed:(){},
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