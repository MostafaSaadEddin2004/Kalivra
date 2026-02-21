import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/controllers/blocs/cubit/auth_cubit/auth_cubit.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/core/network/api_error_handler.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/services/referral_repository.dart';
import 'package:kalivra/views/screens/drawer_screens/change_password_screen.dart';
import 'package:kalivra/views/widgets/buttons/custom_icon_button.dart';
import 'package:kalivra/views/widgets/referral/referral_code_field.dart';

/// Login: phone number + password. Links to sign up.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _referralCodeController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _referralCodeController.dispose();
    super.dispose();
  }

  void _login() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final referralCode = _referralCodeController.text.trim();
    context.read<AuthCubit>().login(
          _phoneController.text.trim(),
          _passwordController.text,
        );
    if (!mounted) return;
    if (referralCode.isNotEmpty) {
      await ReferralRepository().submitReferralCode(referralCode);
    }
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

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.hasError) {
          ApiErrorHandler.showSnackBar(
            context,
            state.error!,
            fallbackMessage: AppLocalizations.of(context)!.loginFailed,
          );
        }
        if (state.token != null && state.token!.isNotEmpty) {
          context.go(AppRoutes.home);
        }
      },
      builder: (context, authState) {
        final isLoading = authState.isLoading;
        return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(24.w, 40.h, 24.w, 32.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  AppLocalizations.of(context)!.loginTitle,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: isDark ? AppColors.offWhite : AppColors.burgundy,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  AppLocalizations.of(context)!.loginHint,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isDark ? AppColors.taupe : AppColors.burgundy,
                  ),
                ),
                SizedBox(height: 40.h),
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
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  validator: (v) {
                    if (v == null || v.isEmpty) return AppLocalizations.of(context)!.enterPassword;
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
                SizedBox(height: 12.h),
                ReferralCodeField(
                  controller: _referralCodeController,
                  bottomSpacing: 12,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () => context.push(
                      AppRoutes.otp,
                      extra: OtpScreenMode.forgotPassword,
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.forgotPassword,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.burgundy,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 28.h),
                FilledButton(
                  onPressed: isLoading ? null : _login,
                  style: FilledButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    elevation: 0,
                  ),
                  child: isLoading
                      ? SizedBox(
                          height: 24.h,
                          width: 24.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.offWhite,
                          ),
                        )
                      : Text(
                          AppLocalizations.of(context)!.login,
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
                      AppLocalizations.of(context)!.noAccount,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDark ? AppColors.taupe : AppColors.burgundy,
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.go(AppRoutes.signUp),
                      child: Text(
                        AppLocalizations.of(context)!.registerNow,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: AppColors.burgundy,
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
      },
    );
  }
}
