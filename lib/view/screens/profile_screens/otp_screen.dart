import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:kalivra/controller/blocs/cubit/auth_cubit/auth_cubit.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/view/screens/profile_screens/change_password_screen.dart';
import 'package:kalivra/view/widgets/app_text_field.dart';
import 'package:kalivra/view/widgets/custom_snack_bar.dart';
import 'package:kalivra/view/widgets/profile_page/screen_app_bar.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key, required this.mode});

  final OtpScreenMode mode;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  static const int _initialCooldownSeconds = 30;
  static const int _resendCooldownSeconds = 60;

  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Timer? _cooldownTimer;
  int _secondsRemaining = _initialCooldownSeconds;
  bool _canResend = false;
  bool _codeSent = false;
  bool _isLoading = false;
  bool _isResending = false;

  @override
  void dispose() {
    _cooldownTimer?.cancel();
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  String _title(AppLocalizations l10n) =>
      widget.mode == OtpScreenMode.forgotPassword
      ? l10n.recoverPasswordTitle
      : l10n.changePhoneOtpTitle;

  String get _otpPurpose {
    if (widget.mode == OtpScreenMode.signUp) return 'register';
    if (widget.mode == OtpScreenMode.forgotPassword) return 'reset_password';
    return 'change_whatsapp';
  }

  String _formatCooldown(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  void _startCooldown([int seconds = _initialCooldownSeconds]) {
    _cooldownTimer?.cancel();
    setState(() {
      _secondsRemaining = seconds;
      _canResend = false;
    });

    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_secondsRemaining <= 1) {
        timer.cancel();
        setState(() => _canResend = true);
      } else {
        setState(() => _secondsRemaining--);
      }
    });
  }

  Future<void> _sendCode() async {
    final l10n = AppLocalizations.of(context)!;
    if (_phoneController.text.trim().isEmpty) {
      CustomSnackBar.show(context, l10n.enterPhone);
      return;
    }
    setState(() {
      _isLoading = true;
      _codeSent = false;
    });

    final whatsappNumber = _phoneController.text.trim();
    try {
      if (widget.mode == OtpScreenMode.forgotPassword) {
        await context.read<AuthCubit>().sendPasswordOtp(
          context: context,
          whatsappNumber: whatsappNumber,
        );
      } else {
        await context.read<AuthCubit>().sendWhatsappOtp(
          context: context,
          whatsappNumber: whatsappNumber,
        );
      }
      if (!mounted) return;
      setState(() => _codeSent = true);
      _startCooldown();
      CustomSnackBar.show(context, l10n.codeSentViaWhatsApp(whatsappNumber));
    } catch (_) {
      // Error snackbar is shown by AuthCubit.
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _resendCode() async {
    if (!_codeSent || !_canResend || _isResending) return;

    final l10n = AppLocalizations.of(context)!;
    final whatsappNumber = _phoneController.text.trim();
    if (whatsappNumber.isEmpty) {
      CustomSnackBar.show(context, l10n.enterPhone);
      return;
    }

    setState(() => _isResending = true);
    try {
      await context.read<AuthCubit>().resendOtp(
        context: context,
        whatsappNumber: whatsappNumber,
        purpose: _otpPurpose,
      );
      if (!mounted) return;
      _startCooldown(_resendCooldownSeconds);
    } catch (_) {
      if (mounted) {
        CustomSnackBar.show(context, l10n.authOtpResendFailed);
      }
    } finally {
      if (mounted) {
        setState(() => _isResending = false);
      }
    }
  }

  void _verify() {
    final l10n = AppLocalizations.of(context)!;
    if (_otpController.text.trim().length < 4) {
      CustomSnackBar.show(context, l10n.authOtpCodeLength);
      return;
    }
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
      if (widget.mode == OtpScreenMode.forgotPassword) {
        context.push(
          AppRoutes.setNewPassword,
          extra: _phoneController.text.trim(),
        );
      } else {
        CustomSnackBar.show(context, l10n.phoneVerifiedSuccess);
        context.pop();
      }
    });
  }

  Widget _buildResendSection(
    ThemeData theme,
    bool isDark,
    AppLocalizations l10n,
  ) {
    final textColor = isDark ? AppColors.taupe : AppColors.burgundy;

    if (!_canResend) {
      return Text(
        l10n.authOtpResendIn(_formatCooldown(_secondsRemaining)),
        textAlign: TextAlign.center,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: textColor,
          height: 1.4,
        ),
      );
    }

    return Center(
      child: TextButton(
        onPressed: _isResending ? null : _resendCode,
        child: _isResending
            ? SizedBox(
                width: 18.r,
                height: 18.r,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: textColor,
                ),
              )
            : Text(
                l10n.authOtpResendCode,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: textColor,
                  decoration: TextDecoration.underline,
                  decorationColor: textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final labelColor = isDark ? AppColors.taupe : AppColors.burgundy;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: ScreenAppBar(title: _title(l10n)),
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
                    Text(
                      widget.mode == OtpScreenMode.forgotPassword
                          ? l10n.otpPhoneHintForgot
                          : l10n.otpPhoneHintChange,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDark ? AppColors.taupe : AppColors.burgundy,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    AppTextField(
                      controller: _phoneController,
                      label: l10n.phoneLabel,
                      hint: '+963 9XX XXX XXX',
                      keyboardType: TextInputType.phone,
                      prefixIcon: Icon(
                        Icons.phone_android_rounded,
                        size: 22.r,
                        color: labelColor,
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? l10n.enterPhone
                          : null,
                    ),
                    SizedBox(height: 16.h),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _isLoading ? null : _sendCode,
                        icon: _isLoading
                            ? SizedBox(
                                width: 20.r,
                                height: 20.r,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.offWhite,
                                ),
                              )
                            : Icon(Icons.chat_rounded, size: 20.r),
                        label: Text(l10n.sendCodeViaWhatsApp),
                        style: FilledButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                    if (_codeSent) ...[
                      SizedBox(height: 24.h),
                      Divider(
                        color: isDark
                            ? AppColors.taupe.withValues(alpha: 0.3)
                            : AppColors.burgundy.withValues(alpha: 0.3),
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        l10n.verifyCodeTitle,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: isDark ? AppColors.offWhite : AppColors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      PinCodeTextField(
                        appContext: context,
                        controller: _otpController,
                        autoDisposeControllers: false,
                        length: 6,
                        keyboardType: TextInputType.number,
                        animationType: AnimationType.fade,
                        textStyle: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.offWhite : AppColors.black,
                        ),
                        cursorColor: labelColor,
                        enableActiveFill: true,
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(12.r),
                          fieldHeight: 52.r,
                          fieldWidth: 44.w,
                          activeColor: isDark
                              ? AppColors.goldLight
                              : AppColors.burgundy,
                          selectedColor: isDark
                              ? AppColors.goldLight
                              : AppColors.burgundy,
                          inactiveColor: isDark
                              ? AppColors.taupe.withValues(alpha: 0.5)
                              : AppColors.burgundy.withValues(alpha: 0.35),
                          activeFillColor: isDark
                              ? AppColors.burgundy.withValues(alpha: 0.12)
                              : AppColors.offWhite,
                          selectedFillColor: isDark
                              ? AppColors.burgundy.withValues(alpha: 0.18)
                              : AppColors.offWhite,
                          inactiveFillColor: isDark
                              ? AppColors.burgundy.withValues(alpha: 0.08)
                              : AppColors.offWhite,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      _buildResendSection(theme, isDark, l10n),
                      SizedBox(height: 16.h),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: _isLoading ? null : _verify,
                          icon: _isLoading
                              ? SizedBox(
                                  width: 20.r,
                                  height: 20.r,
                                  child: SpinKitFadingCircle(
                                    size: 20.r,
                                    color: AppColors.offWhite,
                                  ),
                                )
                              : Icon(Icons.verified_user_rounded, size: 20.r),
                          label: Text(
                            l10n.verify,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: AppColors.offWhite,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          style: FilledButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
