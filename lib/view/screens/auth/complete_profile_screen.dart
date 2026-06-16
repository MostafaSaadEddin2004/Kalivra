import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kalivra/controller/blocs/cubit/auth_cubit/auth_cubit.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/model/location/syrian_location_catalog.dart';
import 'package:kalivra/model/services/api/customer_api_service.dart';
import 'package:kalivra/view/screens/drawer_screens/change_password_screen.dart';
import 'package:kalivra/view/widgets/app_text_field.dart';
import 'package:kalivra/view/widgets/association/association_dropdown_field.dart';
import 'package:kalivra/view/widgets/custom_snack_bar.dart';
import 'package:kalivra/view/widgets/drawer/drawer_screen_app_bar.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key, this.args});

  final OtpOnboardingArgs? args;

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
 final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _countryController = TextEditingController();
  final _dobController = TextEditingController();
  final _streetController = TextEditingController();
  final _buildingController = TextEditingController();
  final _permanentAddressController = TextEditingController();

  String? _gender;
  String? _selectedGovernorate;
  String? _selectedCity;
  String? _selectedTown;
  String? _selectedVillage;
  File? _pickedAvatarFile;
  String? _networkAvatarUrl;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _countryController.dispose();
    _dobController.dispose();
    _streetController.dispose();
    _buildingController.dispose();
    _permanentAddressController.dispose();
    super.dispose();
  }


  void _onGovernorateChanged(String? value) {
    setState(() {
      _selectedGovernorate = value;
      _selectedCity = null;
      _selectedTown = null;
      _selectedVillage = null;
    });
  }

  void _onCityChanged(String? value) {
    setState(() {
      _selectedCity = value;
      _selectedTown = null;
      _selectedVillage = null;
    });
  }

  void _onTownChanged(String? value) {
    setState(() {
      _selectedTown = value;
      _selectedVillage = null;
    });
  }

  void _onVillageChanged(String? value) {
    setState(() {
      _selectedVillage = value;
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

    try {
      await context.read<AuthCubit>().updateProfile(
        phone: _phoneController.text.trim(),
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        gender: _gender,
        dateOfBirth: _dobController.text.trim().isEmpty
            ? null
            : _dobController.text.trim(),
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
      listener: (context, state) {
        switch (state) {
          case AuthLoading():
            isLoading=true;
          default:
          isLoading=false;
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: DrawerScreenAppBar(title: l10n.editProfileTitle),
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
                      ],
                      onChanged: (v) => setState(() => _gender = v),
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
                  ],
                ),
                SizedBox(height: 20.h),
                _SectionCard(
                  title: l10n.userLocationInfo,
                  icon: Icons.location_on_outlined,
                  children: [
                    AssociationDropdownField(
                      label: l10n.associationLinkGovernorate,
                      value: _selectedGovernorate,
                      items: SyrianLocationCatalog.withSavedValue(
                        SyrianLocationCatalog.governorates(),
                        _selectedGovernorate,
                      ),
                      enabled: !isLoading,
                      onChanged: _onGovernorateChanged,
                    ),
                    SizedBox(height: 16.h),

                    AssociationDropdownField(
                      label: l10n.associationLinkCity,
                      value: _selectedCity,
                      items: SyrianLocationCatalog.withSavedValue(
                        SyrianLocationCatalog.cities(_selectedGovernorate),
                        _selectedCity,
                      ),
                      enabled: !isLoading && _selectedGovernorate != null,
                      onChanged: _onCityChanged,
                    ),SizedBox(height: 16.h),
                    AssociationDropdownField(
                      label: l10n.associationLinkTown,
                      value: _selectedTown,
                      items: SyrianLocationCatalog.withSavedValue(
                        SyrianLocationCatalog.towns(
                          _selectedGovernorate,
                          _selectedCity,
                        ),
                        _selectedTown,
                      ),
                      enabled: !isLoading && _selectedCity != null,
                      onChanged: _onTownChanged,
                    ),
                    SizedBox(height: 16.h),
                    AssociationDropdownField(
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
                      enabled: !isLoading && _selectedTown != null,
                      onChanged: _onVillageChanged,
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
