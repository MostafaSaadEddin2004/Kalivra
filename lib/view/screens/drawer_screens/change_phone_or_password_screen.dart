import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/view/widgets/app_text_field.dart';
import 'package:kalivra/view/widgets/buttons/custom_icon_button.dart';
import 'package:kalivra/view/widgets/custom_snack_bar.dart';
import 'package:kalivra/view/widgets/drawer/drawer_screen_app_bar.dart';

enum ChangePhoneOrPasswordMode { phone, password }

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
                    AppTextField(
                      controller: _phoneController,
                      label: widget.mode == ChangePhoneOrPasswordMode.phone
                          ? 'رقم الجوال الجديد'
                          : 'رقم الجوال',
                      hint: '+966 5XX XXX XXXX',
                      prefixIcon: Icon(Icons.phone_android_rounded, size: 22.r, color: labelColor),
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
                      AppTextField(
                        controller: _newPasswordController,
                        label: 'كلمة المرور الجديدة',
                        hint: '••••••••',
                        obscureText: _obscureNew,
                        prefixIcon: Icon(Icons.lock_outline_rounded, size: 22.r, color: labelColor),
                        suffixIcon: CustomIconButton(
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
                            return 'كلمة المرور 6 أحرف على الأقل';
                          return null;
                        },
                      ),
                      SizedBox(height: 20.h),
                      AppTextField(
                        controller: _confirmPasswordController,
                        label: 'تأكيد كلمة المرور',
                        hint: '••••••••',
                        obscureText: _obscureConfirm,
                        prefixIcon: Icon(Icons.lock_rounded, size: 22.r, color: labelColor),
                        suffixIcon: CustomIconButton(
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
                            return 'غير متطابقة مع كلمة المرور الجديدة';
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
}