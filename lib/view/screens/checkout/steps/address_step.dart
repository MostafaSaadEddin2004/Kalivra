import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/view/widgets/app_text_field.dart';

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

  static const String _required = 'مطلوب';

  void _saveAddress() {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.addressSaved)),
      );
    }
  }

  bool validateStep() => _formKey.currentState?.validate() ?? false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextField(
              controller: _firstNameController,
              label: 'الاسم الأول*',
              hint: 'الاسم الأول',
              textCapitalization: TextCapitalization.words,
              validator: (v) => (v == null || v.trim().isEmpty) ? _required : null,
            ),
            SizedBox(height: 16.h),
            AppTextField(
              controller: _lastNameController,
              label: 'الاسم الأخير*',
              hint: 'الاسم الأخير',
              textCapitalization: TextCapitalization.words,
              validator: (v) => (v == null || v.trim().isEmpty) ? _required : null,
            ),
            SizedBox(height: 16.h),
            AppTextField(
              controller: _emailController,
              label: 'البريد الإلكتروني*',
              hint: 'example@email.com',
              keyboardType: TextInputType.emailAddress,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return _required;
                if (!v.contains('@')) return 'أدخل بريداً إلكترونياً صالحاً';
                return null;
              },
            ),
            SizedBox(height: 16.h),
            AppTextField(
              controller: _companyController,
              label: 'اسم الشركة',
              hint: 'اسم الشركة',
              textCapitalization: TextCapitalization.words,
            ),
            SizedBox(height: 16.h),
            AppTextField(
              controller: _phoneController,
              label: 'الهاتف*',
              hint: 'الهاتف',
              keyboardType: TextInputType.phone,
              validator: (v) => (v == null || v.trim().isEmpty) ? _required : null,
            ),
            SizedBox(height: 16.h),
            AppTextField(
              controller: _streetController,
              label: 'الشارع*',
              hint: 'عنوان الشارع',
              textCapitalization: TextCapitalization.words,
              validator: (v) => (v == null || v.trim().isEmpty) ? _required : null,
            ),
            SizedBox(height: 16.h),
            AppTextField(
              controller: _zipController,
              label: 'الرمز البريدي*',
              hint: 'الرمز البريدي',
              keyboardType: TextInputType.streetAddress,
              validator: (v) => (v == null || v.trim().isEmpty) ? _required : null,
            ),
            SizedBox(height: 16.h),
            AppTextField(
              controller: _stateController,
              label: 'المحافظة*',
              hint: 'المحافظة',
              textCapitalization: TextCapitalization.words,
              validator: (v) => (v == null || v.trim().isEmpty) ? _required : null,
            ),
            SizedBox(height: 16.h),
            AppTextField(
              controller: _cityController,
              label: 'المدينة*',
              hint: 'المدينة',
              textCapitalization: TextCapitalization.words,
              validator: (v) => (v == null || v.trim().isEmpty) ? _required : null,
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