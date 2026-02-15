import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/views/widgets/buttons/custom_icon_button.dart';
import 'package:kalivra/views/widgets/custom_snack_bar.dart';
import 'package:kalivra/views/widgets/drawer/drawer_screen_app_bar.dart';

/// Change password: current, new, confirm. Update button + Forgot password → OTP.
class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _update() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    CustomSnackBar.show(context, 'تم تحديث كلمة المرور');
    context.pop();
  }

  void _forgotPassword() {
    context.push(AppRoutes.otp, extra: OtpScreenMode.forgotPassword);
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
      appBar: const DrawerScreenAppBar(title: 'تغيير كلمة المرور'),
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
                    _buildField(
                      controller: _currentController,
                      label: 'كلمة المرور الحالية',
                      hint: '••••••••',
                      icon: Icons.lock_outline_rounded,
                      obscureText: _obscureCurrent,
                      suffix: CustomIconButton(
                        icon: _obscureCurrent
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded,
                        iconSize: 22.r,
                        color: labelColor,
                        onPressed: () =>
                            setState(() => _obscureCurrent = !_obscureCurrent),
                      ),
                      borderColor: borderColor,
                      fillColor: fillColor,
                      labelColor: labelColor,
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'أدخل كلمة المرور الحالية'
                          : null,
                    ),
                    SizedBox(height: 20.h),
                    _buildField(
                      controller: _newController,
                      label: 'كلمة المرور الجديدة',
                      hint: '••••••••',
                      icon: Icons.lock_rounded,
                      obscureText: _obscureNew,
                      suffix: CustomIconButton(
                        icon: _obscureNew
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded,
                        iconSize: 22.r,
                        color: labelColor,
                        onPressed: () =>
                            setState(() => _obscureNew = !_obscureNew),
                      ),
                      borderColor: borderColor,
                      fillColor: fillColor,
                      labelColor: labelColor,
                      validator: (v) {
                        if (v == null || v.length < 6) {
                          return 'كلمة المرور 6 أحرف على الأقل';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20.h),
                    _buildField(
                      controller: _confirmController,
                      label: 'تأكيد كلمة المرور',
                      hint: '••••••••',
                      icon: Icons.lock_rounded,
                      obscureText: _obscureConfirm,
                      suffix: CustomIconButton(
                        icon: _obscureConfirm
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded,
                        iconSize: 22.r,
                        color: labelColor,
                        onPressed: () =>
                            setState(() => _obscureConfirm = !_obscureConfirm),
                      ),
                      borderColor: borderColor,
                      fillColor: fillColor,
                      labelColor: labelColor,
                      validator: (v) {
                        if (v != _newController.text) {
                          return 'غير متطابقة مع كلمة المرور الجديدة';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.h),
            FilledButton.icon(
              onPressed: _update,
              icon: Icon(Icons.check_rounded, size: 22.r),
              label: Text(
                'تحديث',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.offWhite,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: FilledButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
                elevation: 0,
              ),
            ),
            SizedBox(height: 16.h),
            Center(
              child: TextButton.icon(
                onPressed: _forgotPassword,
                icon: Icon(
                  Icons.help_outline_rounded,
                  size: 20.r,
                  color: isDark ? AppColors.goldLight : AppColors.burgundy,
                ),
                label: Text(
                  'نسيت كلمة المرور؟',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: isDark ? AppColors.goldLight : AppColors.burgundy,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required bool obscureText,
    required Widget? suffix,
    required Color borderColor,
    required Color fillColor,
    required Color labelColor,
    String? Function(String?)? validator,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, size: 22.r, color: labelColor),
        suffixIcon: suffix,
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
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: AppColors.red),
        ),
        labelStyle: TextStyle(color: labelColor),
        hintStyle: TextStyle(color: labelColor.withValues(alpha: 0.6)),
      ),
    );
  }
}

/// Mode for OTP onboarding: forgot password, change phone, or sign up.
enum OtpScreenMode { forgotPassword, changePhone, signUp }

/// Passed from step 1 (phone) to step 2 (OTP) and step 3 (confirm).
class OtpOnboardingArgs {
  const OtpOnboardingArgs({
    required this.mode,
    required this.phone,
    this.name,
    this.password,
    this.referralCode,
  });
  final OtpScreenMode mode;
  final String phone;
  final String? name;
  final String? password;
  /// Code of the person who referred this user (for referrer discount).
  final String? referralCode;
}
