import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/controller/blocs/cubit/auth_cubit/auth_cubit.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/l10n/app_localizations.dart';
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
  final _whatsappNumberController = TextEditingController();
  final _countryCodeController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _referralCodeController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    _countryCodeController.text = '+963';
  }

  @override
  void dispose() {
    _whatsappNumberController.dispose();
    _firstNameController.dispose();
    _emailController.dispose();
    _lastNameController.dispose();
    _countryCodeController.dispose();
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
          padding: EdgeInsets.only(
            left: 24.w,
            top: 40.h,
            right: 24.w,
            bottom: 32.h,
          ),
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
                SizedBox(height: 20.h),
                AppTextField(
                  controller: _firstNameController,
                  label: AppLocalizations.of(context)!.firstName,
                  hint: AppLocalizations.of(context)!.enterFirstName,
                  textCapitalization: TextCapitalization.words,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return AppLocalizations.of(context)!.enterFirstName;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.h),
                AppTextField(
                  controller: _lastNameController,
                  label: AppLocalizations.of(context)!.lastName,
                  hint: AppLocalizations.of(context)!.enterLastName,
                  textCapitalization: TextCapitalization.words,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return AppLocalizations.of(context)!.enterLastName;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.h),
                AppTextField(
                  controller: _emailController,
                  label: AppLocalizations.of(context)!.email,
                  hint: AppLocalizations.of(context)!.enterEmail,
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 20.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: AppTextField(
                        textDirection: TextDirection.ltr,
                        controller: _whatsappNumberController,
                        label: AppLocalizations.of(
                          context,
                        )!.signUpWhatsAppLabel,
                        hint: AppLocalizations.of(
                          context,
                        )!.signUpWhatsAppHint,
                        keyboardType: TextInputType.phone,
                        maxLength: 9,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return AppLocalizations.of(
                              context,
                            )!.enterWhatsAppNumber;
                          }
                          if (v.trim().length < 8) {
                            return AppLocalizations.of(
                              context,
                            )!.invalidWhatsAppShort;
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 12.w),
                    SizedBox(
                      width: 75.w,
                      child: AppTextField(
                        textDirection: TextDirection.ltr,
                        enabled: false,
                        controller: _countryCodeController,
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 20.h),
                AppTextField(
                  controller: _passwordController,
                  label: AppLocalizations.of(context)!.passwordLabel,
                  hint: '********',
                  obscureText: _obscurePassword,
                  suffixIcon: CustomIconButton(
                    icon: _obscurePassword
                        ? Icons.visibility_off_rounded
                        : Icons.visibility_rounded,
                    iconSize: 22.r,
                    color: labelColor,
                    onPressed: () => setState(
                      () => _obscurePassword = !_obscurePassword,
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return AppLocalizations.of(context)!.enterPassword;
                    }
                    if (v.length < 6) {
                      return AppLocalizations.of(
                        context,
                      )!.passwordMinLength;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.h),
                AppTextField(
                  controller: _confirmPasswordController,
                  label: AppLocalizations.of(context)!.confirmPassword,
                  hint: '********',
                  obscureText: _obscureConfirm,
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
                    if (v == null || v.isEmpty) {
                      return AppLocalizations.of(
                        context,
                      )!.confirmPasswordRequired;
                    }
                    if (v != _passwordController.text) {
                      return AppLocalizations.of(
                        context,
                      )!.passwordsDoNotMatch;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.h),
                ReferralCodeField(
                  controller: _referralCodeController,
                  bottomSpacing: 20,
                ),
                SizedBox(height: 32.h),
                BlocConsumer<AuthCubit, AuthState>(
                  listener: (context, state) {
                    switch (state) {
                      case AuthLoading():
                        isLoading = true;
                      default:
                        isLoading = false;
                    }
                  },
                  builder: (context, state) {
                    return FilledButton(
                      onPressed: () {
                        if (!(_formKey.currentState?.validate() ?? false)) {
                          return;
                        }
                        context.read<AuthCubit>().register(
                          context: context,
                          firstName: _firstNameController.text.trim(),
                          lastName: _lastNameController.text.trim(),
                          email: _emailController.text.trim(),
                          whatsappNumber:
                              _countryCodeController.text +
                              _whatsappNumberController.text,
                          password: _passwordController.text,
                          passwordConfirmation:
                              _confirmPasswordController.text,
                          referralCode: _referralCodeController.text.trim(),
                        );
                      },
                      style: FilledButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        elevation: 0,
                      ),
                      child: isLoading
                          ? SpinKitFadingCircle(
                              color: AppColors.offWhite,
                              size: 20.r,
                            )
                          : Text(
                              AppLocalizations.of(
                                context,
                              )!.continueVerification,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: AppColors.offWhite,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    );
                  },
                ),
                SizedBox(height: 24.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.haveAccount,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDark
                            ? AppColors.taupe
                            : AppColors.burgundy,
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
