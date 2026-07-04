import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:kalivra/controller/blocs/cubit/auth_cubit/auth_cubit.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/core/pop_scope_exit_app.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/view/widgets/buttons/custom_button.dart';
import 'package:kalivra/view/widgets/custom_snack_bar.dart';
import 'package:kalivra/view/widgets/profile_page/screen_app_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AuthOtpArgs {
  const AuthOtpArgs({
    this.email,
    this.phone,
    this.token,
    this.purpose = 'login',
  });

  final String? email;
  final String? phone;
  final String? token;
  final String purpose;
}

class AuthOtpScreen extends StatefulWidget {
  const AuthOtpScreen({super.key, required this.args});

  final AuthOtpArgs args;

  @override
  State<AuthOtpScreen> createState() => _AuthOtpScreenState();
}

class _AuthOtpScreenState extends State<AuthOtpScreen> {
  static const int _initialCooldownSeconds = 30;
  static const int _secondCooldownSeconds = 5 * 60;
  static const int _thirdCooldownSeconds = 60 * 60;

  final _otpController = TextEditingController();
  final GlobalKey<FormState> _formState = GlobalKey();
  Timer? _cooldownTimer;
  int _secondsRemaining = _initialCooldownSeconds;
  bool _canResend = false;
  int _resendCount = 0;
  bool _isResending = false;

  @override
  void initState() {
    super.initState();
    _startCooldown(_initialCooldownSeconds);
  }

  @override
  void dispose() {
    _cooldownTimer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  String _formatCooldown(int totalSeconds) {
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:'
          '${minutes.toString().padLeft(2, '0')}:'
          '${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  void _startCooldown(int seconds) {
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

  int _nextCooldownSeconds() {
    if (_resendCount == 0) return _secondCooldownSeconds;
    return _thirdCooldownSeconds;
  }

  Future<void> _resendCode() async {
    if (!_canResend || _isResending) return;

    final l10n = AppLocalizations.of(context)!;
    final whatsappNumber = widget.args.phone?.trim() ?? '';
    if (whatsappNumber.isEmpty) {
      CustomSnackBar.show(context, l10n.errorMissingData);
      return;
    }

    setState(() => _isResending = true);
    try {
      await context.read<AuthCubit>().resendOtp(
        context: context,
        whatsappNumber: whatsappNumber,
        email: widget.args.email?.trim(),
        token: widget.args.token,
        purpose: widget.args.purpose,
      );
      if (!mounted) return;
      _resendCount++;
      _startCooldown(_nextCooldownSeconds());
    } catch (_) {
      // Error snackbar is shown in AuthCubit.
    } finally {
      if (mounted) {
        setState(() => _isResending = false);
      }
    }
  }

  Widget _buildResendSection(
    BuildContext context,
    ThemeData theme,
    bool isDark,
    AppLocalizations l10n,
  ) {
    final textColor = isDark ? AppColors.taupe : AppColors.burgundy;

    if (!_canResend) {
      return Text(
        l10n.authOtpResendIn(_formatCooldown(_secondsRemaining)),
        style: theme.textTheme.bodyMedium?.copyWith(
          color: textColor,
          height: 1.4,
        ),
      );
    }

    return TextButton(
      onPressed: _isResending ? null : _resendCode,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
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
    );
  }

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final labelColor = isDark ? AppColors.taupe : AppColors.burgundy;
    final l10n = AppLocalizations.of(context)!;

    return PopScopeExitApp(
      child: Form(
        key: _formState,
        child: Scaffold(
          appBar: ScreenAppBar(title: l10n.authOtpTitle),
          body: ListView(
            padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 32.h),
            children: [
              Padding(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      l10n.authOtpSentTo(widget.args.phone.toString()),
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: isDark ? AppColors.taupe : AppColors.burgundy,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 40.h),
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return l10n.errorMissingData;
                        }
                        if (value.length != 6) {
                          return l10n.authOtpCodeLength;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 12.h),
                    _buildResendSection(context, theme, isDark, l10n),
                    SizedBox(height: 40.h),
                    BlocListener<AuthCubit, AuthState>(
                      listener: (context, state) {
                        switch (state) {
                          case AuthLoading():
                            isLoading = true;
                          case VerifySuccessed():
                            isLoading = false;
                          default:
                            isLoading = false;
                        }
                      },
                      child: CustomButton(
                        onTap: () {
                          if (_formState.currentState!.validate()) {
                            context.read<AuthCubit>().verifyOtp(
                              context: context,
                              otp: _otpController.text.trim(),
                              whatsappNumber: widget.args.phone?.trim() ?? '',
                              email: widget.args.email?.trim(),
                              token: widget.args.token ?? '',
                            );
                          }
                        },
                        title: isLoading
                            ? SizedBox(
                                width: 16.r,
                                height: 16.r,
                                child: const SpinKitFadingCircle(
                                  color: AppColors.offWhite,
                                ),
                              )
                            : Text(
                                l10n.verify,
                                style: theme.textTheme.displayLarge,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
