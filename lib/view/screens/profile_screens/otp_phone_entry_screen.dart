import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/controller/blocs/cubit/auth_cubit/auth_cubit.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/core/pop_scope_exit_app.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/view/screens/profile_screens/change_password_screen.dart';
import 'package:kalivra/view/widgets/custom_snack_bar.dart';
import 'package:kalivra/view/widgets/profile_page/screen_app_bar.dart';
import 'package:kalivra/view/widgets/app_text_field.dart';

class OtpPhoneEntryScreen extends StatefulWidget {
  const OtpPhoneEntryScreen({super.key, this.mode, this.signUpArgs});

  final OtpScreenMode? mode;
  final OtpOnboardingArgs? signUpArgs;

  OtpScreenMode get _effectiveMode =>
      signUpArgs?.mode ?? mode ?? OtpScreenMode.changePhone;

  @override
  State<OtpPhoneEntryScreen> createState() => _OtpPhoneEntryScreenState();
}

class _OtpPhoneEntryScreenState extends State<OtpPhoneEntryScreen> {
  static const int _initialCooldownSeconds = 30;
  static const int _resendCooldownSeconds = 60;

  late final TextEditingController _phoneController;
  final _formKey = GlobalKey<FormState>();
  Timer? _cooldownTimer;
  int _secondsRemaining = _initialCooldownSeconds;
  bool _canResend = false;
  bool _codeSent = false;
  bool _isLoading = false;
  bool _isResending = false;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController(
      text: widget.signUpArgs?.whatsappNumber ?? '',
    );
  }

  @override
  void dispose() {
    _cooldownTimer?.cancel();
    _phoneController.dispose();
    super.dispose();
  }

  String _title(BuildContext context) {
    if (widget.signUpArgs != null) {
      return AppLocalizations.of(context)!.verifyPhoneTitle;
    }
    final m = widget._effectiveMode;
    return m == OtpScreenMode.forgotPassword
        ? AppLocalizations.of(context)!.recoverPasswordTitle
        : AppLocalizations.of(context)!.changePhoneOtpTitle;
  }

  int get _stepTotal => widget.signUpArgs != null ? 2 : 3;

  String get _otpPurpose {
    if (widget.signUpArgs != null ||
        widget._effectiveMode == OtpScreenMode.signUp) {
      return 'register';
    }
    if (widget._effectiveMode == OtpScreenMode.forgotPassword) {
      return 'reset_password';
    }
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
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final whatsappNumber = _phoneController.text.trim();
    final l10n = AppLocalizations.of(context)!;

    setState(() => _isLoading = true);
    try {
      if (widget.signUpArgs != null) {
        await context.read<AuthCubit>().resendOtp(
          context: context,
          whatsappNumber: whatsappNumber,
          email: widget.signUpArgs?.email,
          token: widget.signUpArgs?.token,
          purpose: _otpPurpose,
        );
      } else if (widget._effectiveMode == OtpScreenMode.forgotPassword) {
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
      setState(() {
        _isLoading = false;
        _codeSent = true;
      });
      _startCooldown();
      CustomSnackBar.show(context, l10n.codeSentViaWhatsApp(whatsappNumber));
      context.push(
        AppRoutes.otpVerify,
        extra: widget.signUpArgs != null
            ? OtpOnboardingArgs(
                mode: OtpScreenMode.signUp,
                whatsappNumber: whatsappNumber,
                email: widget.signUpArgs!.email,
                token: widget.signUpArgs!.token,
                name: widget.signUpArgs!.name,
                password: widget.signUpArgs!.password,
                referralCode: widget.signUpArgs!.referralCode,
              )
            : OtpOnboardingArgs(
                mode: widget._effectiveMode,
                whatsappNumber: whatsappNumber,
              ),
      );
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
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final whatsappNumber = _phoneController.text.trim();
    final l10n = AppLocalizations.of(context)!;

    setState(() => _isResending = true);
    try {
      await context.read<AuthCubit>().resendOtp(
        context: context,
        whatsappNumber: whatsappNumber,
        email: widget.signUpArgs?.email,
        token: widget.signUpArgs?.token,
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

  Widget _buildResendSection(
    ThemeData theme,
    bool isDark,
    AppLocalizations l10n,
  ) {
    if (!_codeSent) return const SizedBox.shrink();

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

    return PopScopeExitApp(
      child: Scaffold(
        appBar: ScreenAppBar(title: _title(context)),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 32.h),
            children: [
              _StepIndicator(step: 1, total: _stepTotal),
              SizedBox(height: 24.h),
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
                        widget.signUpArgs != null
                            ? AppLocalizations.of(context)!.otpPhoneHintSignUp
                            : widget._effectiveMode ==
                                  OtpScreenMode.forgotPassword
                            ? AppLocalizations.of(context)!.otpPhoneHintForgot
                            : AppLocalizations.of(context)!.otpPhoneHintChange,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isDark ? AppColors.taupe : AppColors.burgundy,
                          height: 1.4,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      AppTextField(
                        controller: _phoneController,
                        label: AppLocalizations.of(context)!.phoneLabel,
                        hint: '+966 5XX XXX XXXX',
                        keyboardType: TextInputType.phone,
                        prefixIcon: Icon(
                          Icons.phone_android_rounded,
                          size: 22.r,
                          color: labelColor,
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? AppLocalizations.of(context)!.enterPhone
                            : null,
                      ),
                      SizedBox(height: 20.h),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: _isLoading ? null : _sendCode,
                          icon: _isLoading
                              ? SizedBox(
                                  width: 20.r,
                                  height: 20.r,
                                  child: SpinKitFadingCircle(
                                    size: 20.r,
                                    color: AppColors.offWhite,
                                  ),
                                )
                              : Icon(Icons.chat_rounded, size: 20.r),
                          label: Text(
                            AppLocalizations.of(context)!.sendCodeViaWhatsApp,
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
                      if (_codeSent) ...[
                        SizedBox(height: 12.h),
                        _buildResendSection(theme, isDark, l10n),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({required this.step, required this.total});

  final int step;
  final int total;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final activeColor = isDark ? AppColors.goldLight : AppColors.burgundy;

    return Row(
      children: List.generate(total * 2 - 1, (i) {
        if (i.isOdd) {
          return Expanded(
            child: Container(
              height: 2,
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              color: i ~/ 2 < step
                  ? activeColor
                  : activeColor.withValues(alpha: 0.3),
            ),
          );
        }
        final s = i ~/ 2 + 1;
        final isActive = s <= step;
        return Container(
          width: 28.r,
          height: 28.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? activeColor : activeColor.withValues(alpha: 0.3),
          ),
          child: Center(
            child: isActive
                ? Icon(
                    Icons.check_rounded,
                    size: 16.r,
                    color: AppColors.offWhite,
                  )
                : Text(
                    '$s',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: isDark ? AppColors.offWhite : AppColors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
        );
      }),
    );
  }
}
