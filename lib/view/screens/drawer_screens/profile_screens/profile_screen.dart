import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/controller/blocs/cubit/auth_cubit/auth_cubit.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/view/widgets/drawer/drawer_screen_app_bar.dart';
import 'package:kalivra/view/widgets/profile/referral_qr_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final authCubit = context.read<AuthCubit>();
      authCubit
      .loadProfile(context  );});
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final isDark = theme.brightness == Brightness.dark;
    final labelColor = isDark ? AppColors.taupe : AppColors.burgundy;

    return Scaffold(
      appBar: DrawerScreenAppBar(
        title: l10n.myAccount,
        actions: [
          PopupMenuButton<_ProfileMenuAction>(
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
                          child: Icon(
                            Icons.person_rounded,
                            size: 56.r,
                            color: isDark
                                ? AppColors.goldLight
                                : AppColors.burgundy,
                          ),
                        ),
                        SizedBox(height: 12.h),
                      ],
                    ),
                  ),
                  ReferralCard(
                    referralCode: state.customer.referralCode ?? 'KHDD-5DKD9',
                  ),
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
                        value: customer.whatsappNumber ?? '---',
                        icon: Icons.phone_android_rounded,
                      ),
                      _InfoRow(
                        label: l10n.whatsappNumber,
                        value: customer.phone ?? '---',
                        icon: Icons.call,
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  _SectionCard(
                    title: l10n.userLocationInfo,
                    children: [
                      _InfoRow(
                        label: l10n.associationLinkGovernorate,
                        value: addressInfo?.officialGovernorate ?? '---',
                        icon: Icons.email_outlined,
                      ),
                      _InfoRow(
                        label: l10n.profileCity,
                        value: addressInfo?.officialCity ?? '---',
                        icon: Icons.phone_android_rounded,
                      ),
                      _InfoRow(
                        label: l10n.associationLinkTown,
                        value: addressInfo?.officialTown ?? '---',
                        icon: Icons.call,
                      ),
                      _InfoRow(
                        label: l10n.associationLinkVillage,
                        value:
                            addressInfo?.officialMunicipalityVillage ?? '---',
                        icon: Icons.call,
                      ),
                      _InfoRow(
                        label: l10n.associationLinkStreet,
                        value: addressInfo?.officialStreet ?? '---',
                        icon: Icons.phone_android_rounded,
                      ),
                      _InfoRow(
                        label: l10n.associationLinkBuilding,
                        value: addressInfo?.officialBuilding ?? '---',
                        icon: Icons.call,
                      ),
                      _InfoRow(
                        label: l10n.associationLinkPermanentAddress,
                        value: addressInfo?.permanentAddress ?? '---',
                        icon: Icons.call,
                      ),
                    ],
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

class _ReferralCardCollapsed extends StatelessWidget {
  const _ReferralCardCollapsed({
    required this.primary,
    required this.isDark,
    required this.theme,
  });

  final Color primary;
  final bool isDark;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
        side: BorderSide(color: primary.withValues(alpha: 0.25), width: 1.5),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            Flexible(
              child: Column(
                spacing: 8.h,
                children: [
                  Row(
                    spacing: 8.w,
                    children: [
                      Icon(Icons.qr_code_2_rounded, size: 24.r, color: primary),
                      Text(
                        AppLocalizations.of(context)!.referralCode,
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: isDark ? AppColors.offWhite : AppColors.black,
                          fontWeight: FontWeight.w800,
                        ),
                        softWrap: true,
                      ),
                    ],
                  ),
                  Text(
                    AppLocalizations.of(context)!.referralCodeHint,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark ? AppColors.taupe : AppColors.burgundy,
                      height: 1.35,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(Icons.expand_more_rounded, size: 28.r, color: primary),
          ],
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

enum _ProfileMenuAction { editProfile, associationMemberProfile }

class ReferralCard extends StatefulWidget {
  const ReferralCard({super.key, required this.referralCode});
  final String referralCode;

  @override
  State<ReferralCard> createState() => _ReferralCardState();
}

bool _referralCardExpanded = false;

class _ReferralCardState extends State<ReferralCard> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primary = theme.colorScheme.primary;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () =>
            setState(() => _referralCardExpanded = !_referralCardExpanded),
        borderRadius: BorderRadius.circular(20.r),
        child: AnimatedCrossFade(
          firstChild: _ReferralCardCollapsed(
            primary: primary,
            isDark: isDark,
            theme: theme,
          ),
          secondChild: ReferralQrCard(referralCode: widget.referralCode),
          crossFadeState: _referralCardExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 280),
          firstCurve: Curves.decelerate,
          secondCurve: Curves.easeInOut,
          sizeCurve: Curves.easeInOut,
        ),
      ),
    );
  }
}
