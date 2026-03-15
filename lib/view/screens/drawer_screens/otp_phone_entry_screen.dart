import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/core/pop_scope_exit_app.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/view/screens/drawer_screens/change_password_screen.dart';
import 'package:kalivra/view/widgets/custom_snack_bar.dart';
import 'package:kalivra/view/widgets/drawer/drawer_screen_app_bar.dart';
import 'package:kalivra/view/widgets/app_text_field.dart';

class OtpPhoneEntryScreen extends StatefulWidget {
  const OtpPhoneEntryScreen({super.key, this.mode, this.signUpArgs});

  final OtpScreenMode? mode;
  final OtpOnboardingArgs? signUpArgs;

  OtpScreenMode get _effectiveMode => signUpArgs?.mode ?? mode ?? OtpScreenMode.changePhone;

  @override
  State<OtpPhoneEntryScreen> createState() => _OtpPhoneEntryScreenState();
}

class _OtpPhoneEntryScreenState extends State<OtpPhoneEntryScreen> {
  late final TextEditingController _phoneController;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController(
      text: widget.signUpArgs?.phone ?? '',
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  String _title(BuildContext context) {
    if (widget.signUpArgs != null) return AppLocalizations.of(context)!.verifyPhoneTitle;
    final m = widget._effectiveMode;
    return m == OtpScreenMode.forgotPassword
        ? AppLocalizations.of(context)!.recoverPasswordTitle
        : AppLocalizations.of(context)!.changePhoneOtpTitle;
  }

  int get _stepTotal => widget.signUpArgs != null ? 2 : 3;

  void _sendCode() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
      CustomSnackBar.show(
        context,
        AppLocalizations.of(context)!.codeSentViaWhatsApp(_phoneController.text),
      );
      context.push(
        AppRoutes.otpVerify,
        extra: widget.signUpArgs != null
            ? OtpOnboardingArgs(
                mode: OtpScreenMode.signUp,
                phone: _phoneController.text.trim(),
                name: widget.signUpArgs!.name,
                password: widget.signUpArgs!.password,
              )
            : OtpOnboardingArgs(
                mode: widget._effectiveMode,
                phone: _phoneController.text.trim(),
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

    return PopScopeExitApp(
      child: Scaffold(
      appBar: DrawerScreenAppBar(title: _title(context)),
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
                          : widget._effectiveMode == OtpScreenMode.forgotPassword
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
                      prefixIcon: Icon(Icons.phone_android_rounded, size: 22.r, color: labelColor),
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? AppLocalizations.of(context)!.enterPhone : null,
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
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.offWhite,
                                ),
                              )
                            : Icon(Icons.chat_rounded, size: 20.r),
                        label: Text(AppLocalizations.of(context)!.sendCodeViaWhatsApp),
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