import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/views/screens/drawer_screens/change_password_screen.dart';
import 'package:kalivra/views/widgets/drawer/drawer_screen_app_bar.dart';

/// OTP screen: enter phone → send code via WhatsApp → enter OTP → verify.
/// Mode: forgotPassword (then go to set new password) or changePhone (then done).
class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key, required this.mode});

  final OtpScreenMode mode;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _codeSent = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  String get _title => widget.mode == OtpScreenMode.forgotPassword
      ? 'استعادة كلمة المرور'
      : 'تغيير رقم الجوال';

  String get _sendButtonLabel => 'إرسال الرمز عبر واتساب';

  void _sendCode() {
    if (_phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('أدخل رقم الجوال'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        ),
      );
      return;
    }
    setState(() {
      _isLoading = true;
      _codeSent = false;
    });
    // Simulate API call
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _codeSent = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم إرسال رمز التحقق إلى ${_phoneController.text} عبر واتساب'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        ),
      );
    });
  }

  void _verify() {
    if (_otpController.text.trim().length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('أدخل الرمز المكون من 4-6 أرقام'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        ),
      );
      return;
    }
    setState(() => _isLoading = true);
    // Simulate verification
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
      if (widget.mode == OtpScreenMode.forgotPassword) {
        context.push(AppRoutes.setNewPassword);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('تم تغيير رقم الجوال بنجاح'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
          ),
        );
        context.pop();
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

    return Scaffold(
      appBar: DrawerScreenAppBar(title: _title),
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
                    SizedBox(height: 16.h),
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
                        label: Text(_sendButtonLabel),
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
                      Divider(color: isDark ? AppColors.taupe.withValues(alpha: 0.3) : AppColors.burgundy.withValues(alpha: 0.3)),
                      SizedBox(height: 20.h),
                      Text(
                        'أدخل الرمز المرسل إليك',
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: isDark ? AppColors.offWhite : AppColors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      TextFormField(
                        controller: _otpController,
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        decoration: InputDecoration(
                          labelText: 'رمز التحقق',
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
                      SizedBox(height: 16.h),
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
                            'تحقق',
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
