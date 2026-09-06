import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/controller/blocs/cubit/auth_cubit/auth_cubit.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/model/customer/customer_api_model.dart';
import 'package:kalivra/view/screens/home/profile_page.dart';
import 'package:kalivra/view/widgets/app_refresh_indicator.dart';
import 'package:kalivra/view/widgets/empty_state_view.dart';
import 'package:kalivra/view/widgets/profile_page/screen_app_bar.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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
      _refreshProfile();
    });
  }

  Future<void> _refreshProfile() {
    return context.read<AuthCubit>().loadProfile(context);
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
                              color: AppColors.burgundy,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              l10n.editProfile,
                              style: textTheme.bodyMedium!.copyWith(
                                color: AppColors.burgundy,
                              ),
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
      body: AppRefreshIndicator(
        onRefresh: _refreshProfile,
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            switch (state) {
              case UnAuthinticated():
                return RefreshableStateBox(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(24.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            state.message,
                            style: textTheme.bodyLarge?.copyWith(
                              color: labelColor,
                            ),
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
                  ),
                );
              case AuthLoading():
                return Skeletonizer(
                  enabled: true,
                  child: ListView(
                    padding: EdgeInsets.all(20.w),
                    children: [
                      Column(
                        children: [
                          ProfileHeroCard(customer: CustomerApiModel(id: 0)),
                          SizedBox(height: 12.h),
                        
                        ],
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
                final addressInfo = customer.addressInformation;
                return ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.all(20.w),
                  children: [
                    Column(
                      children: [
                        ProfileHeroCard(customer: customer),
                        SizedBox(height: 12.h),
                      ],
                    ),
                    customer.isLinkedPerson == false
                        ? FilledButton(
                            onPressed: () => context.push(
                              AppRoutes.associationRequestsAndServices,
                            ),
                            style: FilledButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 8.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14.r),
                              ),
                              elevation: 0,
                              backgroundColor:
                                  theme.colorScheme.onTertiaryFixed,
                            ),
                            child: Text(
                              l10n.associaitionSendLinkRequest,
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: theme.colorScheme.secondaryFixed,
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                    _SectionCard(
                      title: l10n.accountInfo,
                      children: [
                        _InfoRow(
                          label: l10n.userBalance,
                          value: _formatBalance(customer.userBalance),
                          icon: Icons.account_balance_wallet_outlined,
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
                return RefreshableStateBox(
                  child: EmptyStateView(
                    icon: Icons.person_off_outlined,
                    title: l10n.unexpectedError,
                    description: state.message,
                    actionLabel: l10n.retry,
                    onAction: _refreshProfile,
                  ),
                );
              default:
                return const RefreshableStateBox(child: SizedBox.shrink());
            }
          },
        ),
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
                color: theme.colorScheme.primaryFixed,
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
    final muted = isDark ? AppColors.taupe : AppColors.burgundy;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.onTertiaryFixed.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: theme.colorScheme.onTertiaryFixed.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32.r,
                height: 32.r,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onTertiaryFixed.withValues(
                    alpha: 0.1,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: theme.colorScheme.onTertiaryFixed,
                  size: 18.r,
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.onTertiaryFixed,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          address.displayAddress.isEmpty
              ? Text('---')
              : _AddressDetailGrid(
                  rows: [
                    _AddressDetail(
                      l10n.associationLinkGovernorate,
                      _dash(address.capital),
                    ),
                    _AddressDetail(l10n.profileCity, _dash(address.city)),
                    _AddressDetail(
                      l10n.associationLinkTown,
                      _dash(address.town),
                    ),
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

enum _ProfileMenuAction { editProfile }
