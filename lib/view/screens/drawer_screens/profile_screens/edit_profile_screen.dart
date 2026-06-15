import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kalivra/controller/blocs/cubit/auth_cubit/auth_cubit.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/model/customer/customer_api_model.dart';
import 'package:kalivra/model/location/syrian_location_catalog.dart';
import 'package:kalivra/model/services/api/customer_api_service.dart';
import 'package:kalivra/view/widgets/app_text_field.dart';
import 'package:kalivra/view/widgets/association/association_dropdown_field.dart';
import 'package:kalivra/view/widgets/custom_snack_bar.dart';
import 'package:kalivra/view/widgets/drawer/drawer_screen_app_bar.dart';

const String _kMediaOrigin = 'https://test1.zedan-world.com';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key, required this.userInfo});
  final CustomerApiModel userInfo;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _fatherNameController = TextEditingController();
  final _motherNameController = TextEditingController();
  final _nationalIdController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _whatsAppController = TextEditingController();
  final _countryController = TextEditingController();
  final _postalController = TextEditingController();
  final _dobController = TextEditingController();
  final _streetController = TextEditingController();
  final _buildingController = TextEditingController();
  final _permanentAddressController = TextEditingController();

  String? _gender;
  String? _selectedGovernorate;
  String? _selectedCity;
  String? _selectedTown;
  String? _selectedVillage;
  String? _initialGovernorate;
  String? _initialCity;
  String? _initialTown;
  String? _initialVillage;
  int? _selectedGovernorateId;
  int? _selectedCityId;
  int? _selectedTownId;
  int? _selectedVillageId;
  int? _initialGovernorateId;
  int? _initialCityId;
  int? _initialTownId;
  int? _initialVillageId;
  File? _pickedAvatarFile;
  String? _networkAvatarUrl;
  bool _didApplyCustomer = false;

  @override
  void dispose() {
    _nameController.dispose();
    _fatherNameController.dispose();
    _motherNameController.dispose();
    _nationalIdController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _whatsAppController.dispose();
    _countryController.dispose();
    _postalController.dispose();
    _dobController.dispose();
    _streetController.dispose();
    _buildingController.dispose();
    _permanentAddressController.dispose();
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
    final fn = c.firstName ?? '';
    final ln = c.lastName ?? '';
    final addressInfo = c.addressInformation;
    _nameController.text = (c.name ?? '$fn $ln').trim();
    _fatherNameController.text = c.fatherName ?? '';
    _motherNameController.text = c.motherName ?? '';
    _nationalIdController.text = c.nationalId ?? '';
    _emailController.text = c.email ?? '';
    _phoneController.text = c.phone ?? '';
    _whatsAppController.text = c.whatsappNumber ?? '';
    _countryController.text = c.country ?? '';
    _postalController.text = c.postalCode ?? '';
    _dobController.text = c.dateOfBirth ?? '';
    _selectedGovernorate = addressInfo?.officialGovernorate;
    _selectedCity = addressInfo?.officialCity;
    _selectedTown = addressInfo?.officialTown;
    _selectedVillage = addressInfo?.officialMunicipalityVillage;
    _initialGovernorate = _selectedGovernorate;
    _initialCity = _selectedCity;
    _initialTown = _selectedTown;
    _initialVillage = _selectedVillage;
    _selectedGovernorateId = addressInfo?.permanentCapitalId;
    _selectedCityId = addressInfo?.permanentCityId;
    _selectedTownId = addressInfo?.permanentTownId;
    _selectedVillageId = addressInfo?.permanentVillageId;
    _initialGovernorateId = _selectedGovernorateId;
    _initialCityId = _selectedCityId;
    _initialTownId = _selectedTownId;
    _initialVillageId = _selectedVillageId;
    _streetController.text = addressInfo?.officialStreet ?? '';
    _buildingController.text = addressInfo?.officialBuilding ?? '';
    _permanentAddressController.text = addressInfo?.permanentAddress ?? '';
    final g = c.gender?.toLowerCase().trim();
    _gender = (g == 'male' || g == 'female' || g == 'other') ? g : null;
    _networkAvatarUrl = _resolveAvatarUrl(c.avatar);
    _didApplyCustomer = true;
  }

  void _onGovernorateChanged(String? value) {
    setState(() {
      _selectedGovernorate = value;
      _selectedCity = null;
      _selectedTown = null;
      _selectedVillage = null;
      _selectedGovernorateId = value == _initialGovernorate
          ? _initialGovernorateId
          : null;
      _selectedCityId = null;
      _selectedTownId = null;
      _selectedVillageId = null;
    });
  }

  void _onCityChanged(String? value) {
    setState(() {
      _selectedCity = value;
      _selectedTown = null;
      _selectedVillage = null;
      _selectedCityId = value == _initialCity ? _initialCityId : null;
      _selectedTownId = null;
      _selectedVillageId = null;
    });
  }

  void _onTownChanged(String? value) {
    setState(() {
      _selectedTown = value;
      _selectedVillage = null;
      _selectedTownId = value == _initialTown ? _initialTownId : null;
      _selectedVillageId = null;
    });
  }

  void _onVillageChanged(String? value) {
    setState(() {
      _selectedVillage = value;
      _selectedVillageId = value == _initialVillage ? _initialVillageId : null;
    });
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

    final trimmedName = _nameController.text.trim();
    final parts = trimmedName.split(RegExp(r'\s+'));
    final first = parts.isNotEmpty ? parts.first : '';
    final last = parts.length > 1 ? parts.sublist(1).join(' ') : '';

    try {
      await context.read<AuthCubit>().updateProfile(
        name: trimmedName,
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        address: _permanentAddressController.text.trim(),
        city: _selectedCity ?? '',
        country: _countryController.text.trim(),
        postalCode: _postalController.text.trim(),
        firstName: first.isNotEmpty ? first : null,
        lastName: last.isNotEmpty ? last : null,
        fatherName: _fatherNameController.text.trim().isEmpty
            ? null
            : _fatherNameController.text.trim(),
        motherName: _motherNameController.text.trim().isEmpty
            ? null
            : _motherNameController.text.trim(),
        nationalId: _nationalIdController.text.trim().isEmpty
            ? null
            : _nationalIdController.text.trim(),
        whatsappNumber: _whatsAppController.text.trim().isEmpty
            ? null
            : _whatsAppController.text.trim(),
        gender: _gender,
        dateOfBirth: _dobController.text.trim().isEmpty
            ? null
            : _dobController.text.trim(),
        permanentCapitalId: _selectedGovernorateId,
        permanentCityId: _selectedCityId,
        permanentTownId: _selectedTownId,
        permanentVillageId: _selectedVillageId,
        officialGovernorate: _selectedGovernorate,
        officialCity: _selectedCity,
        officialTown: _selectedTown,
        officialMunicipalityVillage: _selectedVillage,
        officialStreet: _streetController.text.trim().isEmpty
            ? null
            : _streetController.text.trim(),
        officialBuilding: _buildingController.text.trim().isEmpty
            ? null
            : _buildingController.text.trim(),
        permanentAddress: _permanentAddressController.text.trim().isEmpty
            ? null
            : _permanentAddressController.text.trim(),
        avatarFile: f,
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final labelColor = isDark ? AppColors.taupe : AppColors.burgundy;
    final nationalIdLabel = l10n.localeName == 'ar'
        ? 'رقم الهوية'
        : 'National ID';

    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen: (prev, curr) => curr is AuthFetchedData && !_didApplyCustomer,
      listener: (context, state) {
        if (state is AuthFetchedData) {
          setState(() => _applyCustomer(state.customer));
        }
      },
      builder: (context, state) {
        final busy = state is AuthLoading;

        return Scaffold(
          appBar: DrawerScreenAppBar(title: l10n.editProfileTitle),
          body: Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
              children: [
                Center(
                  child: InkWell(
                    onTap: busy ? null : _pickAvatar,
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
                      controller: _nameController,
                      label: l10n.fullName,
                      hint: l10n.enterFullNameHint,
                      prefixIcon: Icon(
                        Icons.badge_outlined,
                        size: 22.r,
                        color: isDark ? AppColors.taupe : AppColors.burgundy,
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? l10n.enterName
                          : null,
                    ),
                    SizedBox(height: 16.h),
                    AppTextField(
                      controller: _fatherNameController,
                      label: l10n.associationLinkFatherName,
                      prefixIcon: Icon(
                        Icons.family_restroom_rounded,
                        size: 22.r,
                        color: isDark ? AppColors.taupe : AppColors.burgundy,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    AppTextField(
                      controller: _motherNameController,
                      label: l10n.associationLinkMotherName,
                      prefixIcon: Icon(
                        Icons.family_restroom_outlined,
                        size: 22.r,
                        color: isDark ? AppColors.taupe : AppColors.burgundy,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    AppTextField(
                      controller: _nationalIdController,
                      label: nationalIdLabel,
                      prefixIcon: Icon(
                        Icons.badge_rounded,
                        size: 22.r,
                        color: isDark ? AppColors.taupe : AppColors.burgundy,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 16.h),
                    DropdownButtonFormField<String?>(
                      key: ValueKey(_gender),
                      initialValue: _gender,
                      decoration: InputDecoration(
                        labelText: l10n.genderLabel,
                        prefixIcon: Icon(
                          Icons.wc_rounded,
                          size: 22.r,
                          color: labelColor,
                        ),
                      ),
                      items: [
                        DropdownMenuItem<String?>(
                          value: null,
                          child: Text(l10n.dash),
                        ),
                        DropdownMenuItem(
                          value: 'male',
                          child: Text(l10n.genderMale),
                        ),
                        DropdownMenuItem(
                          value: 'female',
                          child: Text(l10n.genderFemale),
                        ),
                        DropdownMenuItem(
                          value: 'other',
                          child: Text(l10n.genderOther),
                        ),
                      ],
                      onChanged: busy
                          ? null
                          : (v) => setState(() => _gender = v),
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
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                _SectionCard(
                  title: l10n.contactInfo,
                  icon: Icons.contact_phone_outlined,
                  children: [
                    AppTextField(
                      controller: _emailController,
                      label: l10n.email,
                      hint: l10n.emailHint,
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        size: 22.r,
                        color: isDark ? AppColors.taupe : AppColors.burgundy,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return l10n.enterEmailShort;
                        }
                        if (!v.contains('@')) return l10n.invalidEmail;
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),
                    AppTextField(
                      controller: _phoneController,
                      label: l10n.mobileNumber,
                      hint: '+963 9XX XXX XXX',
                      prefixIcon: Icon(
                        Icons.phone_android_rounded,
                        size: 22.r,
                        color: isDark ? AppColors.taupe : AppColors.burgundy,
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? l10n.enterPhone
                          : null,
                    ),
                    SizedBox(height: 16.h),
                    AppTextField(
                      controller: _whatsAppController,
                      label: l10n.whatsappNumber,
                      hint: '+963 9XX XXX XXX',
                      prefixIcon: Icon(
                        Icons.call,
                        size: 22.r,
                        color: isDark ? AppColors.taupe : AppColors.burgundy,
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                _SectionCard(
                  title: l10n.userLocationInfo,
                  icon: Icons.location_on_outlined,
                  children: [
                    _TwoColumnRow(
                      start: AssociationDropdownField(
                        label: l10n.associationLinkGovernorate,
                        value: _selectedGovernorate,
                        items: SyrianLocationCatalog.withSavedValue(
                          SyrianLocationCatalog.governorates(),
                          _selectedGovernorate,
                        ),
                        enabled: !busy,
                        onChanged: _onGovernorateChanged,
                      ),
                      end: AssociationDropdownField(
                        label: l10n.associationLinkCity,
                        value: _selectedCity,
                        items: SyrianLocationCatalog.withSavedValue(
                          SyrianLocationCatalog.cities(_selectedGovernorate),
                          _selectedCity,
                        ),
                        enabled: !busy && _selectedGovernorate != null,
                        onChanged: _onCityChanged,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    _TwoColumnRow(
                      start: AssociationDropdownField(
                        label: l10n.associationLinkTown,
                        value: _selectedTown,
                        items: SyrianLocationCatalog.withSavedValue(
                          SyrianLocationCatalog.towns(
                            _selectedGovernorate,
                            _selectedCity,
                          ),
                          _selectedTown,
                        ),
                        enabled: !busy && _selectedCity != null,
                        onChanged: _onTownChanged,
                      ),
                      end: AssociationDropdownField(
                        label: l10n.associationLinkVillage,
                        value: _selectedVillage,
                        items: SyrianLocationCatalog.withSavedValue(
                          SyrianLocationCatalog.villages(
                            _selectedGovernorate,
                            _selectedCity,
                            _selectedTown,
                          ),
                          _selectedVillage,
                        ),
                        enabled: !busy && _selectedTown != null,
                        onChanged: _onVillageChanged,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    AppTextField(
                      controller: _streetController,
                      label: l10n.associationLinkStreet,
                      prefixIcon: Icon(
                        Icons.signpost_outlined,
                        size: 22.r,
                        color: isDark ? AppColors.taupe : AppColors.burgundy,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    AppTextField(
                      controller: _buildingController,
                      label: l10n.associationLinkBuilding,
                      prefixIcon: Icon(
                        Icons.apartment_rounded,
                        size: 22.r,
                        color: isDark ? AppColors.taupe : AppColors.burgundy,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    AppTextField(
                      controller: _permanentAddressController,
                      label: l10n.associationLinkPermanentAddress,
                      hint: l10n.cityAreaStreet,
                      prefixIcon: Icon(
                        Icons.place_outlined,
                        size: 22.r,
                        color: isDark ? AppColors.taupe : AppColors.burgundy,
                      ),
                      maxLines: 2,
                    ),
                  ],
                ),
                SizedBox(height: 32.h),
                FilledButton.icon(
                  onPressed: busy ? null : _save,
                  icon: busy
                      ? SizedBox(
                          height: 22.h,
                          width: 22.w,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.offWhite,
                          ),
                        )
                      : Icon(Icons.check_rounded, size: 22.r),
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
      },
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

class _TwoColumnRow extends StatelessWidget {
  const _TwoColumnRow({required this.start, required this.end});

  final Widget start;
  final Widget end;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: start),
        SizedBox(width: 12.w),
        Expanded(child: end),
      ],
    );
  }
}
