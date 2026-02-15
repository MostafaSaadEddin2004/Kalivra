import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/views/widgets/buttons/custom_icon_button.dart';
import 'package:kalivra/views/widgets/custom_snack_bar.dart';
import 'package:kalivra/views/widgets/drawer/drawer_screen_app_bar.dart';

enum ChangePhoneOrPasswordMode { phone, password }

/// Single screen for changing phone number or password. Title and fields depend on [mode].
/// Both flows include phone number input; password mode adds new password + confirm.
class ChangePhoneOrPasswordScreen extends StatefulWidget {
  const ChangePhoneOrPasswordScreen({super.key, required this.mode});

  final ChangePhoneOrPasswordMode mode;

  @override
  State<ChangePhoneOrPasswordScreen> createState() =>
      _ChangePhoneOrPasswordScreenState();
}

class _ChangePhoneOrPasswordScreenState
    extends State<ChangePhoneOrPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _phoneController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String get _title => widget.mode == ChangePhoneOrPasswordMode.phone
      ? 'تغيير رقم الجوال'
      : 'تغيير كلمة المرور';

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    CustomSnackBar.show(
      context,
      widget.mode == ChangePhoneOrPasswordMode.phone
          ? 'تم إرسال رمز التحقق إلى ${_phoneController.text}'
          : 'تم تحديث كلمة المرور',
    );
    context.pop();
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
                      widget.mode == ChangePhoneOrPasswordMode.phone
                          ? 'أدخل رقم الجوال الجديد'
                          : 'رقم الجوال للتحقق ثم كلمة المرور الجديدة',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDark ? AppColors.taupe : AppColors.burgundy,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    _buildField(
                      context: context,
                      controller: _phoneController,
                      label: widget.mode == ChangePhoneOrPasswordMode.phone
                          ? 'رقم الجوال الجديد'
                          : 'رقم الجوال',
                      hint: '+966 5XX XXX XXXX',
                      icon: Icons.phone_android_rounded,
                      borderColor: borderColor,
                      fillColor: fillColor,
                      labelColor: labelColor,
                      keyboardType: TextInputType.phone,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return widget.mode == ChangePhoneOrPasswordMode.phone
                              ? 'أدخل رقم الجوال الجديد'
                              : 'أدخل رقم الجوال';
                        }
                        return null;
                      },
                    ),
                    if (widget.mode == ChangePhoneOrPasswordMode.password) ...[
                      SizedBox(height: 20.h),
                      _buildField(
                        context: context,
                        controller: _newPasswordController,
                        label: 'كلمة المرور الجديدة',
                        hint: '••••••••',
                        icon: Icons.lock_outline_rounded,
                        borderColor: borderColor,
                        fillColor: fillColor,
                        labelColor: labelColor,
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
                        validator: (v) {
                          if (v == null || v.length < 6)
                            {return 'كلمة المرور 6 أحرف على الأقل';}
                          return null;
                        },
                      ),
                      SizedBox(height: 20.h),
                      _buildField(
                        context: context,
                        controller: _confirmPasswordController,
                        label: 'تأكيد كلمة المرور',
                        hint: '••••••••',
                        icon: Icons.lock_rounded,
                        borderColor: borderColor,
                        fillColor: fillColor,
                        labelColor: labelColor,
                        obscureText: _obscureConfirm,
                        suffix: CustomIconButton(
                          icon: _obscureConfirm
                              ? Icons.visibility_off_rounded
                              : Icons.visibility_rounded,
                          iconSize: 22.r,
                          color: labelColor,
                          onPressed: () => setState(
                            () => _obscureConfirm = !_obscureConfirm,
                          ),
                        ),
                        validator: (v) {
                          if (v != _newPasswordController.text)
                            {return 'غير متطابقة مع كلمة المرور الجديدة';}
                          return null;
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
            SizedBox(height: 28.h),
            FilledButton.icon(
              onPressed: _submit,
              icon: Icon(Icons.check_rounded, size: 22.r),
              label: Text(
                widget.mode == ChangePhoneOrPasswordMode.phone
                    ? 'إرسال رمز التحقق'
                    : 'تحديث كلمة المرور',
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
          ],
        ),
      ),
    );
  }

  Widget _buildField({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required Color borderColor,
    required Color fillColor,
    required Color labelColor,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffix,
    String? Function(String?)? validator,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
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
