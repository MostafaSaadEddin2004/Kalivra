import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/l10n/app_localizations.dart';

class AddressStep extends StatefulWidget {
  const AddressStep({super.key});

  @override
  State<AddressStep> createState() => AddressStepState();
}

class AddressStepState extends State<AddressStep> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _companyController = TextEditingController();
  final _phoneController = TextEditingController();
  final _streetController = TextEditingController();
  final _zipController = TextEditingController();
  final _stateController = TextEditingController();
  final _cityController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _companyController.dispose();
    _phoneController.dispose();
    _streetController.dispose();
    _zipController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  InputDecoration _decoration(BuildContext context, String label, String hint) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = AppColors.offWhite.withValues(alpha: isDark ? 0.6 : 0.8);
    final fillColor = isDark
        ? const Color(0xFF1A1918)
        : AppColors.offWhite.withValues(alpha: 0.5);
    final labelColor = isDark ? AppColors.offWhite : AppColors.burgundy;

    return InputDecoration(
      labelText: label,
      hintText: hint,
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
        borderSide: BorderSide(color: AppColors.offWhite, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: AppColors.red),
      ),
      labelStyle: TextStyle(color: labelColor),
      hintStyle: TextStyle(color: labelColor.withValues(alpha: 0.6)),
    );
  }

  void _saveAddress() {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.addressSaved)),
      );
    }
  }

  /// Called by parent to validate before allowing proceed to next step.
  bool validateStep() => _formKey.currentState?.validate() ?? false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? AppColors.offWhite : AppColors.burgundy;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _firstNameController,
              textCapitalization: TextCapitalization.words,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'مطلوب' : null,
              decoration: _decoration(context, 'الاسم الأول*', 'الاسم الأول'),
              style: TextStyle(color: textColor),
            ),
            SizedBox(height: 16.h),
            TextFormField(
              controller: _lastNameController,
              textCapitalization: TextCapitalization.words,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'مطلوب' : null,
              decoration: _decoration(context, 'الاسم الأخير*', 'الاسم الأخير'),
              style: TextStyle(color: textColor),
            ),
            SizedBox(height: 16.h),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'مطلوب';
                if (!v.contains('@')) return 'أدخل بريداً إلكترونياً صالحاً';
                return null;
              },
              decoration:
                  _decoration(context, 'البريد الإلكتروني*', 'example@email.com'),
              style: TextStyle(color: textColor),
            ),
            SizedBox(height: 16.h),
            TextFormField(
              controller: _companyController,
              textCapitalization: TextCapitalization.words,
              decoration: _decoration(context, 'اسم الشركة', 'اسم الشركة'),
              style: TextStyle(color: textColor),
            ),
            SizedBox(height: 16.h),
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'مطلوب' : null,
              decoration: _decoration(context, 'الهاتف*', 'الهاتف'),
              style: TextStyle(color: textColor),
            ),
            SizedBox(height: 16.h),
            TextFormField(
              controller: _streetController,
              textCapitalization: TextCapitalization.words,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'مطلوب' : null,
              decoration:
                  _decoration(context, 'الشارع*', 'عنوان الشارع'),
              style: TextStyle(color: textColor),
            ),
            SizedBox(height: 16.h),
            TextFormField(
              controller: _zipController,
              keyboardType: TextInputType.streetAddress,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'مطلوب' : null,
              decoration: _decoration(
                  context, 'الرمز البريدي*', 'الرمز البريدي'),
              style: TextStyle(color: textColor),
            ),
            SizedBox(height: 16.h),
            TextFormField(
              controller: _stateController,
              textCapitalization: TextCapitalization.words,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'مطلوب' : null,
              decoration: _decoration(context, 'المحافظة*', 'المحافظة'),
              style: TextStyle(color: textColor),
            ),
            SizedBox(height: 16.h),
            TextFormField(
              controller: _cityController,
              textCapitalization: TextCapitalization.words,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'مطلوب' : null,
              decoration: _decoration(context, 'المدينة*', 'المدينة'),
              style: TextStyle(color: textColor),
            ),
            SizedBox(height: 24.h),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _saveAddress,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.offWhite,
                  foregroundColor: AppColors.burgundy,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  'حفظ العنوان',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: AppColors.burgundy,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
