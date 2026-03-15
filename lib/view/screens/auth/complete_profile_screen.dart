import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/core/pop_scope_exit_app.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/model/services/referral_repository.dart';
import 'package:kalivra/view/screens/drawer_screens/change_password_screen.dart';
import 'package:kalivra/view/widgets/app_text_field.dart';
import 'package:kalivra/view/widgets/drawer/drawer_screen_app_bar.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key, this.args});

  final OtpOnboardingArgs? args;

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _postalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.args != null) {
      _nameController.text = widget.args!.name ?? '';
      _phoneController.text = widget.args!.phone;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _postalController.dispose();
    super.dispose();
  }

  void _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final referralCode = widget.args?.referralCode;
    if (referralCode != null && referralCode.isNotEmpty) {
      await ReferralRepository().submitReferralCode(referralCode);
    }
    if (!mounted) return;
    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final labelColor = isDark ? AppColors.taupe : AppColors.burgundy;
    final l10n = AppLocalizations.of(context)!;

    return PopScopeExitApp(
      child: Scaffold(
      appBar: DrawerScreenAppBar(title: AppLocalizations.of(context)!.completeProfileTitle),
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
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.all(8.r),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.burgundy : AppColors.burgundy.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(Icons.camera_alt_rounded, size: 20.r, color: AppColors.offWhite),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.h),
            Center(
              child: Text(
                AppLocalizations.of(context)!.profilePhoto,
                style: theme.textTheme.bodySmall?.copyWith(color: labelColor),
              ),
            ),
            SizedBox(height: 28.h),
            AppTextField(
              controller: _nameController,
              label: l10n.fullName,
              hint: l10n.enterFullNameHint,
              prefixIcon: Icon(Icons.badge_outlined, size: 22.r, color: labelColor),
              validator: (v) => (v == null || v.trim().isEmpty) ? l10n.enterName : null,
            ),
            SizedBox(height: 16.h),
            AppTextField(
              controller: _emailController,
              label: l10n.emailRequired,
              hint: 'example@email.com',
              prefixIcon: Icon(Icons.email_outlined, size: 22.r, color: labelColor),
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
              hint: '+963 9XX XXX XXX',
              prefixIcon: Icon(Icons.phone_android_rounded, size: 22.r, color: labelColor),
              keyboardType: TextInputType.phone,
              validator: (v) => (v == null || v.trim().isEmpty) ? l10n.enterPhone : null,
            ),
            SizedBox(height: 16.h),
            AppTextField(
              controller: _addressController,
              label: l10n.addressOrLocation,
              hint: l10n.cityAreaStreet,
              prefixIcon: Icon(Icons.location_on_outlined, size: 22.r, color: labelColor),
              maxLines: 2,
              validator: (v) => (v == null || v.trim().isEmpty) ? l10n.enterAddressShort : null,
            ),
            SizedBox(height: 16.h),
            AppTextField(
              controller: _postalController,
              label: l10n.postalCode,
              hint: '12345',
              prefixIcon: Icon(Icons.markunread_mailbox_rounded, size: 22.r, color: labelColor),
              keyboardType: TextInputType.number,
              validator: (v) => (v == null || v.trim().isEmpty) ? l10n.enterPostalCodeShort : null,
            ),
            SizedBox(height: 32.h),
            FilledButton.icon(
              onPressed: _save,
              icon: Icon(Icons.check_rounded, size: 22.r),
              label: Text(
                AppLocalizations.of(context)!.saveAndContinue,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.offWhite,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: FilledButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }
}