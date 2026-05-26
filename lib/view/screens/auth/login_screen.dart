import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/controller/blocs/cubit/auth_cubit/auth_cubit.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/core/network/api_error_handler.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/view/screens/drawer_screens/change_password_screen.dart';
import 'package:kalivra/view/widgets/app_text_field.dart';
import 'package:kalivra/view/widgets/buttons/custom_icon_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _referralCodeController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _referralCodeController.dispose();
    super.dispose();
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final labelColor = isDark ? AppColors.taupe : AppColors.burgundy;

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        switch (state) {
          case AuthFailed():
            ApiErrorHandler.showSnackBar(
              context,
              state.message,
              fallbackMessage: AppLocalizations.of(context)!.loginFailed,
            );
            isLoading = false;
            break;
          case AuthSuccessed():
            isLoading = false;
          default:
            isLoading = true;
            break;
        }
      },
      builder: (context, authState) {
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
                    AppTextField(
                      controller: _emailController,
                      label: AppLocalizations.of(context)!.email,
                      hint: AppLocalizations.of(context)!.emailHint,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return AppLocalizations.of(context)!.enterEmailShort;
                        }
                        final emailValid = RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(v.trim());
                        if (!emailValid) {
                          return AppLocalizations.of(context)!.invalidEmail;
                        }
                        return null;
                      },
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
                        return null;
                      },
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
                            color: AppColors.goldLight,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 28.h),
                    FilledButton(
                      onPressed: isLoading
                          ? null
                          : () => context.read<AuthCubit>().login(
                              _emailController.text.trim(),
                              _passwordController.text,
                            ),
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
                            color: isDark
                                ? AppColors.taupe
                                : AppColors.burgundy,
                          ),
                        ),
                        TextButton(
                          onPressed: () => context.go(AppRoutes.signUp),
                          child: Text(
                            AppLocalizations.of(context)!.registerNow,
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: AppColors.goldLight,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    TextButton(
                      onPressed: () => context.push(AppRoutes.home),
                      child: Text(
                        AppLocalizations.of(context)!.continueToHomeTest,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isDark ? AppColors.taupe : AppColors.burgundy,
                        ),
                      ),
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
