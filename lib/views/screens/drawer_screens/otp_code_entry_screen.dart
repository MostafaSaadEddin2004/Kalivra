import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/views/widgets/custom_snack_bar.dart';
import 'package:kalivra/views/screens/drawer_screens/change_password_screen.dart';
import 'package:kalivra/views/widgets/drawer/drawer_screen_app_bar.dart';

/// Onboarding step 2: Enter verification code → verify → next (step 3).
class OtpCodeEntryScreen extends StatefulWidget {
  const OtpCodeEntryScreen({super.key, required this.args});

  final OtpOnboardingArgs args;

  @override
  State<OtpCodeEntryScreen> createState() => _OtpCodeEntryScreenState();
}

class _OtpCodeEntryScreenState extends State<OtpCodeEntryScreen> {
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  String _title(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (widget.args.mode == OtpScreenMode.signUp) return l10n.verifyCodeTitle;
    return widget.args.mode == OtpScreenMode.forgotPassword
        ? l10n.recoverPasswordTitle
        : l10n.changePhoneOtpTitle;
  }

  int get _stepTotal => widget.args.mode == OtpScreenMode.signUp ? 2 : 3;

  void _verify() {
    final l10n = AppLocalizations.of(context)!;
    if (_otpController.text.trim().length < 4) {
      CustomSnackBar.show(context, l10n.enterCodeHintSnack);
      return;
    }
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
      if (widget.args.mode == OtpScreenMode.forgotPassword) {
        context.push(AppRoutes.setNewPassword);
      } else if (widget.args.mode == OtpScreenMode.signUp) {
        context.push(AppRoutes.completeProfile, extra: widget.args);
      } else {
        context.push(AppRoutes.confirmNewPhone, extra: widget.args.phone);
      }
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

    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: DrawerScreenAppBar(title: _title(context)),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 32.h),
          children: [
            _StepIndicator(step: 2, total: _stepTotal),
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
                      l10n.otpSentToPhone(widget.args.phone),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isDark ? AppColors.taupe : AppColors.burgundy,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      widget.args.mode == OtpScreenMode.signUp
                          ? l10n.otpCodeHintSignUp
                          : l10n.otpCodeHintOther,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDark ? AppColors.taupe : AppColors.burgundy,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    TextFormField(
                      controller: _otpController,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      decoration: InputDecoration(
                        labelText: l10n.otpCodeLabel,
                        hintText: '••••',
                        counterText: '',
                        prefixIcon: Icon(Icons.pin_rounded, size: 22.r, color: labelColor),
                        filled: true,
                        fillColor: fillColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(color: borderColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(color: borderColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(
                            color: isDark ? AppColors.goldLight : AppColors.burgundy,
                            width: 1.5,
                          ),
                        ),
                        labelStyle: TextStyle(color: labelColor),
                        hintStyle: TextStyle(color: labelColor.withValues(alpha: 0.6)),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _isLoading ? null : _verify,
                        icon: _isLoading
                            ? SizedBox(
                                width: 20.r,
                                height: 20.r,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
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
                ),
              ),
            ),
          ],
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
              color: i ~/ 2 < step ? activeColor : activeColor.withValues(alpha: 0.3),
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
                ? Icon(Icons.check_rounded, size: 16.r, color: AppColors.offWhite)
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
