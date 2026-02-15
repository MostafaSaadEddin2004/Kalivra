import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/views/widgets/custom_snack_bar.dart';
import 'package:kalivra/views/widgets/drawer/drawer_screen_app_bar.dart';

/// Edit profile form: name, email, phone, address. Matches account screen data.
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'أحمد محمد علي');
  final _emailController = TextEditingController(text: 'ahmed@example.com');
  final _phoneController = TextEditingController(text: '+966 5XX XXX XXXX');
  final _addressController = TextEditingController(
    text: 'الرياض، حي النخيل، شارع الملك فهد',
  );
  final _postalController = TextEditingController(text: '12345');

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _postalController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState?.validate() ?? false) {
      CustomSnackBar.show(context, 'تم حفظ التعديلات');
      context.pop();
    }
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
      appBar: const DrawerScreenAppBar(title: 'تعديل الملف الشخصي'),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 52.r,
                    backgroundColor: isDark
                        ? AppColors.burgundy.withValues(alpha: 0.3)
                        : AppColors.burgundy.withValues(alpha: 0.15),
                    child: Icon(
                      Icons.person_rounded,
                      size: 56.r,
                      color: isDark ? AppColors.goldLight : AppColors.burgundy,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Container(
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.burgundy
                            : AppColors.burgundy.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.camera_alt_rounded,
                        size: 20.r,
                        color: AppColors.offWhite,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'تغيير الصورة',
              style: theme.textTheme.bodySmall?.copyWith(color: labelColor),
            ),
            SizedBox(height: 28.h),
            _SectionCard(
              title: 'معلومات شخصية',
              icon: Icons.person_outline_rounded,
              children: [
                _buildField(
                  context: context,
                  controller: _nameController,
                  label: 'الاسم الكامل',
                  hint: 'أدخل الاسم الكامل',
                  icon: Icons.badge_outlined,
                  borderColor: borderColor,
                  fillColor: fillColor,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'أدخل الاسم' : null,
                ),
                SizedBox(height: 16.h),
                _buildField(
                  context: context,
                  controller: _emailController,
                  label: 'البريد الإلكتروني',
                  hint: 'example@email.com',
                  icon: Icons.email_outlined,
                  borderColor: borderColor,
                  fillColor: fillColor,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'أدخل البريد';
                    if (!v.contains('@')) return 'بريد غير صالح';
                    return null;
                  },
                ),
                SizedBox(height: 16.h),
                _buildField(
                  context: context,
                  controller: _phoneController,
                  label: 'رقم الجوال',
                  hint: '+966 5XX XXX XXXX',
                  icon: Icons.phone_android_rounded,
                  borderColor: borderColor,
                  fillColor: fillColor,
                  keyboardType: TextInputType.phone,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'أدخل رقم الجوال' : null,
                ),
              ],
            ),
            SizedBox(height: 20.h),
            _SectionCard(
              title: 'العنوان',
              icon: Icons.location_on_outlined,
              children: [
                _buildField(
                  context: context,
                  controller: _addressController,
                  label: 'العنوان الرئيسي',
                  hint: 'المدينة، الحي، الشارع',
                  icon: Icons.place_outlined,
                  borderColor: borderColor,
                  fillColor: fillColor,
                  maxLines: 2,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'أدخل العنوان' : null,
                ),
                SizedBox(height: 16.h),
                _buildField(
                  context: context,
                  controller: _postalController,
                  label: 'الرمز البريدي',
                  hint: '12345',
                  icon: Icons.markunread_mailbox_rounded,
                  borderColor: borderColor,
                  fillColor: fillColor,
                  keyboardType: TextInputType.number,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'أدخل الرمز البريدي' : null,
                ),
              ],
            ),
            SizedBox(height: 32.h),
            FilledButton.icon(
              onPressed: _save,
              icon: Icon(Icons.check_rounded, size: 22.r),
              label: Text(
                'حفظ التعديلات',
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
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final labelColor = isDark ? AppColors.taupe : AppColors.burgundy;

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(
          icon,
          size: 22.r,
          color: labelColor,
        ),
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

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  final String title;
  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 24.r,
                  color: isDark ? AppColors.goldLight : AppColors.burgundy,
                ),
                SizedBox(width: 10.w),
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: isDark ? AppColors.goldLight : AppColors.burgundy,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            ...children,
          ],
        ),
      ),
    );
  }
}
