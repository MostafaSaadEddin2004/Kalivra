import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/controller/blocs/cubit/address_info_cubit/address_info_cubit.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/model/address/capiltal_model.dart';
import 'package:kalivra/model/checkout/checkout_summary_model.dart';
import 'package:kalivra/model/customer/address_api_model.dart';
import 'package:kalivra/model/services/api/address_info_services.dart';
import 'package:kalivra/view/widgets/association/association_dropdown_field.dart';
import 'package:kalivra/view/widgets/custom_snack_bar.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
  final AddressInfoServices _addressServices = AddressInfoServices();
  var _apiAddresses = <AddressApiModel>[];
  var _loadingAddresses = false;
  var _mutatingAddress = false;
  var _selectedIndex = 0;
  int? _selectedAddressId;
  String? _addressLoadError;

  List<CheckoutAddressData> get addresses {
    if (_apiAddresses.isNotEmpty || _addressLoadError == null) {
      return _apiAddresses.map(CheckoutAddressData.fromApi).toList();
    }
    return CheckoutAddressData.fromSummary(widget.summary);
  }

  CheckoutAddressData? get selectedAddress {
    final list = addresses;
    if (list.isEmpty) return null;
    final selectedId = _selectedAddressId;
    if (selectedId != null) {
      for (final address in list) {
        if (address.id == selectedId) return address;
      }
    }
    final index = _selectedIndex.clamp(0, list.length - 1);
    return list[index];
  }

  bool validateStep() => selectedAddress?.isUsable ?? false;

  @override
  void initState() {
    super.initState();
    _loadAddresses(preferDefault: true);
  }

  @override
  void didUpdateWidget(covariant AddressStep oldWidget) {
    super.didUpdateWidget(oldWidget);
    _ensureSelectedAddress();
  }

  Future<void> _loadAddresses({
    bool preferDefault = false,
    int? preferredId,
  }) async {
    if (mounted) {
      setState(() {
        _loadingAddresses = true;
        _addressLoadError = null;
      });
    }

    try {
      final addresses = await _addressServices.getAddresses();
      if (!mounted) return;
      setState(() {
        _apiAddresses = addresses;
        _loadingAddresses = false;
        _selectAddressAfterLoad(
          preferDefault: preferDefault,
          preferredId: preferredId,
        );
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _addressLoadError = e.toString();
        _loadingAddresses = false;
        _ensureSelectedAddress();
      });
    }
  }

  Future<bool> _createAddress(_AddressFormData data) async {
    return _runAddressMutation(
      successMessage: AppLocalizations.of(
        context,
      )!.checkoutAddressAddedSuccessfully,
      preferredId: null,
      preferDefault: data.defaultAddress,
      action: () async {
        final created = await _addressServices.createAddress(data.toPayload());
        return created?.id;
      },
    );
  }

  Future<bool> _updateAddress(
    AddressApiModel address,
    _AddressFormData data,
  ) async {
    return _runAddressMutation(
      successMessage: AppLocalizations.of(
        context,
      )!.checkoutAddressUpdatedSuccessfully,
      preferredId: address.id,
      preferDefault: data.defaultAddress,
      action: () async {
        final updated = await _addressServices.updateAddress(
          address.id,
          data.toPayload(),
        );
        return updated?.id ?? address.id;
      },
    );
  }

  Future<void> _setDefaultAddress(AddressApiModel address) async {
    await _runAddressMutation(
      successMessage: AppLocalizations.of(
        context,
      )!.checkoutAddressDefaultUpdatedSuccessfully,
      preferredId: address.id,
      preferDefault: true,
      action: () async {
        await _addressServices.setDefaultAddress(address.id);
        return address.id;
      },
    );
  }

  Future<void> _deleteAddress(AddressApiModel address) async {
    await _runAddressMutation(
      successMessage: AppLocalizations.of(
        context,
      )!.checkoutAddressDeletedSuccessfully,
      preferDefault: true,
      action: () async {
        await _addressServices.deleteAddress(address.id);
        return null;
      },
    );
  }

  Future<bool> _runAddressMutation({
    required String successMessage,
    required Future<int?> Function() action,
    bool preferDefault = false,
    int? preferredId,
  }) async {
    if (_mutatingAddress) return false;

    setState(() => _mutatingAddress = true);
    try {
      final changedId = await action();
      await _loadAddresses(
        preferDefault: preferDefault,
        preferredId: changedId ?? preferredId,
      );
      if (!mounted) return false;
      CustomSnackBar.show(context, successMessage);
      return true;
    } catch (e) {
      if (!mounted) return false;
      CustomSnackBar.show(context, e.toString());
      return false;
    } finally {
      if (mounted) setState(() => _mutatingAddress = false);
    }
  }

  void _selectAddressAfterLoad({bool preferDefault = false, int? preferredId}) {
    final list = _apiAddresses.map(CheckoutAddressData.fromApi).toList();
    if (list.isEmpty) {
      _selectedAddressId = null;
      _selectedIndex = 0;
      return;
    }

    CheckoutAddressData? selected;
    if (preferDefault) {
      selected = _defaultAddress(list);
    }

    if (selected == null && preferredId != null) {
      selected = _addressById(list, preferredId);
    }

    if (selected == null && _selectedAddressId != null) {
      selected = _addressById(list, _selectedAddressId!);
    }

    selected ??= _defaultAddress(list) ?? list.first;
    _selectedAddressId = selected.id;
    _selectedIndex = list.indexOf(selected);
  }

  void _ensureSelectedAddress() {
    final list = addresses;
    if (list.isEmpty) {
      _selectedAddressId = null;
      _selectedIndex = 0;
      return;
    }

    final selectedId = _selectedAddressId;
    if (selectedId != null && _addressById(list, selectedId) != null) return;

    if (_selectedIndex >= list.length) _selectedIndex = list.length - 1;

    final defaultAddress = _defaultAddress(list);
    if (defaultAddress != null) {
      _selectedAddressId = defaultAddress.id;
      _selectedIndex = list.indexOf(defaultAddress);
      return;
    }

    _selectedAddressId = list[_selectedIndex].id;
  }

  CheckoutAddressData? _defaultAddress(List<CheckoutAddressData> list) {
    for (final address in list) {
      if (address.isDefault) return address;
    }
    return null;
  }

  CheckoutAddressData? _addressById(
    List<CheckoutAddressData> list,
    int addressId,
  ) {
    for (final address in list) {
      if (address.id == addressId) return address;
    }
    return null;
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
          if (_loadingAddresses)
            Skeletonizer(
              child: Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: _AddressCard(
                  onTap: () {},
                  address: CheckoutAddressData(
                    firstName: 'firstName',
                    lastName: 'lastName',
                    email: 'email',
                    phone: 'phone',
                    address: 'address',
                    country: 'country',
                    state: 'state',
                    city: 'city',
                    postcode: 'postcode',
                    tags: [],
                  ),
                  selected: false,
                  menuEnabled: false,
                  onEdit: () {},
                  onSetDefault: () {},
                  onDelete: () {},
                ),
              ),
            )
          else if (list.isEmpty)
            _EmptyAddressCard(text: l10n.checkoutNoAddressesAvailable)
          else
            ...List.generate(list.length, (index) {
              final address = list[index];
              final apiAddress = _apiAddressById(address.id);
              return Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: _AddressCard(
                  address: address,
                  selected: address.id == null
                      ? index == _selectedIndex
                      : address.id == _selectedAddressId,
                  menuEnabled: !_mutatingAddress && apiAddress != null,
                  onTap: () => setState(() {
                    _selectedIndex = index;
                    _selectedAddressId = address.id;
                  }),
                  onEdit: apiAddress == null
                      ? null
                      : () => _showAddressSheet(context, address: apiAddress),
                  onSetDefault: apiAddress == null
                      ? null
                      : () => _setDefaultAddress(apiAddress),
                  onDelete: apiAddress == null
                      ? null
                      : () => _deleteAddress(apiAddress),
                ),
              );
            }),
          SizedBox(height: 12.h),
          _AddAddressPreviewButton(
            label: l10n.checkoutAddNewAddress,
            onTap: _mutatingAddress ? null : () => _showAddressSheet(context),
          ),
          SizedBox(height: 12.h),
          _CheckoutPrimaryButton(
            label: l10n.checkoutContinueToShipping,
            icon: Icons.local_shipping_outlined,
            onPressed: widget.onContinue,
          ),
        ],
      ),
    );
  }

  AddressApiModel? _apiAddressById(int? id) {
    if (id == null) return null;
    for (final address in _apiAddresses) {
      if (address.id == id) return address;
    }
    return null;
  }

  void _showAddressSheet(BuildContext context, {AddressApiModel? address}) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BlocProvider(
        create: (_) => AddressInfoCubit()..fetchCapitals(),
        child: _AddressFormSheet(
          address: address,
          onSubmit: address == null
              ? _createAddress
              : (data) => _updateAddress(address, data),
        ),
      ),
    );
  }
}

class CheckoutAddressData {
  const CheckoutAddressData({
    this.id,
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
    this.isDefault = false,
  });

  final int? id;
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
  final bool isDefault;

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
      id: _asInt(json['id']),
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
      isDefault: _asBool(json['default_address']) ?? false,
    );
  }

  factory CheckoutAddressData.fromApi(AddressApiModel address) {
    final addressText =
        address.address1
            ?.map((line) => line.trim())
            .where((line) => line.isNotEmpty)
            .join('، ') ??
        '';
    final city = address.city ?? '';
    final state = address.state ?? '';
    return CheckoutAddressData(
      id: address.id,
      firstName: address.firstName ?? '',
      lastName: address.lastName ?? '',
      email: address.email ?? '',
      phone: address.phone ?? '',
      address: addressText,
      country: address.country ?? address.countryName ?? '',
      state: state,
      city: city,
      postcode: address.postcode ?? '',
      tags: [city, state].where((part) => part.trim().isNotEmpty).toList(),
      isDefault: address.defaultAddress ?? false,
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

  static int? _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  static bool? _asBool(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      final normalized = value.toLowerCase().trim();
      if (normalized == 'true' || normalized == '1') return true;
      if (normalized == 'false' || normalized == '0') return false;
    }
    return null;
  }
}

class _AddressCard extends StatelessWidget {
  const _AddressCard({
    required this.address,
    required this.selected,
    required this.menuEnabled,
    required this.onTap,
    required this.onEdit,
    required this.onSetDefault,
    required this.onDelete,
  });

  final CheckoutAddressData address;
  final bool selected;
  final bool menuEnabled;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onSetDefault;
  final VoidCallback? onDelete;

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
                  if (address.isDefault || address.tags.isNotEmpty) ...[
                    SizedBox(height: 10.h),
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 6.h,
                      children: [
                        if (address.isDefault)
                          _AddressChip(
                            label: AppLocalizations.of(context)!.mainAddress,
                          ),
                        ...address.tags.map((tag) => _AddressChip(label: tag)),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(width: 8.w),
            PopupMenuButton<_AddressMenuAction>(
              enabled: menuEnabled,
              icon: Icon(
                Icons.more_vert_rounded,
                color: colorScheme.primaryFixed,
                size: 22.r,
              ),
              onSelected: (action) {
                switch (action) {
                  case _AddressMenuAction.edit:
                    onEdit?.call();
                    break;
                  case _AddressMenuAction.setDefault:
                    onSetDefault?.call();
                    break;
                  case _AddressMenuAction.delete:
                    onDelete?.call();
                    break;
                }
              },
              itemBuilder: (context) {
                final l10n = AppLocalizations.of(context)!;
                return [
                  PopupMenuItem(
                    value: _AddressMenuAction.edit,
                    child: Text(l10n.checkoutEditAddress),
                  ),
                  PopupMenuItem(
                    value: _AddressMenuAction.setDefault,
                    child: Text(l10n.checkoutSetAsDefaultAddress),
                  ),
                  PopupMenuItem(
                    value: _AddressMenuAction.delete,
                    child: Text(l10n.checkoutDeleteAddress),
                  ),
                ];
              },
            ),
          ],
        ),
      ),
    );
  }
}

enum _AddressMenuAction { edit, setDefault, delete }

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
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        textStyle: theme.textTheme.titleMedium?.copyWith(
          color: colorScheme.secondaryFixed,
          fontWeight: FontWeight.w800,
        ),
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1.w),
          borderRadius: BorderRadius.circular(14.r),
        ),
      ),
      child: Text(
        label,
        style: theme.textTheme.titleSmall?.copyWith(
          color: colorScheme.onTertiaryFixed,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _AddressFormSheet extends StatefulWidget {
  const _AddressFormSheet({required this.onSubmit, this.address});

  final AddressApiModel? address;
  final Future<bool> Function(_AddressFormData data) onSubmit;

  @override
  State<_AddressFormSheet> createState() => _AddressFormSheetState();
}

class _AddressFormSheetState extends State<_AddressFormSheet> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _stateController = TextEditingController();
  final _cityController = TextEditingController();
  final _postalCodeController = TextEditingController();
  String? _selectedCapitalId;
  bool _saveAsDefault = false;
  bool _isSaving = false;
  String? _errorText;

  bool get _isEditMode => widget.address != null;

  @override
  void initState() {
    super.initState();
    final address = widget.address;
    if (address == null) return;

    _firstNameController.text = address.firstName ?? '';
    _lastNameController.text = address.lastName ?? '';
    _emailController.text = address.email ?? '';
    _phoneController.text = address.phone ?? '';
    _addressController.text =
        address.address1
            ?.map((line) => line.trim())
            .where((line) => line.isNotEmpty)
            .join('، ') ??
        '';
    _stateController.text = address.state ?? '';
    _cityController.text = address.city ?? '';
    _postalCodeController.text = address.postcode ?? '';
    _saveAsDefault = address.defaultAddress ?? false;
  }

  void _handleAddressInfoState(
    BuildContext context,
    AddressInfoState addressInfoState,
  ) {
    if (addressInfoState.failureRequest != null &&
        addressInfoState.errorMessage != null) {
      setState(() => _errorText = addressInfoState.errorMessage);
    }

    if (_selectedCapitalId != null ||
        _stateController.text.trim().isEmpty ||
        addressInfoState.capitals.isEmpty) {
      return;
    }

    final capital = _capitalByName(
      addressInfoState.capitals,
      _stateController.text,
    );
    if (capital == null) return;

    _selectedCapitalId = capital.id;
    context.read<AddressInfoCubit>().fetchCities(capitalId: capital.id);
  }

  void _selectCapital(String? value, AddressInfoState addressInfoState) {
    if (value == null) return;
    final capital = _capitalByName(addressInfoState.capitals, value);
    setState(() {
      _stateController.text = value;
      _cityController.clear();
      _selectedCapitalId = capital?.id;
      _errorText = null;
    });
    if (capital != null) {
      context.read<AddressInfoCubit>().fetchCities(capitalId: capital.id);
    }
  }

  void _selectCity(String? value) {
    if (value == null) return;
    setState(() {
      _cityController.text = value;
      _errorText = null;
    });
  }

  CapitalModel? _capitalByName(List<CapitalModel> capitals, String name) {
    final normalizedName = name.trim();
    for (final capital in capitals) {
      if (capital.name.trim() == normalizedName) return capital;
    }
    return null;
  }

  List<String> _capitalNames(AddressInfoState addressInfoState) {
    return _namesWithCurrent(
      addressInfoState.capitals.map((capital) => capital.name),
      _stateController.text,
    );
  }

  List<String> _cityNames(AddressInfoState addressInfoState) {
    return _namesWithCurrent(
      addressInfoState.cities.map((city) => city.name),
      _cityController.text,
    );
  }

  List<String> _namesWithCurrent(Iterable<String> names, String current) {
    final result = <String>[];
    for (final name in names) {
      final trimmed = name.trim();
      if (trimmed.isNotEmpty && !result.contains(trimmed)) {
        result.add(trimmed);
      }
    }

    final selected = current.trim();
    if (selected.isNotEmpty && !result.contains(selected)) {
      result.add(selected);
    }
    return result;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    _postalCodeController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    final data = _AddressFormData(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      address: _addressController.text.trim(),
      state: _stateController.text.trim(),
      city: _cityController.text.trim(),
      postcode: _postalCodeController.text.trim(),
      defaultAddress: _saveAsDefault,
    );

    if (!data.isValid) {
      setState(() => _errorText = l10n.completeStepData);
      return;
    }

    setState(() {
      _isSaving = true;
      _errorText = null;
    });

    final saved = await widget.onSubmit(data);
    if (!mounted) return;
    if (saved) {
      Navigator.of(context).pop();
      return;
    }

    setState(() => _isSaving = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final bottomPadding = MediaQuery.viewInsetsOf(context).bottom;

    return BlocConsumer<AddressInfoCubit, AddressInfoState>(
      listener: _handleAddressInfoState,
      builder: (context, addressInfoState) {
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
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(28.r),
                  ),
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
                            _isEditMode
                                ? l10n.checkoutEditAddressTitle
                                : l10n.checkoutAddAddressTitle,
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
                      _SheetInputField(
                        controller: _firstNameController,
                        label: l10n.checkoutFirstName,
                        hint: l10n.checkoutEnterFirstName,
                        icon: Icons.person_outline_rounded,
                        required: true,
                      ),
                      SizedBox(height: 14.h),
                      _SheetInputField(
                        controller: _lastNameController,
                        label: l10n.checkoutLastName,
                        hint: l10n.checkoutEnterLastName,
                        icon: Icons.person_outline_rounded,
                        required: true,
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
                            child: AssociationDropdownField(
                              label: '${l10n.checkoutProvince} *',
                              value: _stateController.text.trim().isEmpty
                                  ? null
                                  : _stateController.text.trim(),
                              items: _capitalNames(addressInfoState),
                              enabled: !addressInfoState.isLoadingCapitals,
                              showDropdownIcon: false,
                              onChanged: (value) =>
                                  _selectCapital(value, addressInfoState),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: AssociationDropdownField(
                              label: '${l10n.checkoutCity} *',
                              value: _cityController.text.trim().isEmpty
                                  ? null
                                  : _cityController.text.trim(),
                              items: _cityNames(addressInfoState),
                              enabled:
                                  _selectedCapitalId != null &&
                                  !addressInfoState.isLoadingCities,
                              showDropdownIcon: false,
                              onChanged: _selectCity,
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
                      if (_errorText != null) ...[
                        SizedBox(height: 14.h),
                        Text(
                          _errorText!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.error,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                      SizedBox(height: 34.h),
                      _CheckoutPrimaryButton(
                        label: _isSaving
                            ? l10n.checkoutSaveAddress
                            : _isEditMode
                            ? l10n.checkoutUpdateAddress
                            : l10n.checkoutSaveAddress,
                        icon: Icons.check_rounded,
                        onPressed: _isSaving ? null : _submit,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _AddressFormData {
  const _AddressFormData({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.address,
    required this.state,
    required this.city,
    required this.postcode,
    required this.defaultAddress,
  });

  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String address;
  final String state;
  final String city;
  final String postcode;
  final bool defaultAddress;

  bool get isValid =>
      firstName.isNotEmpty &&
      lastName.isNotEmpty &&
      email.isNotEmpty &&
      phone.isNotEmpty &&
      address.isNotEmpty &&
      state.isNotEmpty &&
      city.isNotEmpty;

  Map<String, dynamic> toPayload() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'address': [address],
      'city': city,
      'state': state,
      'country': 'SY',
      'postcode': postcode.isEmpty ? '0000' : postcode,
      'default_address': defaultAddress ? 1 : 0,
    };
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
          Text(
            '+963',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.primaryFixed,
              fontWeight: FontWeight.w700,
            ),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.primaryFixed,
                    fontWeight: FontWeight.w800,
                  ),
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 6.h),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primaryFixed.withValues(
                      alpha: 0.45,
                    ),
                  ),
                  textAlign: TextAlign.start,
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
