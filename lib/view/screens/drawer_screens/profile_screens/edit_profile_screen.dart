import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/view/widgets/app_text_field.dart';
import 'package:kalivra/view/widgets/custom_snack_bar.dart';
import 'package:kalivra/view/widgets/drawer/drawer_screen_app_bar.dart';

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
      CustomSnackBar.show(context, AppLocalizations.of(context)!.profileSaved);
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final labelColor = isDark ? AppColors.taupe : AppColors.burgundy;

    return Scaffold(
      appBar: DrawerScreenAppBar(title: l10n.editProfileTitle),
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
              l10n.changePhoto,
              style: theme.textTheme.bodySmall?.copyWith(color: labelColor),
            ),
            SizedBox(height: 28.h),
            _SectionCard(
              title: l10n.personalInfo,
              icon: Icons.person_outline_rounded,
              children: [
                AppTextField(
                  controller: _nameController,
                  label: l10n.fullName,
                  hint: l10n.enterFullNameHint,
                  prefixIcon: Icon(Icons.badge_outlined, size: 22.r, color: isDark ? AppColors.taupe : AppColors.burgundy),
                  validator: (v) => (v == null || v.trim().isEmpty) ? l10n.enterName : null,
                ),
                SizedBox(height: 16.h),
                AppTextField(
                  controller: _emailController,
                  label: l10n.email,
                  hint: 'example@email.com',
                  prefixIcon: Icon(Icons.email_outlined, size: 22.r, color: isDark ? AppColors.taupe : AppColors.burgundy),
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return l10n.enterEmailShort;
                    if (!v.contains('@')) return l10n.invalidEmail;
                    return null;
                  },
                ),
                SizedBox(height: 16.h),
                AppTextField(
                  controller: _phoneController,
                  label: l10n.mobileNumber,
                  hint: '+966 5XX XXX XXXX',
                  prefixIcon: Icon(Icons.phone_android_rounded, size: 22.r, color: isDark ? AppColors.taupe : AppColors.burgundy),
                  keyboardType: TextInputType.phone,
                  validator: (v) => (v == null || v.trim().isEmpty) ? l10n.enterPhone : null,
                ),
              ],
            ),
            SizedBox(height: 20.h),
            _SectionCard(
              title: l10n.address,
              icon: Icons.location_on_outlined,
              children: [
                AppTextField(
                  controller: _addressController,
                  label: l10n.mainAddress,
                  hint: l10n.cityAreaStreet,
                  prefixIcon: Icon(Icons.place_outlined, size: 22.r, color: isDark ? AppColors.taupe : AppColors.burgundy),
                  maxLines: 2,
                  validator: (v) => (v == null || v.trim().isEmpty) ? l10n.enterAddressShort : null,
                ),
                SizedBox(height: 16.h),
                AppTextField(
                  controller: _postalController,
                  label: l10n.postalCode,
                  hint: '12345',
                  prefixIcon: Icon(Icons.markunread_mailbox_rounded, size: 22.r, color: isDark ? AppColors.taupe : AppColors.burgundy),
                  keyboardType: TextInputType.number,
                  validator: (v) => (v == null || v.trim().isEmpty) ? l10n.enterPostalCodeShort : null,
                ),
              ],
            ),
            SizedBox(height: 32.h),
            FilledButton.icon(
              onPressed: _save,
              icon: Icon(Icons.check_rounded, size: 22.r),
              label: Text(
                l10n.saveChanges,
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