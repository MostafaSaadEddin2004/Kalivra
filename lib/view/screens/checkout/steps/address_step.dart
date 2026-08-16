import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/model/checkout/checkout_summary_model.dart';

class AddressStep extends StatefulWidget {
  const AddressStep({
    super.key,
    required this.summary,
    required this.onContinue,
  });

  final CheckoutSummaryModel? summary;
  final VoidCallback? onContinue;

  @override
  State<AddressStep> createState() => AddressStepState();
}

class AddressStepState extends State<AddressStep> {
  int _selectedIndex = 0;

  List<CheckoutAddressData> get addresses =>
      CheckoutAddressData.fromSummary(widget.summary);

  CheckoutAddressData? get selectedAddress {
    final list = addresses;
    if (list.isEmpty) return null;
    final index = _selectedIndex.clamp(0, list.length - 1);
    return list[index];
  }

  bool validateStep() => selectedAddress?.isUsable ?? false;

  @override
  void didUpdateWidget(covariant AddressStep oldWidget) {
    super.didUpdateWidget(oldWidget);
    final list = addresses;
    if (_selectedIndex >= list.length) {
      _selectedIndex = list.isEmpty ? 0 : list.length - 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final list = addresses;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _CheckoutSectionTitle(title: l10n.checkoutMyAddresses),
          SizedBox(height: 12.h),
          if (list.isEmpty)
            _EmptyAddressCard(text: l10n.checkoutNoAddressesAvailable)
          else
            ...List.generate(list.length, (index) {
              return Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: _AddressCard(
                  address: list[index],
                  selected: index == _selectedIndex,
                  onTap: () => setState(() => _selectedIndex = index),
                ),
              );
            }),
          SizedBox(height: 12.h),
          _AddAddressPreviewButton(
            label: l10n.checkoutAddNewAddress,
            onTap: () => _showAddAddressSheet(context),
          ),
          SizedBox(height: 34.h),
          _CheckoutPrimaryButton(
            label: l10n.checkoutContinueToShipping,
            icon: Icons.local_shipping_outlined,
            onPressed: widget.onContinue,
          ),
        ],
      ),
    );
  }

  void _showAddAddressSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _AddAddressSheet(),
    );
  }
}

class CheckoutAddressData {
  const CheckoutAddressData({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.address,
    required this.country,
    required this.state,
    required this.city,
    required this.postcode,
    required this.tags,
  });

  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String address;
  final String country;
  final String state;
  final String city;
  final String postcode;
  final List<String> tags;

  String get fullName {
    final value = [
      firstName,
      lastName,
    ].where((part) => part.trim().isNotEmpty).join(' ').trim();
    return value;
  }

  String get cityLine =>
      [city, state, country].where((part) => part.trim().isNotEmpty).join('، ');

  bool get isUsable =>
      firstName.trim().isNotEmpty &&
      address.trim().isNotEmpty &&
      phone.trim().isNotEmpty;

  static List<CheckoutAddressData> fromSummary(CheckoutSummaryModel? summary) {
    if (summary == null) return const [];

    final maps = <Map<String, dynamic>>[];
    void addMap(dynamic raw) {
      if (raw is Map<String, dynamic>) maps.add(raw);
      if (raw is Map) maps.add(Map<String, dynamic>.from(raw));
    }

    final cart = summary.cart;
    addMap(cart?.shippingAddress);
    addMap(cart?.billingAddress);
    addMap(summary.raw['shipping_address']);
    addMap(summary.raw['billing_address']);
    addMap(summary.raw['shippingAddress']);
    addMap(summary.raw['billingAddress']);

    final rawAddresses = summary.raw['addresses'];
    if (rawAddresses is List) {
      for (final item in rawAddresses) {
        addMap(item);
      }
    }

    final result = <CheckoutAddressData>[];
    final seen = <String>{};
    for (final map in maps) {
      final address = CheckoutAddressData.fromMap(map);
      if (address == null) continue;
      final key = '${address.fullName}|${address.phone}|${address.address}';
      if (seen.add(key)) result.add(address);
    }
    return result;
  }

  static CheckoutAddressData? fromMap(Map<String, dynamic> json) {
    final fullName = _text(json['name'] ?? json['full_name']) ?? '';
    final splitName = fullName.split(RegExp(r'\s+'));
    final firstName =
        _text(json['first_name'] ?? json['firstName']) ??
        (splitName.isNotEmpty ? splitName.first : null);
    final lastName =
        _text(json['last_name'] ?? json['lastName']) ??
        (splitName.length > 1 ? splitName.skip(1).join(' ') : null);
    final address = _addressText(json);
    final phone = _text(json['phone'] ?? json['telephone'] ?? json['mobile']);
    if ((firstName == null || firstName.isEmpty) &&
        (address == null || address.isEmpty) &&
        (phone == null || phone.isEmpty)) {
      return null;
    }

    final city = _text(json['city']) ?? '';
    final state = _text(json['state'] ?? json['region']) ?? '';
    return CheckoutAddressData(
      firstName: firstName ?? fullName,
      lastName: lastName ?? '',
      email: _text(json['email']) ?? '',
      phone: phone ?? '',
      address: address ?? '',
      country: _text(json['country'] ?? json['country_name']) ?? '',
      state: state,
      city: city,
      postcode:
          _text(json['postcode'] ?? json['postal_code'] ?? json['zip']) ?? '',
      tags: [city, state].where((part) => part.trim().isNotEmpty).toList(),
    );
  }

  static String? _addressText(Map<String, dynamic> json) {
    final raw =
        json['address'] ??
        json['street'] ??
        json['street_address'] ??
        json['address1'] ??
        json['formatted'];
    if (raw is List) {
      return raw
          .map((e) => e.toString().trim())
          .where((e) => e.isNotEmpty)
          .join('، ');
    }
    return _text(raw);
  }

  static String? _text(dynamic value) {
    if (value == null) return null;
    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }
}

class _AddressCard extends StatelessWidget {
  const _AddressCard({
    required this.address,
    required this.selected,
    required this.onTap,
  });

  final CheckoutAddressData address;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.burgundy.withValues(alpha: 0.035)
              : theme.cardTheme.color,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: selected
                ? AppColors.burgundy
                : colorScheme.primaryFixed.withValues(alpha: 0.08),
            width: selected ? 1.2.w : 1.w,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              selected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_off_rounded,
              color: selected
                  ? AppColors.burgundy
                  : colorScheme.primaryFixed.withValues(alpha: 0.45),
              size: 23.r,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    address.fullName.isEmpty
                        ? address.firstName
                        : address.fullName,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: colorScheme.primaryFixed,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (address.phone.isNotEmpty) ...[
                    SizedBox(height: 5.h),
                    Text(address.phone, style: theme.textTheme.bodyMedium),
                  ],
                  if (address.address.isNotEmpty) ...[
                    SizedBox(height: 5.h),
                    Text(
                      address.address,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.primaryFixed.withValues(alpha: 0.58),
                      ),
                    ),
                  ],
                  if (address.cityLine.isNotEmpty) ...[
                    SizedBox(height: 5.h),
                    Text(
                      address.cityLine,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.primaryFixed.withValues(alpha: 0.58),
                      ),
                    ),
                  ],
                  if (address.tags.isNotEmpty) ...[
                    SizedBox(height: 10.h),
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 6.h,
                      children: address.tags
                          .map((tag) => _AddressChip(label: tag))
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Icon(
              Icons.more_vert_rounded,
              color: colorScheme.primaryFixed,
              size: 22.r,
            ),
          ],
        ),
      ),
    );
  }
}

class _AddressChip extends StatelessWidget {
  const _AddressChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(
          color: theme.colorScheme.primaryFixed.withValues(alpha: 0.08),
        ),
      ),
      child: Text(label, style: theme.textTheme.bodySmall),
    );
  }
}

class _AddAddressPreviewButton extends StatelessWidget {
  const _AddAddressPreviewButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: AppColors.burgundy.withValues(alpha: 0.55),
            style: BorderStyle.solid,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_rounded, color: AppColors.burgundy, size: 24.r),
            SizedBox(width: 8.w),
            Text(
              label,
              style: theme.textTheme.titleSmall?.copyWith(
                color: AppColors.burgundy,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddAddressSheet extends StatefulWidget {
  const _AddAddressSheet();

  @override
  State<_AddAddressSheet> createState() => _AddAddressSheetState();
}

class _AddAddressSheetState extends State<_AddAddressSheet> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _postalCodeController = TextEditingController();
  bool _saveAsDefault = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _postalCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final bottomPadding = MediaQuery.viewInsetsOf(context).bottom;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: DraggableScrollableSheet(
        initialChildSize: 0.86,
        minChildSize: 0.58,
        maxChildSize: 0.94,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              padding: EdgeInsets.fromLTRB(18.w, 10.h, 18.w, 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 48.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryFixed.withValues(
                          alpha: 0.18,
                        ),
                        borderRadius: BorderRadius.circular(999.r),
                      ),
                    ),
                  ),
                  SizedBox(height: 18.h),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        l10n.checkoutAddAddressTitle,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: AppColors.burgundy,
                          fontWeight: FontWeight.w800,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(Icons.close_rounded, size: 24.r),
                          color: theme.colorScheme.primaryFixed,
                          tooltip: l10n.cancel,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 18.h),
                  Row(
                    children: [
                      Expanded(
                        child: _SheetInputField(
                          controller: _lastNameController,
                          label: l10n.checkoutLastName,
                          hint: l10n.checkoutEnterLastName,
                          icon: Icons.person_outline_rounded,
                          required: true,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _SheetInputField(
                          controller: _firstNameController,
                          label: l10n.checkoutFirstName,
                          hint: l10n.checkoutEnterFirstName,
                          icon: Icons.person_outline_rounded,
                          required: true,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 14.h),
                  _SheetInputField(
                    controller: _emailController,
                    label: l10n.checkoutEmail,
                    hint: l10n.checkoutEmailHint,
                    icon: Icons.mail_outline_rounded,
                    keyboardType: TextInputType.emailAddress,
                    required: true,
                  ),
                  SizedBox(height: 14.h),
                  _PhoneInputField(
                    controller: _phoneController,
                    label: l10n.checkoutPhoneNumber,
                    hint: '51234567',
                  ),
                  SizedBox(height: 14.h),
                  _SheetInputField(
                    controller: _addressController,
                    label: l10n.checkoutFullAddress,
                    hint: l10n.checkoutFullAddressHint,
                    icon: Icons.location_on_outlined,
                    required: true,
                  ),
                  SizedBox(height: 14.h),
                  Row(
                    children: [
                      Expanded(
                        child: _SheetSelectField(
                          label: l10n.checkoutProvince,
                          hint: l10n.checkoutChooseProvince,
                          required: true,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _SheetSelectField(
                          label: l10n.checkoutCity,
                          hint: l10n.checkoutChooseCity,
                          required: true,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 14.h),
                  _SheetInputField(
                    controller: _postalCodeController,
                    label: l10n.checkoutPostalCodeOptional,
                    hint: l10n.checkoutEnterPostalCode,
                    icon: Icons.mail_outline_rounded,
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 20.h),
                  _DefaultAddressToggle(
                    title: l10n.checkoutSaveAsDefaultAddress,
                    subtitle: l10n.checkoutDefaultAddressHelper,
                    value: _saveAsDefault,
                    onChanged: (value) {
                      setState(() => _saveAsDefault = value);
                    },
                  ),
                  SizedBox(height: 34.h),
                  _CheckoutPrimaryButton(
                    label: l10n.checkoutSaveAddress,
                    icon: Icons.check_rounded,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SheetInputField extends StatelessWidget {
  const _SheetInputField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType,
    this.required = false,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final bool required;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: TextInputAction.next,
      cursorColor: AppColors.burgundy,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.primaryFixed,
        fontWeight: FontWeight.w600,
      ),
      decoration: _sheetInputDecoration(
        context,
        label: required ? '$label *' : label,
        hint: hint,
        suffixIcon: Icon(icon, size: 22.r, color: AppColors.burgundy),
      ),
    );
  }
}

class _PhoneInputField extends StatelessWidget {
  const _PhoneInputField({
    required this.controller,
    required this.label,
    required this.hint,
  });

  final TextEditingController controller;
  final String label;
  final String hint;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextField(
      controller: controller,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      cursorColor: AppColors.burgundy,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.primaryFixed,
        fontWeight: FontWeight.w600,
      ),
      decoration: _sheetInputDecoration(
        context,
        label: '$label *',
        hint: hint,
        suffixIcon: Icon(
          Icons.phone_outlined,
          size: 22.r,
          color: AppColors.burgundy,
        ),
        prefixIcon: _CountryCodePrefix(theme: theme),
      ),
    );
  }
}

class _CountryCodePrefix extends StatelessWidget {
  const _CountryCodePrefix({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsetsDirectional.only(end: 10.w),
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        border: BorderDirectional(
          end: BorderSide(
            color: theme.colorScheme.primaryFixed.withValues(alpha: 0.08),
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('🇰🇼', style: TextStyle(fontSize: 20.sp)),
          SizedBox(width: 8.w),
          Text(
            '+965',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.primaryFixed,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(width: 4.w),
          Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 18.r,
            color: theme.colorScheme.primaryFixed,
          ),
        ],
      ),
    );
  }
}

class _SheetSelectField extends StatelessWidget {
  const _SheetSelectField({
    required this.label,
    required this.hint,
    this.required = false,
  });

  final String label;
  final String hint;
  final bool required;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 78.h,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 9.h),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: theme.colorScheme.primaryFixed.withValues(alpha: 0.08),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 22.r,
            color: theme.colorScheme.primaryFixed,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  required ? '$label *' : label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primaryFixed,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  hint,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primaryFixed.withValues(
                      alpha: 0.42,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 6.w),
          Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 20.r,
            color: theme.colorScheme.primaryFixed,
          ),
        ],
      ),
    );
  }
}

class _DefaultAddressToggle extends StatelessWidget {
  const _DefaultAddressToggle({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: theme.colorScheme.primaryFixed.withValues(alpha: 0.08),
        ),
      ),
      child: Row(
        children: [
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.burgundy,
            activeTrackColor: AppColors.burgundy.withValues(alpha: 0.28),
            inactiveThumbColor: theme.cardTheme.color,
            inactiveTrackColor: theme.colorScheme.primaryFixed.withValues(
              alpha: 0.12,
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.primaryFixed,
                    fontWeight: FontWeight.w800,
                  ),
                  textAlign: TextAlign.end,
                ),
                SizedBox(height: 6.h),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primaryFixed.withValues(
                      alpha: 0.45,
                    ),
                  ),
                  textAlign: TextAlign.end,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

InputDecoration _sheetInputDecoration(
  BuildContext context, {
  required String label,
  required String hint,
  Widget? prefixIcon,
  Widget? suffixIcon,
}) {
  final theme = Theme.of(context);
  return InputDecoration(
    labelText: label,
    hintText: hint,
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    filled: true,
    fillColor: theme.cardTheme.color,
    contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
    labelStyle: theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.primaryFixed,
      fontWeight: FontWeight.w800,
    ),
    hintStyle: theme.textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.primaryFixed.withValues(alpha: 0.36),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14.r),
      borderSide: BorderSide(
        color: theme.colorScheme.primaryFixed.withValues(alpha: 0.08),
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14.r),
      borderSide: BorderSide(
        color: theme.colorScheme.primaryFixed.withValues(alpha: 0.08),
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14.r),
      borderSide: BorderSide(color: AppColors.burgundy.withValues(alpha: 0.55)),
    ),
  );
}

class _EmptyAddressCard extends StatelessWidget {
  const _EmptyAddressCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Text(text, textAlign: TextAlign.center),
    );
  }
}

class _CheckoutSectionTitle extends StatelessWidget {
  const _CheckoutSectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        color: Theme.of(context).colorScheme.primaryFixed,
        fontWeight: FontWeight.w800,
      ),
      textAlign: TextAlign.start,
    );
  }
}

class _CheckoutPrimaryButton extends StatelessWidget {
  const _CheckoutPrimaryButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 21.r),
      label: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.burgundy,
        foregroundColor: AppColors.offWhite,
        padding: EdgeInsets.symmetric(vertical: 17.h, horizontal: 18.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.r),
        ),
      ),
    );
  }
}
