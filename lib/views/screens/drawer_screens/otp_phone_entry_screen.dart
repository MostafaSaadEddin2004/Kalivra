import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/views/screens/drawer_screens/change_password_screen.dart';
import 'package:kalivra/views/widgets/custom_snack_bar.dart';
import 'package:kalivra/views/widgets/drawer/drawer_screen_app_bar.dart';

/// Onboarding step 1: Enter phone number → send code via WhatsApp → next.
/// For signup, pass [signUpArgs] with phone/name/password; phone is prefilled.
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

  String get _title {
    if (widget.signUpArgs != null) return 'التحقق من رقم الجوال';
    final m = widget._effectiveMode;
    return m == OtpScreenMode.forgotPassword
        ? 'استعادة كلمة المرور'
        : 'تغيير رقم الجوال';
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
        'تم إرسال رمز التحقق إلى ${_phoneController.text} عبر واتساب',
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

    return Scaffold(
      appBar: DrawerScreenAppBar(title: _title),
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
                          ? 'أدخل رقم الجوال لاستلام رمز التحقق عبر واتساب'
                          : widget._effectiveMode == OtpScreenMode.forgotPassword
                              ? 'أدخل رقم الجوال المرتبط بحسابك لاستلام رمز التحقق عبر واتساب'
                              : 'أدخل رقم الجوال الجديد لاستلام رمز التحقق عبر واتساب',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDark ? AppColors.taupe : AppColors.burgundy,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'رقم الجوال',
                        hintText: '+966 5XX XXX XXXX',
                        prefixIcon: Icon(Icons.phone_android_rounded, size: 22.r, color: labelColor),
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
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'أدخل رقم الجوال' : null,
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
