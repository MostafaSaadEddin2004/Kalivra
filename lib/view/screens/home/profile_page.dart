import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/controller/blocs/cubit/auth_cubit/auth_cubit.dart';
import 'package:kalivra/controller/blocs/cubit/middleware_cubit/middleware_cubit.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/model/customer/customer_api_model.dart';
import 'package:kalivra/view/widgets/cards/custom_network_image.dart';
import 'package:kalivra/view/widgets/profile/referral_qr_card.dart';
import 'package:kalivra/view/widgets/profile_page/profile_page_footer.dart';
import 'package:kalivra/view/widgets/profile_page/profile_page_item.dart';
import 'package:share_plus/share_plus.dart';

const String kalivraShareUrl = 'https://kalivra.com';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final AuthCubit _authCubit;

  @override
  void initState() {
    super.initState();
    _authCubit = AuthCubit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _authCubit.loadProfile(context);
    });
  }

  @override
  void dispose() {
    _authCubit.close();
    super.dispose();
  }

  Future<ShareResult> _shareApp(BuildContext context) async {
    return SharePlus.instance.share(
      ShareParams(text: kalivraShareUrl, subject: 'Kalivra'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<AuthCubit, AuthState>(
      bloc: _authCubit,
      builder: (context, state) {
        final customer = state is AuthFetchedData ? state.customer : null;
        final isLoggedIn = customer != null;

        return ListView(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 90.h),
          children: [
            if (isLoggedIn) ...[
              _ProfileHeroCard(customer: customer),
              SizedBox(height: 24.h),
              _ProfileSectionTitle(title: l10n.profileSectionAccountOrders),
              SizedBox(height: 8.h),
              if (customer.isLinkedPerson != null ||
                  customer.isLinkedPerson == true)
                ProfilePageItem(
                  icon: Icons.person,
                  label: l10n.myAccount,
                  subtitle: l10n.accountInfo,
                  onTap: () => context.push(AppRoutes.account),
                ),
              ProfilePageItem(
                icon: Icons.groups_rounded,
                label: l10n.associationPersonalProfileButton,
                subtitle: l10n.profileAssociationProfileSubtitle,
                onTap: () => context.push(AppRoutes.associationMemberProfile),
              ),
              ProfilePageItem(
                icon: Icons.receipt_long_outlined,
                label: l10n.drawerMyOrders,
                subtitle: l10n.profileOrdersSubtitle,
                onTap: () => context.push(AppRoutes.orders),
              ),
              ProfilePageItem(
                icon: Icons.favorite_border_rounded,
                label: l10n.drawerFavorites,
                subtitle: l10n.profileFavoritesSubtitle,
                onTap: () => context.push(AppRoutes.favorites),
              ),
            ],
            SizedBox(height: 24.h),
            _ProfileSectionTitle(title: l10n.profileSectionSettingsSupport),
            SizedBox(height: 8.h),
            ProfilePageItem(
              icon: Icons.settings_outlined,
              label: l10n.drawerSettings,
              subtitle: l10n.profileSettingsSubtitle,
              onTap: () => context.push(AppRoutes.settings),
            ),
            ProfilePageItem(
              icon: Icons.phone_outlined,
              label: l10n.drawerContactUs,
              subtitle: l10n.profileContactSubtitle,
              onTap: () => context.push(AppRoutes.contact),
            ),
            ProfilePageItem(
              icon: Icons.info_outline_rounded,
              label: l10n.drawerAboutApp,
              subtitle: l10n.profileAboutSubtitle,
              onTap: () => context.push(AppRoutes.about),
            ),
            ProfilePageItem(
              icon: Icons.privacy_tip_outlined,
              label: l10n.drawerPrivacyPolicy,
              subtitle: l10n.profilePrivacySubtitle,
              onTap: () => context.push(AppRoutes.privacyPolicy),
            ),
            ProfilePageItem(
              icon: Icons.quiz_outlined,
              label: l10n.drawerTermsConditions,
              subtitle: l10n.profileTermsSubtitle,
              onTap: () => context.push(AppRoutes.termsConditions),
            ),
            ProfilePageItem(
              icon: Icons.help_outline_rounded,
              label: l10n.frequentlyAskedQuestion,
              subtitle: l10n.profileFaqSubtitle,
              onTap: () => context.push(AppRoutes.kalivraFaq),
            ),
            if (isLoggedIn)
              ProfilePageItem(
                icon: Icons.star_rounded,
                label: l10n.rateTitle,
                subtitle: l10n.rateSubTitle,
                onTap: () => context.push(AppRoutes.rate),
              ),
            SizedBox(height: 8.h),
            Expanded(
              child: ProfilePageItem(
                icon: Icons.share_rounded,
                label: l10n.profileShareApp,
                variant: ProfilePageItemVariant.regular,
                onTap: () => _shareApp(context),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: BlocBuilder<MiddlewareCubit, MiddlewareState>(
                bloc: MiddlewareCubit()..getLoinOrLogoutButton(context),
                builder: (context, state) {
                  switch (state) {
                    case LogOutButton():
                      return state.button;
                    case LoginButton():
                      return state.button;
                    default:
                      return const SizedBox.shrink();
                  }
                },
              ),
            ),
            const ProfilePageFooter(),
          ],
        );
      },
    );
  }
}

class _ProfileHeroCard extends StatelessWidget {
  const _ProfileHeroCard({required this.customer});

  final CustomerApiModel? customer;

  String _displayName(AppLocalizations l10n) {
    final name = customer?.name?.trim();
    if (name != null && name.isNotEmpty) return name;

    final firstName = customer?.firstName?.trim();
    final lastName = customer?.lastName?.trim();
    final fullName = [
      if (firstName != null && firstName.isNotEmpty) firstName,
      if (lastName != null && lastName.isNotEmpty) lastName,
    ].join(' ');

    return fullName.isNotEmpty ? fullName : l10n.profileGuestName;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final imageUrl = customer?.displayImageUrl;
    final referralCode = customer?.referralCode?.trim();

    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: AppColors.burgundy,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.16),
            blurRadius: 16.r,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              ClipOval(
                child: Container(
                  width: 74.r,
                  height: 74.r,
                  color: AppColors.offWhite,
                  child: CustomNetworkImage(
                    imageUrl: imageUrl,
                    width: 74.r,
                    height: 74.r,
                    defaultIcon: Icons.person_rounded,
                    defaultIconColor: AppColors.burgundy,
                  ),
                ),
              ),
              PositionedDirectional(
                end: -2.w,
                bottom: -2.h,
                child: InkWell(
                  child: Container(
                    height: 28.h,
                    width: 28.w,
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: AppColors.taupe,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.burgundy,
                        width: 1.5.w,
                      ),
                    ),
                    child: Icon(
                      Icons.edit_rounded,
                      color: AppColors.burgundy,
                      size: 16.r,
                    ),
                  ),
                  onTap: () =>
                      context.push(AppRoutes.editProfile, extra: customer),
                ),
              ),
            ],
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              spacing: 8.h,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _displayName(l10n),
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: AppColors.offWhite,
                    fontWeight: FontWeight.w800,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (customer!.gender != null) ...[
                  Row(
                    spacing: 4.w,
                    children: [
                      Icon(
                        Icons.person,
                        color: theme.colorScheme.secondaryFixed,
                      ),
                      Text(
                        customer!.gender!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.offWhite,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          if (referralCode != null && referralCode.isNotEmpty) ...[
            SizedBox(width: 8.w),
            InkWell(
              onTap: () =>
                  showReferralQrDialog(context, referralCode: referralCode),
              borderRadius: BorderRadius.circular(12.r),
              child: Padding(
                padding: EdgeInsets.all(8.w),
                child: Icon(
                  Icons.qr_code_2_rounded,
                  color: theme.colorScheme.secondaryFixed,
                  size: 24.r,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ProfileSectionTitle extends StatelessWidget {
  const _ProfileSectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Theme.of(context).colorScheme.primaryFixed,
          fontWeight: FontWeight.w800,
        ),
        textAlign: TextAlign.start,
      ),
    );
  }
}
