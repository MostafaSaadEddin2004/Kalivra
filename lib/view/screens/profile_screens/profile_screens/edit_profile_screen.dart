import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kalivra/controller/blocs/cubit/address_info_cubit/address_info_cubit.dart';
import 'package:kalivra/controller/blocs/cubit/auth_cubit/auth_cubit.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/model/customer/customer_api_model.dart';
import 'package:kalivra/model/services/api/customer_api_service.dart';
import 'package:kalivra/view/widgets/app_text_field.dart';
import 'package:kalivra/view/widgets/association/association_dropdown_field.dart';
import 'package:kalivra/view/widgets/custom_snack_bar.dart';
import 'package:kalivra/view/widgets/profile_page/screen_app_bar.dart';

const String _kMediaOrigin = 'https://test1.zedan-world.com';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key, required this.userInfo});
  final CustomerApiModel userInfo;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _countryCodeController = TextEditingController(text: '+963');
  final _phoneController = TextEditingController();
  final _dobController = TextEditingController();
  final _streetController = TextEditingController();
  final _streetNumberController = TextEditingController();
  final _buildingController = TextEditingController();
  final _villageController = TextEditingController();
  final _currentAddress = _ProfileAddressInput();
  final List<_ProfileAddressInput> _additionalAddresses = [];

  String? _gender;
  String? _selectedGovernorate;
  String? _selectedCity;
  String? _selectedTown;
  File? _pickedAvatarFile;
  String? _networkAvatarUrl;
  bool _hasCurrentAddress = false;
  bool didApplyCustomer = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _countryCodeController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _streetController.dispose();
    _streetNumberController.dispose();
    _buildingController.dispose();
    _villageController.dispose();
    _currentAddress.dispose();
    for (final address in _additionalAddresses) {
      address.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _applyCustomer(widget.userInfo);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = context.read<AuthCubit>().state;
      if (state is AuthFetchedData && state.customer.id != widget.userInfo.id) {
        _applyCustomer(state.customer);
      }
    });
  }

  static String? _resolveAvatarUrl(String? avatar) {
    if (avatar == null || avatar.isEmpty) return null;
    if (avatar.startsWith('http')) return avatar;
    return avatar.startsWith('/')
        ? '$_kMediaOrigin$avatar'
        : '$_kMediaOrigin/$avatar';
  }

  void _applyCustomer(CustomerApiModel c) {
    final nameParts = (c.name ?? '').trim().split(RegExp(r'\s+'));
    final fn = c.firstName ?? (nameParts.isNotEmpty ? nameParts.first : '');
    final ln =
        c.lastName ??
        (nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '');
    final addressInfo = c.addressInformation;
    _firstNameController.text = fn;
    _lastNameController.text = ln;
    final phoneParts = _splitPhoneNumber(c.phone ?? c.whatsappNumber ?? '');
    _countryCodeController.text = phoneParts.countryCode;
    _phoneController.text = phoneParts.number;
    _dobController.text = _formatDateForField(c.dateOfBirth);
    _selectedGovernorate =
        addressInfo?.permanentCapitalId?.toString() ??
        addressInfo?.officialGovernorate;
    _selectedCity =
        addressInfo?.permanentCityId?.toString() ?? addressInfo?.officialCity;
    _selectedTown =
        addressInfo?.permanentTownId?.toString() ?? addressInfo?.officialTown;
    _villageController.text = addressInfo?.officialMunicipalityVillage ?? '';
    _streetController.text = addressInfo?.officialStreet ?? '';
    _streetNumberController.text = addressInfo?.permanent?.streetNumber ?? '';
    _buildingController.text = addressInfo?.officialBuilding ?? '';
    _currentAddress.clear();
    _hasCurrentAddress = false;
    final currentAddress = addressInfo?.current;
    if (currentAddress != null && currentAddress.hasContent) {
      _currentAddress.apply(currentAddress);
      _hasCurrentAddress = true;
    }
    for (final address in _additionalAddresses) {
      address.dispose();
    }
    _additionalAddresses
      ..clear()
      ..addAll(
        (addressInfo?.additional ?? const [])
            .where((address) => address.hasContent)
            .map(_ProfileAddressInput.fromAddress),
      );
    final g = c.gender?.toLowerCase().trim();
    _gender = (g == 'male' || g == 'female') ? g : null;
    _networkAvatarUrl = _resolveAvatarUrl(c.avatar);
    didApplyCustomer = true;
  }

  void _onGovernorateChanged(String? value) {
    setState(() {
      _selectedGovernorate = value;
      _selectedCity = null;
      _selectedTown = null;
    });
  }

  void _onCityChanged(String? value) {
    setState(() {
      _selectedCity = value;
      _selectedTown = null;
    });
  }

  void _onTownChanged(String? value) {
    setState(() {
      _selectedTown = value;
    });
  }

  void _addAddress() {
    setState(() {
      if (_hasCurrentAddress) {
        _additionalAddresses.add(_ProfileAddressInput());
      } else {
        _hasCurrentAddress = true;
      }
    });
  }

  void _removeCurrentAddress() {
    setState(() {
      _hasCurrentAddress = false;
      _currentAddress.clear();
    });
  }

  void _removeAdditionalAddress(int index) {
    setState(() {
      _additionalAddresses.removeAt(index).dispose();
    });
  }

  Widget _fieldSpacer() {
    return SizedBox(height: 14.h);
  }

  static _PhoneParts _splitPhoneNumber(String value) {
    final normalized = value.trim().replaceAll(RegExp(r'\s+'), '');
    if (normalized.startsWith('+963')) {
      return _PhoneParts(countryCode: '+963', number: normalized.substring(4));
    }
    if (normalized.startsWith('963')) {
      return _PhoneParts(countryCode: '+963', number: normalized.substring(3));
    }
    if (normalized.startsWith('+')) {
      final match = RegExp(r'^\+(\d{1,3})(.*)$').firstMatch(normalized);
      if (match != null) {
        return _PhoneParts(
          countryCode: '+${match.group(1)}',
          number: match.group(2) ?? '',
        );
      }
    }
    return _PhoneParts(
      countryCode: '+963',
      number: normalized.replaceFirst(RegExp(r'^0+'), ''),
    );
  }

  static String _formatDateForField(String? value) {
    if (value == null || value.trim().isEmpty) return '';
    final parsed = DateTime.tryParse(value.trim());
    if (parsed == null) return value.trim();
    return _formatDate(parsed);
  }

  static String _formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  Future<void> _pickDateOfBirth() async {
    final now = DateTime.now();
    final currentValue = DateTime.tryParse(_dobController.text.trim());
    final initialDate = currentValue != null && !currentValue.isAfter(now)
        ? currentValue
        : DateTime(now.year - 18, now.month, now.day);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: now,
      helpText: AppLocalizations.of(context)!.dateOfBirthLabel,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: isDark ? AppColors.taupe : AppColors.burgundy,
              onPrimary: AppColors.offWhite,
              surface: isDark ? AppColors.black : Colors.white,
              onSurface: isDark ? AppColors.offWhite : AppColors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate == null || !mounted) return;
    setState(() {
      _dobController.text = _formatDate(pickedDate);
    });
  }

  Map<String, dynamic> _permanentAddressMap() {
    return _ProfileAddressInput.toCleanMap(
      capitalId: _selectedGovernorate,
      cityId: _selectedCity,
      townId: _selectedTown,
      village: _villageController.text.trim(),
      streetName: _streetController.text.trim(),
      streetNumber: _streetNumberController.text.trim(),
      building: _buildingController.text.trim(),
    );
  }

  Map<String, dynamic> _addressesMap() {
    return {
      'permanent': _permanentAddressMap(),
      'current': _hasCurrentAddress
          ? _currentAddress.toMap()
          : _permanentAddressMap(),
      'additional': _additionalAddresses
          .map((address) => address.toMap(includeDetails: true))
          .toList(),
    };
  }

  Future<void> _pickAvatar() async {
    final l10n = AppLocalizations.of(context)!;
    final picker = ImagePicker();
    final x = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 2048,
      maxHeight: 2048,
      imageQuality: 88,
    );
    if (x == null || !mounted) return;
    final len = await File(x.path).length();
    if (len > CustomerApiService.maxProfileImageBytes) {
      if (!mounted) return;
      CustomSnackBar.show(context, l10n.profileImageTooLarge);
      return;
    }
    setState(() {
      _pickedAvatarFile = File(x.path);
      _networkAvatarUrl = null;
    });
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final l10n = AppLocalizations.of(context)!;
    final f = _pickedAvatarFile;
    if (f != null) {
      final len = await f.length();
      if (len > CustomerApiService.maxProfileImageBytes) {
        if (!mounted) return;
        CustomSnackBar.show(context, l10n.profileImageTooLarge);
        return;
      }
    }

    try {
      await context.read<AuthCubit>().updateProfile(
        context: context,
        countryCode: _countryCodeController.text.trim(),
        phone: _phoneController.text.trim(),
        whatsappNumber: _phoneController.text.trim(),
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        gender: _gender,
        dateOfBirth: _dobController.text.trim().isEmpty
            ? null
            : _dobController.text.trim(),
        addresses: _addressesMap(),
        imageFile: f,
      );
      if (!mounted) return;
      CustomSnackBar.show(context, l10n.profileSaved);
      context.pop();
    } catch (_) {
      if (!mounted) return;
      final msg = context.read<AuthCubit>().state;
      if (msg is AuthFailed) {
        CustomSnackBar.show(context, msg.message);
      }
    }
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final labelColor = isDark ? AppColors.taupe : AppColors.burgundy;
    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen: (prev, curr) => curr is AuthFetchedData && !didApplyCustomer,
      listener: (context, state) {
        if (state is AuthFetchedData) {
          setState(() => _applyCustomer(state.customer));
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: ScreenAppBar(title: l10n.editProfileTitle),
          body: Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
              children: [
                Center(
                  child: InkWell(
                    onTap: _pickAvatar,
                    borderRadius: BorderRadius.circular(999),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        CircleAvatar(
                          radius: 52.r,
                          backgroundColor: isDark
                              ? AppColors.burgundy.withValues(alpha: 0.3)
                              : AppColors.burgundy.withValues(alpha: 0.15),
                          backgroundImage: _pickedAvatarFile != null
                              ? FileImage(_pickedAvatarFile!)
                              : (_networkAvatarUrl != null
                                    ? NetworkImage(_networkAvatarUrl!)
                                    : null),
                          child:
                              _pickedAvatarFile == null &&
                                  _networkAvatarUrl == null
                              ? Icon(
                                  Icons.person_rounded,
                                  size: 56.r,
                                  color: isDark
                                      ? AppColors.goldLight
                                      : AppColors.burgundy,
                                )
                              : null,
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
                ),
                SizedBox(height: 8.h),
                Text(
                  l10n.changePhoto,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(color: labelColor),
                ),
                SizedBox(height: 28.h),
                _SectionCard(
                  title: l10n.personalInfo,
                  icon: Icons.person_outline_rounded,
                  children: [
                    AppTextField(
                      controller: _firstNameController,
                      label: l10n.firstName,
                      hint: l10n.firstName,
                      prefixIcon: Icon(
                        Icons.badge_outlined,
                        size: 22.r,
                        color: isDark ? AppColors.taupe : AppColors.burgundy,
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? l10n.enterFirstName
                          : null,
                    ),
                    SizedBox(height: 16.h),
                    AppTextField(
                      controller: _lastNameController,
                      label: l10n.lastName,
                      hint: l10n.lastName,
                      prefixIcon: Icon(
                        Icons.badge_outlined,
                        size: 22.r,
                        color: isDark ? AppColors.taupe : AppColors.burgundy,
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? l10n.enterLastName
                          : null,
                    ),
                    SizedBox(height: 16.h),
                    AssociationDropdownField(
                      label: l10n.genderLabel,
                      hintText: l10n.dash,
                      value: _gender,
                      items: const ['male', 'female'],
                      itemLabelBuilder: (value) =>
                          value == 'male' ? l10n.genderMale : l10n.genderFemale,
                      enabled: !isLoading,
                      onChanged: (value) => setState(() => _gender = value),
                    ),
                    SizedBox(height: 16.h),
                    AppTextField(
                      controller: _dobController,
                      label: l10n.dateOfBirthLabel,
                      hint: l10n.dateOfBirthHint,
                      prefixIcon: Icon(
                        Icons.calendar_today_outlined,
                        size: 22.r,
                        color: isDark ? AppColors.taupe : AppColors.burgundy,
                      ),
                      keyboardType: TextInputType.datetime,
                      readOnly: true,
                      onTap: _pickDateOfBirth,
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                _SectionCard(
                  title: l10n.contactInfo,
                  icon: Icons.contact_phone_outlined,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      textDirection: TextDirection.ltr,
                      children: [
                        SizedBox(
                          width: 82.w,
                          child: AppTextField(
                            textDirection: TextDirection.ltr,
                            enabled: false,
                            controller: _countryCodeController,
                            keyboardType: TextInputType.phone,
                            borderRadius: 22.r,
                            fillColor: isDark
                                ? AppColors.burgundy.withValues(alpha: 0.08)
                                : AppColors.offWhite,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: AppTextField(
                            textDirection: TextDirection.ltr,
                            controller: _phoneController,
                            label: l10n.mobileNumber,
                            hint: '9XX XXX XXX',
                            prefixIcon: Icon(
                              Icons.phone_android_rounded,
                              size: 22.r,
                              color: isDark
                                  ? AppColors.taupe
                                  : AppColors.burgundy,
                            ),
                            keyboardType: TextInputType.phone,
                            maxLength: 9,
                            validator: (v) {
                              final value = v?.trim() ?? '';
                              if (value.isEmpty) {
                                return l10n.enterPhoneNumber;
                              }
                              if (value.length < 8) {
                                return l10n.invalidPhone;
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                _SectionCard(
                  title: l10n.userLocationInfo,
                  icon: Icons.location_on_outlined,
                  children: [
                    _ProfileAddressesSection(
                      selectedGovernorate: _selectedGovernorate,
                      selectedCity: _selectedCity,
                      selectedTown: _selectedTown,
                      villageController: _villageController,
                      streetController: _streetController,
                      streetNumberController: _streetNumberController,
                      buildingController: _buildingController,
                      hasCurrentAddress: _hasCurrentAddress,
                      currentAddress: _currentAddress,
                      additionalAddresses: _additionalAddresses,
                      enabled: !isLoading,
                      fieldSpacer: _fieldSpacer,
                      onGovernorateChanged: _onGovernorateChanged,
                      onCityChanged: _onCityChanged,
                      onTownChanged: _onTownChanged,
                      onAddAddress: _addAddress,
                      onRemoveAddress: _removeAdditionalAddress,
                      onRemoveCurrentAddress: _removeCurrentAddress,
                    ),
                  ],
                ),
                SizedBox(height: 32.h),
                BlocListener<AuthCubit, AuthState>(
                  listener: (context, state) {
                    switch (state) {
                      case AuthLoading():
                        isLoading = true;
                      default:
                        isLoading = false;
                    }
                  },
                  child: FilledButton(
                    onPressed: _save,
                    style: FilledButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      elevation: 0,
                    ),
                    child: isLoading
                        ? SpinKitFadingCircle(
                            color: AppColors.offWhite,
                            size: 20.r,
                          )
                        : Text(
                            l10n.saveChanges,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: AppColors.offWhite,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PhoneParts {
  const _PhoneParts({required this.countryCode, required this.number});

  final String countryCode;
  final String number;
}

class _ProfileAddressInput {
  _ProfileAddressInput();

  factory _ProfileAddressInput.fromAddress(CustomerAddressEntry address) {
    return _ProfileAddressInput()..apply(address);
  }

  final labelController = TextEditingController();
  final typeController = TextEditingController();
  final villageController = TextEditingController();
  final streetController = TextEditingController();
  final streetNumberController = TextEditingController();
  final buildingController = TextEditingController();

  String? selectedGovernorate;
  String? selectedCity;
  String? selectedTown;

  static Object? _addressId(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    return int.tryParse(value) ?? value;
  }

  static Map<String, dynamic> toCleanMap({
    required String? capitalId,
    required String? cityId,
    required String? townId,
    required String village,
    required String streetName,
    required String streetNumber,
    required String building,
    String label = '',
    String type = '',
  }) {
    final map = <String, dynamic>{
      'label': label,
      'type': type,
      'capital_id': _addressId(capitalId),
      'city_id': _addressId(cityId),
      'town_id': _addressId(townId),
      'village': village,
      'street_name': streetName,
      'street_number': streetNumber,
      'building': building,
    };

    map.removeWhere(
      (_, value) => value == null || (value is String && value.isEmpty),
    );
    return map;
  }

  void clear() {
    selectedGovernorate = null;
    selectedCity = null;
    selectedTown = null;
    labelController.clear();
    typeController.clear();
    villageController.clear();
    streetController.clear();
    streetNumberController.clear();
    buildingController.clear();
  }

  void apply(CustomerAddressEntry address) {
    selectedGovernorate = address.capitalId?.toString();
    selectedCity = address.cityId?.toString();
    selectedTown = address.townId?.toString();
    labelController.text = address.label ?? '';
    typeController.text = address.type ?? '';
    villageController.text = address.village ?? '';
    streetController.text = address.streetName ?? '';
    streetNumberController.text = address.streetNumber ?? '';
    buildingController.text = address.building ?? '';
  }

  Map<String, dynamic> toMap({bool includeDetails = false}) {
    return toCleanMap(
      capitalId: selectedGovernorate,
      cityId: selectedCity,
      townId: selectedTown,
      village: villageController.text.trim(),
      streetName: streetController.text.trim(),
      streetNumber: streetNumberController.text.trim(),
      building: buildingController.text.trim(),
      label: includeDetails ? labelController.text.trim() : '',
      type: includeDetails ? typeController.text.trim() : '',
    );
  }

  void dispose() {
    labelController.dispose();
    typeController.dispose();
    villageController.dispose();
    streetController.dispose();
    streetNumberController.dispose();
    buildingController.dispose();
  }
}

class _ProfileAddressesSection extends StatelessWidget {
  const _ProfileAddressesSection({
    required this.selectedGovernorate,
    required this.selectedCity,
    required this.selectedTown,
    required this.villageController,
    required this.streetController,
    required this.streetNumberController,
    required this.buildingController,
    required this.hasCurrentAddress,
    required this.currentAddress,
    required this.additionalAddresses,
    required this.enabled,
    required this.fieldSpacer,
    required this.onGovernorateChanged,
    required this.onCityChanged,
    required this.onTownChanged,
    required this.onAddAddress,
    required this.onRemoveAddress,
    required this.onRemoveCurrentAddress,
  });

  final String? selectedGovernorate;
  final String? selectedCity;
  final String? selectedTown;
  final TextEditingController villageController;
  final TextEditingController streetController;
  final TextEditingController streetNumberController;
  final TextEditingController buildingController;
  final bool hasCurrentAddress;
  final _ProfileAddressInput currentAddress;
  final List<_ProfileAddressInput> additionalAddresses;
  final bool enabled;
  final Widget Function() fieldSpacer;
  final ValueChanged<String?> onGovernorateChanged;
  final ValueChanged<String?> onCityChanged;
  final ValueChanged<String?> onTownChanged;
  final VoidCallback onAddAddress;
  final ValueChanged<int> onRemoveAddress;
  final VoidCallback onRemoveCurrentAddress;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ProfileAddressFormFields(
          title: l10n.associationLinkPermanentAddress,
          selectedGovernorate: selectedGovernorate,
          selectedCity: selectedCity,
          selectedTown: selectedTown,
          villageController: villageController,
          streetController: streetController,
          streetNumberController: streetNumberController,
          buildingController: buildingController,
          enabled: enabled,
          fieldSpacer: fieldSpacer,
          onGovernorateChanged: onGovernorateChanged,
          onCityChanged: onCityChanged,
          onTownChanged: onTownChanged,
        ),
        if (hasCurrentAddress) ...[
          SizedBox(height: 18.h),
          _ProfileAddressFormFields(
            title: l10n.associationMemberCurrentAddress,
            selectedGovernorate: currentAddress.selectedGovernorate,
            selectedCity: currentAddress.selectedCity,
            selectedTown: currentAddress.selectedTown,
            villageController: currentAddress.villageController,
            streetController: currentAddress.streetController,
            streetNumberController: currentAddress.streetNumberController,
            buildingController: currentAddress.buildingController,
            enabled: enabled,
            fieldSpacer: fieldSpacer,
            onRemove: onRemoveCurrentAddress,
            onGovernorateChanged: (value) {
              currentAddress.selectedGovernorate = value;
              currentAddress.selectedCity = null;
              currentAddress.selectedTown = null;
            },
            onCityChanged: (value) {
              currentAddress.selectedCity = value;
              currentAddress.selectedTown = null;
            },
            onTownChanged: (value) {
              currentAddress.selectedTown = value;
            },
          ),
        ],
        for (var index = 0; index < additionalAddresses.length; index++) ...[
          SizedBox(height: 18.h),
          _ProfileAddressFormFields(
            title: '${l10n.associationAdditionalAddress} ${index + 1}',
            selectedGovernorate: additionalAddresses[index].selectedGovernorate,
            selectedCity: additionalAddresses[index].selectedCity,
            selectedTown: additionalAddresses[index].selectedTown,
            villageController: additionalAddresses[index].villageController,
            streetController: additionalAddresses[index].streetController,
            streetNumberController:
                additionalAddresses[index].streetNumberController,
            buildingController: additionalAddresses[index].buildingController,
            labelController: additionalAddresses[index].labelController,
            typeController: additionalAddresses[index].typeController,
            enabled: enabled,
            fieldSpacer: fieldSpacer,
            onRemove: () => onRemoveAddress(index),
            onGovernorateChanged: (value) {
              additionalAddresses[index].selectedGovernorate = value;
              additionalAddresses[index].selectedCity = null;
              additionalAddresses[index].selectedTown = null;
            },
            onCityChanged: (value) {
              additionalAddresses[index].selectedCity = value;
              additionalAddresses[index].selectedTown = null;
            },
            onTownChanged: (value) {
              additionalAddresses[index].selectedTown = value;
            },
          ),
        ],
        if (enabled) ...[
          SizedBox(height: 14.h),
          OutlinedButton.icon(
            onPressed: onAddAddress,
            icon: const Icon(Icons.add_rounded),
            label: Text(
              hasCurrentAddress
                  ? l10n.associationAdditionalAddress
                  : l10n.associationAddCurrentAddress,
            ),
          ),
        ],
      ],
    );
  }
}

class _ProfileAddressFormFields extends StatefulWidget {
  const _ProfileAddressFormFields({
    required this.title,
    required this.selectedGovernorate,
    required this.selectedCity,
    required this.selectedTown,
    required this.villageController,
    required this.streetController,
    required this.streetNumberController,
    required this.buildingController,
    required this.enabled,
    required this.fieldSpacer,
    required this.onGovernorateChanged,
    required this.onCityChanged,
    required this.onTownChanged,
    this.labelController,
    this.typeController,
    this.onRemove,
  });

  final String title;
  final String? selectedGovernorate;
  final String? selectedCity;
  final String? selectedTown;
  final TextEditingController villageController;
  final TextEditingController streetController;
  final TextEditingController streetNumberController;
  final TextEditingController buildingController;
  final TextEditingController? labelController;
  final TextEditingController? typeController;
  final bool enabled;
  final Widget Function() fieldSpacer;
  final ValueChanged<String?> onGovernorateChanged;
  final ValueChanged<String?> onCityChanged;
  final ValueChanged<String?> onTownChanged;
  final VoidCallback? onRemove;

  @override
  State<_ProfileAddressFormFields> createState() =>
      _ProfileAddressFormFieldsState();
}

class _ProfileAddressFormFieldsState extends State<_ProfileAddressFormFields> {
  late final AddressInfoCubit _addressInfoCubit;
  late String? _selectedGovernorate;
  late String? _selectedCity;
  late String? _selectedTown;

  @override
  void initState() {
    super.initState();
    _selectedGovernorate = widget.selectedGovernorate;
    _selectedCity = widget.selectedCity;
    _selectedTown = widget.selectedTown;
    _addressInfoCubit = AddressInfoCubit()..fetchCapitals();
    if (_selectedGovernorate != null) {
      _addressInfoCubit.fetchCities(capitalId: _selectedGovernorate!);
    }
    if (_selectedCity != null) {
      _addressInfoCubit.fetchTowns(cityId: _selectedCity!);
    }
  }

  @override
  void didUpdateWidget(covariant _ProfileAddressFormFields oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedGovernorate != widget.selectedGovernorate) {
      _selectedGovernorate = widget.selectedGovernorate;
    }
    if (oldWidget.selectedCity != widget.selectedCity) {
      _selectedCity = widget.selectedCity;
    }
    if (oldWidget.selectedTown != widget.selectedTown) {
      _selectedTown = widget.selectedTown;
    }
  }

  @override
  void dispose() {
    _addressInfoCubit.close();
    super.dispose();
  }

  void _onGovernorateChanged(String? value) {
    widget.onGovernorateChanged(value);
    setState(() {
      _selectedGovernorate = value;
      _selectedCity = null;
      _selectedTown = null;
    });
    if (value != null) {
      _addressInfoCubit.fetchCities(capitalId: value);
    }
  }

  void _onCityChanged(String? value) {
    widget.onCityChanged(value);
    setState(() {
      _selectedCity = value;
      _selectedTown = null;
    });
    if (value != null) {
      _addressInfoCubit.fetchTowns(cityId: value);
    }
  }

  void _onTownChanged(String? value) {
    widget.onTownChanged(value);
    setState(() {
      _selectedTown = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final labelController = widget.labelController;
    final typeController = widget.typeController;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                widget.title,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            if (widget.enabled && widget.onRemove != null)
              IconButton(
                onPressed: widget.onRemove,
                tooltip: l10n.associationDeleteAddress,
                icon: const Icon(Icons.delete_outline_rounded),
              ),
          ],
        ),
        SizedBox(height: 12.h),
        if (labelController != null && typeController != null) ...[
          AppTextField(
            controller: labelController,
            label: l10n.associationAddressLabel,
            enabled: widget.enabled,
          ),
          widget.fieldSpacer(),
          AppTextField(
            controller: typeController,
            label: l10n.associationAddressType,
            enabled: widget.enabled,
          ),
          widget.fieldSpacer(),
        ],
        BlocBuilder<AddressInfoCubit, AddressInfoState>(
          bloc: _addressInfoCubit,
          builder: (context, addressState) {
            final capitalLabels = {
              for (final capital in addressState.capitals)
                capital.id: capital.name,
            };
            final cityLabels = {
              for (final city in addressState.cities) city.id: city.name,
            };
            final townLabels = {
              for (final town in addressState.towns) town.id: town.name,
            };

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AssociationDropdownField(
                  label: l10n.associationLinkGovernorate,
                  hintText: addressState.isLoadingCapitals
                      ? l10n.associationAddressLoadingCapitals
                      : l10n.associationAddressSelectCapital,
                  value: _selectedGovernorate,
                  items: addressState.capitals
                      .map((capital) => capital.id)
                      .toList(),
                  itemLabelBuilder: (id) => capitalLabels[id] ?? id,
                  enabled:
                      widget.enabled &&
                      !addressState.isLoadingCapitals &&
                      !addressState.capitalsFailed,
                  trailing: addressState.capitalsFailed
                      ? _AddressReloadButton(
                          onPressed: widget.enabled
                              ? _addressInfoCubit.fetchCapitals
                              : null,
                        )
                      : null,
                  onChanged: _onGovernorateChanged,
                ),
                SizedBox(height: 16.h),
                AssociationDropdownField(
                  label: l10n.associationLinkCity,
                  hintText: addressState.isLoadingCities
                      ? l10n.associationAddressLoadingCities
                      : l10n.associationAddressSelectCity,
                  value: _selectedCity,
                  items: addressState.cities.map((city) => city.id).toList(),
                  itemLabelBuilder: (id) => cityLabels[id] ?? id,
                  enabled:
                      widget.enabled &&
                      _selectedGovernorate != null &&
                      !addressState.isLoadingCities &&
                      !addressState.citiesFailed,
                  trailing:
                      addressState.citiesFailed && _selectedGovernorate != null
                      ? _AddressReloadButton(
                          onPressed: widget.enabled
                              ? () => _addressInfoCubit.fetchCities(
                                  capitalId: _selectedGovernorate!,
                                )
                              : null,
                        )
                      : null,
                  onChanged: _onCityChanged,
                ),
                SizedBox(height: 16.h),
                AssociationDropdownField(
                  label: l10n.associationLinkTown,
                  hintText: addressState.isLoadingTowns
                      ? l10n.associationAddressLoadingTowns
                      : l10n.associationAddressSelectTown,
                  value: _selectedTown,
                  items: addressState.towns.map((town) => town.id).toList(),
                  itemLabelBuilder: (id) => townLabels[id] ?? id,
                  enabled:
                      widget.enabled &&
                      _selectedCity != null &&
                      !addressState.isLoadingTowns &&
                      !addressState.townsFailed,
                  trailing: addressState.townsFailed && _selectedCity != null
                      ? _AddressReloadButton(
                          onPressed: widget.enabled
                              ? () => _addressInfoCubit.fetchTowns(
                                  cityId: _selectedCity!,
                                )
                              : null,
                        )
                      : null,
                  onChanged: _onTownChanged,
                ),
              ],
            );
          },
        ),
        widget.fieldSpacer(),
        AppTextField(
          controller: widget.villageController,
          label: l10n.associationLinkVillage,
          enabled: widget.enabled,
        ),
        widget.fieldSpacer(),
        AppTextField(
          controller: widget.streetController,
          label: l10n.associationLinkStreet,
          enabled: widget.enabled,
        ),
        widget.fieldSpacer(),
        AppTextField(
          controller: widget.streetNumberController,
          label: l10n.associationStreetNumber,
          enabled: widget.enabled,
        ),
        widget.fieldSpacer(),
        AppTextField(
          controller: widget.buildingController,
          label: l10n.associationLinkBuilding,
          enabled: widget.enabled,
        ),
      ],
    );
  }
}

class _AddressReloadButton extends StatelessWidget {
  const _AddressReloadButton({required this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(end: 4.w),
      child: TextButton.icon(
        onPressed: onPressed,
        icon: Icon(Icons.refresh_rounded, size: 18.r),
        label: Text(AppLocalizations.of(context)!.associationAddressLoadAgain),
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          minimumSize: Size(0, 36.h),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
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
