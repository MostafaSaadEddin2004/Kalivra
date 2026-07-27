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

  void _saveAddress() {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.addressSaved)),
      );
    }
  }

  bool validateStep() => _formKey.currentState?.validate() ?? false;

  Map<String, dynamic> buildAddressesBody() {
    final billing = {
      'first_name': _firstNameController.text.trim(),
      'last_name': _lastNameController.text.trim(),
      'email': _emailController.text.trim(),
      'address': [_streetController.text.trim()],
      'country': 'SY',
      'state': _stateController.text.trim(),
      'city': _cityController.text.trim(),
      'postcode': _zipController.text.trim(),
      'phone': _phoneController.text.trim(),
    };

    return {
      'billing': billing,
      'shipping': {
        'first_name': billing['first_name'],
        'last_name': billing['last_name'],
        'email': billing['email'],
        'address': billing['address'],
        'country': billing['country'],
        'state': billing['state'],
        'city': billing['city'],
        'postcode': billing['postcode'],
        'phone': billing['phone'],
      },
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextField(
              controller: _firstNameController,
              label: l10n.firstNameRequired,
              hint: l10n.firstName,
              textCapitalization: TextCapitalization.words,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? l10n.required : null,
            ),
            SizedBox(height: 16.h),
            AppTextField(
              controller: _lastNameController,
              label: l10n.lastNameRequired,
              hint: l10n.lastName,
              textCapitalization: TextCapitalization.words,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? l10n.required : null,
            ),
            SizedBox(height: 16.h),
            AppTextField(
              controller: _emailController,
              label: l10n.emailRequired,
              hint: l10n.emailHint,
              keyboardType: TextInputType.emailAddress,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return l10n.required;
                if (!v.contains('@')) return l10n.invalidEmail;
                return null;
              },
            ),
            SizedBox(height: 16.h),
            AppTextField(
              controller: _companyController,
              label: l10n.companyName,
              hint: l10n.companyName,
              textCapitalization: TextCapitalization.words,
            ),
            SizedBox(height: 16.h),
            AppTextField(
              controller: _phoneController,
              label: l10n.phoneRequired,
              hint: l10n.phoneLabel,
              keyboardType: TextInputType.phone,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? l10n.required : null,
            ),
            SizedBox(height: 16.h),
            AppTextField(
              controller: _streetController,
              label: l10n.streetRequired,
              hint: l10n.streetHint,
              textCapitalization: TextCapitalization.words,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? l10n.required : null,
            ),
            SizedBox(height: 16.h),
            AppTextField(
              controller: _zipController,
              label: l10n.postalCodeRequired,
              hint: l10n.postalCode,
              keyboardType: TextInputType.streetAddress,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? l10n.required : null,
            ),
            SizedBox(height: 16.h),
            AppTextField(
              controller: _stateController,
              label: l10n.stateRequired,
              hint: l10n.stateRequired,
              textCapitalization: TextCapitalization.words,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? l10n.required : null,
            ),
            SizedBox(height: 16.h),
            AppTextField(
              controller: _cityController,
              label: l10n.cityRequired,
              hint: l10n.city,
              textCapitalization: TextCapitalization.words,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? l10n.required : null,
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
                  l10n.saveAddress,
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
