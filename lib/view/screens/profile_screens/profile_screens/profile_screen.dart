import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/controller/blocs/cubit/auth_cubit/auth_cubit.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/model/customer/customer_api_model.dart';
import 'package:kalivra/view/widgets/profile_page/screen_app_bar.dart';
import 'package:kalivra/view/widgets/profile/referral_qr_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

const String _kMediaOrigin = 'https://test1.zedan-world.com';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  static String? _resolveAvatarUrl(String? avatar) {
    if (avatar == null || avatar.isEmpty) return null;
    if (avatar.startsWith('http')) return avatar;
    return avatar.startsWith('/')
        ? '$_kMediaOrigin$avatar'
        : '$_kMediaOrigin/$avatar';
  }

  String _formatBalance(num? value) {
    if (value == null) return '---';
    if (value % 1 == 0) return value.toInt().toString();
    return value.toStringAsFixed(2);
  }

  List<Widget> _buildAddressCards(
    BuildContext context,
    CustomerAddressInformation? addressInfo,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final cards = <Widget>[];
    final permanent = addressInfo?.permanent;
    final current = addressInfo?.current;
    final additional =
        addressInfo?.additional ?? const <CustomerAddressEntry>[];

    if (permanent != null && permanent.hasContent) {
      cards.add(
        _AddressDisplayCard(
          title: l10n.associationLinkPermanentAddress,
          address: permanent,
          icon: Icons.home_work_outlined,
        ),
      );
    }

    if (current != null && current.hasContent) {
      cards.add(
        _AddressDisplayCard(
          title: l10n.associationMemberCurrentAddress,
          address: current,
          icon: Icons.location_on_outlined,
        ),
      );
    }

    for (var index = 0; index < additional.length; index++) {
      final address = additional[index];
      if (!address.hasContent) continue;
      cards.add(
        _AddressDisplayCard(
          title: '${l10n.associationAdditionalAddress} ${index + 1}',
          address: address,
          icon: Icons.add_location_alt_outlined,
        ),
      );
    }

    if (cards.isEmpty) {
      return [
        _InfoRow(
          label: l10n.userLocationInfo,
          value: '---',
          icon: Icons.location_off_outlined,
        ),
      ];
    }

    return [
      for (var index = 0; index < cards.length; index++) ...[
        if (index > 0) SizedBox(height: 12.h),
        cards[index],
      ],
    ];
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final authCubit = context.read<AuthCubit>();
      authCubit.loadProfile(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final isDark = theme.brightness == Brightness.dark;
    final labelColor = isDark ? AppColors.taupe : AppColors.burgundy;

    return Scaffold(
      appBar: ScreenAppBar(
        title: l10n.myAccount,
        actions: [
          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              switch (state) {
                case AuthFetchedData():
                  return PopupMenuButton<_ProfileMenuAction>(
                    constraints: BoxConstraints(maxWidth: 200.w),
                    position: PopupMenuPosition.under,
                    icon: const Icon(Icons.menu_rounded),
                    onSelected: (value) {
                      switch (value) {
                        case _ProfileMenuAction.editProfile:
                          final authState = context.read<AuthCubit>().state;
                          if (authState is AuthFetchedData) {
                            context.push(
                              AppRoutes.editProfile,
                              extra: authState.customer,
                            );
                          }
                          break;
                        case _ProfileMenuAction.associationMemberProfile:
                          context.push(AppRoutes.associationMemberProfile);
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: _ProfileMenuAction.editProfile,
                        child: Row(
                          children: [
                            Icon(
                              Icons.edit_rounded,
                              size: 20.r,
                              color: theme.colorScheme.onTertiaryFixed,
                            ),
                            const SizedBox(width: 12),
                            Text(l10n.editProfile, style: textTheme.bodyMedium),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: _ProfileMenuAction.associationMemberProfile,
                        child: Row(
                          children: [
                            Icon(
                              Icons.groups_rounded,
                              size: 20.r,
                              color: theme.colorScheme.onTertiaryFixed,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              l10n.associationPersonalProfileButton,
                              style: textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                default:
                  return SizedBox.shrink();
              }
            },
          ),
        ],
      ),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          switch (state) {
            case UnAuthinticated():
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        state.message,
                        style: textTheme.bodyLarge?.copyWith(color: labelColor),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 24.h),
                      FilledButton(
                        onPressed: () =>
                            AppRouter.openScreen(context, AppRoutes.login),
                        child: Text(l10n.signIn),
                      ),
                    ],
                  ),
                ),
              );
            case AuthLoading():
              return Skeletonizer(
                enabled: true,
                child: ListView(
                  padding: EdgeInsets.all(20.w),
                  children: [
                    Center(
                      child: Column(
                        children: [
                          CircleAvatar(radius: 48.r),
                          SizedBox(height: 12.h),
                          Text('asascasdsad', style: textTheme.headlineSmall),
                          SizedBox(height: 8.h),
                        ],
                      ),
                    ),
                    _SectionCard(
                      title: l10n.accountInfo,
                      children: [
                        _InfoRow(
                          label: l10n.name,
                          value: '---',
                          icon: Icons.person_outline_rounded,
                        ),
                        _InfoRow(
                          label: l10n.email,
                          value: '---',
                          icon: Icons.email_outlined,
                        ),
                        _InfoRow(
                          label: l10n.email,
                          value: '---',
                          icon: Icons.email_outlined,
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    _SectionCard(
                      title: l10n.accountInfo,
                      children: [
                        _InfoRow(
                          label: l10n.name,
                          value: '---',
                          icon: Icons.person_outline_rounded,
                        ),
                        _InfoRow(
                          label: l10n.email,
                          value: '---',
                          icon: Icons.email_outlined,
                        ),
                        _InfoRow(
                          label: l10n.email,
                          value: '---',
                          icon: Icons.email_outlined,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            case AuthFetchedData():
              final customer = state.customer;
              final firstName = customer.firstName ?? '';
              final lastName = customer.lastName ?? '';
              final fullName = '$firstName $lastName'.trim();
              final addressInfo = customer.addressInformation;
              final avatarUrl = _resolveAvatarUrl(customer.displayImageUrl);
              final referralCode = customer.referralCode;
              return ListView(
                padding: EdgeInsets.all(20.w),
                children: [
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 48.r,
                          backgroundColor: isDark
                              ? AppColors.burgundy.withValues(alpha: 0.3)
                              : AppColors.burgundy.withValues(alpha: 0.15),
                          backgroundImage: avatarUrl != null
                              ? NetworkImage(avatarUrl)
                              : null,
                          child: avatarUrl == null
                              ? Icon(
                                  Icons.person_rounded,
                                  size: 56.r,
                                  color: isDark
                                      ? AppColors.goldLight
                                      : AppColors.burgundy,
                                )
                              : null,
                        ),
                        SizedBox(height: 12.h),
                      ],
                    ),
                  ),
                  if (referralCode != null && referralCode.isNotEmpty)
                    ReferralQrCard(referralCode: referralCode),
                  SizedBox(height: 16.h),
                  _SectionCard(
                    title: l10n.accountInfo,
                    children: [
                      firstName.isEmpty && lastName.isEmpty
                          ? _InfoRow(
                              label: l10n.name,
                              value: customer.name ?? '---',
                              icon: Icons.person_outline_rounded,
                            )
                          : SizedBox(),
                      _InfoRow(
                        label: l10n.fullName,
                        value: fullName.isEmpty ? '---' : fullName,
                        icon: Icons.person_outline_rounded,
                      ),
                      _InfoRow(
                        label: 'User Balance',
                        value: _formatBalance(customer.userBalance),
                        icon: Icons.account_balance_wallet_outlined,
                      ),
                      _InfoRow(
                        label: l10n.genderLabel,
                        value: customer.gender ?? '---',
                        icon: Icons.person_pin_outlined,
                      ),
                      _InfoRow(
                        label: l10n.dateOfBirthLabel,
                        value: customer.dateOfBirth ?? '---',
                        icon: Icons.calendar_month,
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  _SectionCard(
                    title: l10n.contactInfo,
                    children: [
                      _InfoRow(
                        label: l10n.email,
                        value: customer.email ?? '---',
                        icon: Icons.email_outlined,
                      ),
                      _InfoRow(
                        label: l10n.mobileNumber,
                        value: customer.phone ?? '---',
                        icon: Icons.phone_android_rounded,
                      ),
                      _InfoRow(
                        label: l10n.whatsappNumber,
                        value: customer.whatsappNumber ?? '---',
                        icon: Icons.call,
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  _SectionCard(
                    title: l10n.userLocationInfo,
                    children: _buildAddressCards(context, addressInfo),
                  ),
                  SizedBox(height: 24.h),
                ],
              );
            case AuthFailed():
              return Center(child: Text(state.message));
            default:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                color: isDark ? AppColors.goldLight : AppColors.burgundy,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 12.h),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final labelColor = isDark ? AppColors.taupe : AppColors.burgundy;
    final valueColor = isDark ? AppColors.offWhite : AppColors.black;

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22.r, color: labelColor),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(color: labelColor),
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: valueColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AddressDisplayCard extends StatelessWidget {
  const _AddressDisplayCard({
    required this.title,
    required this.address,
    required this.icon,
  });

  final String title;
  final CustomerAddressEntry address;
  final IconData icon;

  String _dash(String? value) {
    final text = value?.trim();
    return text == null || text.isEmpty ? '---' : text;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primary = isDark ? AppColors.goldLight : AppColors.burgundy;
    final muted = isDark ? AppColors.taupe : AppColors.burgundy;
    final surface = isDark
        ? AppColors.burgundy.withValues(alpha: 0.16)
        : AppColors.burgundy.withValues(alpha: 0.05);
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: primary.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40.r,
                height: 40.r,
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: primary, size: 22.r),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      address.displayAddress.isEmpty
                          ? '---'
                          : address.displayAddress,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDark ? AppColors.offWhite : AppColors.black,
                        height: 1.35,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              if (address.label != null)
                _AddressChip(
                  label: l10n.associationAddressLabel,
                  value: address.label!,
                ),
              if (address.type != null)
                _AddressChip(
                  label: l10n.associationAddressType,
                  value: address.type!,
                ),
            ],
          ),
          if (address.label != null || address.type != null)
            SizedBox(height: 10.h),
          _AddressDetailGrid(
            rows: [
              _AddressDetail(
                l10n.associationLinkGovernorate,
                _dash(address.capital),
              ),
              _AddressDetail(l10n.profileCity, _dash(address.city)),
              _AddressDetail(l10n.associationLinkTown, _dash(address.town)),
              _AddressDetail(
                l10n.associationLinkVillage,
                _dash(address.village),
              ),
              _AddressDetail(
                l10n.associationLinkStreet,
                _dash(address.streetName),
              ),
              _AddressDetail(
                l10n.associationStreetNumber,
                _dash(address.streetNumber),
              ),
              _AddressDetail(
                l10n.associationLinkBuilding,
                _dash(address.building),
              ),
              if (address.notes != null)
                _AddressDetail('Notes', _dash(address.notes)),
            ],
            muted: muted,
          ),
        ],
      ),
    );
  }
}

class _AddressChip extends StatelessWidget {
  const _AddressChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final color = isDark ? AppColors.goldLight : AppColors.burgundy;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Text(
        '$label: $value',
        style: theme.textTheme.bodySmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _AddressDetail {
  const _AddressDetail(this.label, this.value);

  final String label;
  final String value;
}

class _AddressDetailGrid extends StatelessWidget {
  const _AddressDetailGrid({required this.rows, required this.muted});

  final List<_AddressDetail> rows;
  final Color muted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final valueColor = isDark ? AppColors.offWhite : AppColors.black;
    return Column(
      children: [
        for (final row in rows)
          Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 118.w,
                  child: Text(
                    row.label,
                    style: theme.textTheme.bodySmall?.copyWith(color: muted),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    row.value,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: valueColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

enum _ProfileMenuAction { editProfile, associationMemberProfile }
