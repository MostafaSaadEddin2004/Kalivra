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
import 'package:kalivra/model/services/api/customer_api_service.dart';
import 'package:kalivra/view/widgets/app_text_field.dart';
import 'package:kalivra/view/widgets/custom_snack_bar.dart';
import 'package:kalivra/view/widgets/drawer/drawer_screen_app_bar.dart';

const String _kMediaOrigin = 'https://test1.zedan-world.com';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();
  final _postalController = TextEditingController();
  final _dobController = TextEditingController();

  String? _gender;
  File? _pickedAvatarFile;
  String? _networkAvatarUrl;
  bool _didApplyCustomer = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    _postalController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = context.read<AuthCubit>().state;
      if (state is AuthFetchedData) {
        _applyCustomer(state.customer);
      } else {
        context.read<AuthCubit>().loadProfile();
      }
    });
  }

  static String? _resolveAvatarUrl(String? avatar) {
    if (avatar == null || avatar.isEmpty) return null;
    if (avatar.startsWith('http')) return avatar;
    return avatar.startsWith('/') ? '$_kMediaOrigin$avatar' : '$_kMediaOrigin/$avatar';
  }

  void _applyCustomer(CustomerApiModel c) {
    final fn = c.firstName ?? '';
    final ln = c.lastName ?? '';
    _nameController.text = (c.name ?? '$fn $ln').trim();
    _emailController.text = c.email ?? '';
    _phoneController.text = c.phone ?? '';
    _addressController.text = c.address ?? '';
    _cityController.text = c.city ?? '';
    _countryController.text = c.country ?? '';
    _postalController.text = c.postalCode ?? '';
    _dobController.text = c.dateOfBirth ?? '';
    final g = c.gender?.toLowerCase().trim();
    _gender = (g == 'male' || g == 'female' || g == 'other') ? g : null;
    _networkAvatarUrl = _resolveAvatarUrl(c.avatar);
    _didApplyCustomer = true;
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
            address: _addressController.text.trim(),
            city: _cityController.text.trim(),
            country: _countryController.text.trim(),
            postalCode: _postalController.text.trim(),
            firstName: first.isNotEmpty ? first : null,
            lastName: last.isNotEmpty ? last : null,
            gender: _gender,
            dateOfBirth: _dobController.text.trim().isEmpty
                ? null
                : _dobController.text.trim(),
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

    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen: (prev, curr) =>
          curr is AuthFetchedData && !_didApplyCustomer,
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
                          child: _pickedAvatarFile == null &&
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
                        color:
                            isDark ? AppColors.taupe : AppColors.burgundy,
                      ),
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? l10n.enterName : null,
                    ),
                    SizedBox(height: 16.h),
                    AppTextField(
                      controller: _emailController,
                      label: l10n.email,
                      hint: l10n.emailHint,
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        size: 22.r,
                        color:
                            isDark ? AppColors.taupe : AppColors.burgundy,
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
                      hint: '+966 5XX XXX XXXX',
                      prefixIcon: Icon(
                        Icons.phone_android_rounded,
                        size: 22.r,
                        color:
                            isDark ? AppColors.taupe : AppColors.burgundy,
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? l10n.enterPhone
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
                        color:
                            isDark ? AppColors.taupe : AppColors.burgundy,
                      ),
                      keyboardType: TextInputType.datetime,
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
                      prefixIcon: Icon(
                        Icons.place_outlined,
                        size: 22.r,
                        color:
                            isDark ? AppColors.taupe : AppColors.burgundy,
                      ),
                      maxLines: 2,
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? l10n.enterAddressShort
                          : null,
                    ),
                    SizedBox(height: 16.h),
                    AppTextField(
                      controller: _cityController,
                      label: l10n.profileCity,
                      hint: l10n.cityRequired,
                      prefixIcon: Icon(
                        Icons.location_city_outlined,
                        size: 22.r,
                        color:
                            isDark ? AppColors.taupe : AppColors.burgundy,
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? l10n.enterAddressShort
                          : null,
                    ),
                    SizedBox(height: 16.h),
                    AppTextField(
                      controller: _countryController,
                      label: l10n.profileCountry,
                      hint: l10n.profileCountry,
                      prefixIcon: Icon(
                        Icons.public_outlined,
                        size: 22.r,
                        color:
                            isDark ? AppColors.taupe : AppColors.burgundy,
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? l10n.enterAddressShort
                          : null,
                    ),
                    SizedBox(height: 16.h),
                    AppTextField(
                      controller: _postalController,
                      label: l10n.postalCode,
                      hint: '12345',
                      prefixIcon: Icon(
                        Icons.markunread_mailbox_rounded,
                        size: 22.r,
                        color:
                            isDark ? AppColors.taupe : AppColors.burgundy,
                      ),
                      keyboardType: TextInputType.number,
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? l10n.enterPostalCodeShort
                          : null,
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
