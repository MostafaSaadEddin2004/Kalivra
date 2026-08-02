import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/controller/blocs/cubit/auth_cubit/auth_cubit.dart';
import 'package:kalivra/controller/blocs/cubit/middleware_cubit/middleware_cubit.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/view/widgets/profile_page/profile_page_footer.dart';
import 'package:kalivra/view/widgets/profile_page/profile_page_item.dart';
import 'package:share_plus/share_plus.dart';

const String kalivraShareUrl = 'https://kalivra.com';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<ShareResult> _shareApp(BuildContext context) async {
    return SharePlus.instance.share(
      ShareParams(text: kalivraShareUrl, subject: 'Kalivra'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16.w),
      children: [
        BlocBuilder<AuthCubit, AuthState>(
          bloc: AuthCubit()..loadProfile(context),
          builder: (context, state) {
            switch (state) {
              case UnAuthinticated():
                return const SizedBox.shrink();
              case AuthFetchedData():
                return Column(
                  children: [
                    ProfilePageItem(
                      icon: Icons.person_outline_rounded,
                      label: AppLocalizations.of(context)!.drawerMyAccount,
                      onTap: () => context.push(AppRoutes.account),
                    ),
                    state.customer.isLinkedPerson != null ||
                            state.customer.isLinkedPerson == true
                        ? ProfilePageItem(
                            icon: Icons.groups_rounded,
                            label: AppLocalizations.of(
                              context,
                            )!.associationPersonalProfileButton,
                            onTap: () => context.push(
                              AppRoutes.associationMemberProfile,
                            ),
                          )
                        : const SizedBox.shrink(),
                    ProfilePageItem(
                      icon: Icons.receipt_long_outlined,
                      label: AppLocalizations.of(context)!.drawerMyOrders,
                      onTap: () => context.push(AppRoutes.orders),
                    ),
                    ProfilePageItem(
                      icon: Icons.favorite_border_rounded,
                      label: AppLocalizations.of(context)!.drawerFavorites,
                      onTap: () => context.push(AppRoutes.favorites),
                    ),
                  ],
                );
              default:
                return const SizedBox.shrink();
            }
          },
        ),
        ProfilePageItem(
          icon: Icons.settings_outlined,
          label: AppLocalizations.of(context)!.drawerSettings,
          onTap: () => context.push(AppRoutes.settings),
        ),
        ProfilePageItem(
          icon: Icons.phone_outlined,
          label: AppLocalizations.of(context)!.drawerContactUs,
          onTap: () => context.push(AppRoutes.contact),
        ),
        ProfilePageItem(
          icon: Icons.info_outline_rounded,
          label: AppLocalizations.of(context)!.drawerAboutApp,
          onTap: () => context.push(AppRoutes.about),
        ),
        ProfilePageItem(
          icon: Icons.privacy_tip_outlined,
          label: AppLocalizations.of(context)!.drawerPrivacyPolicy,
          onTap: () => context.push(AppRoutes.privacyPolicy),
        ),
        ProfilePageItem(
          icon: Icons.quiz_outlined,
          label: AppLocalizations.of(context)!.drawerTermsConditions,
          onTap: () => context.push(AppRoutes.termsConditions),
        ),
        ProfilePageItem(
          icon: Icons.help_outline_rounded,
          label: AppLocalizations.of(context)!.frequentlyAskedQuestion,
          onTap: () => context.push(AppRoutes.kalivraFaq),
        ),
        ProfilePageItem(
          icon: Icons.share_rounded,
          label: AppLocalizations.of(context)!.drawerShare,
          onTap: () => _shareApp(context),
        ),
        BlocBuilder<AuthCubit, AuthState>(
          bloc: AuthCubit()..loadProfile(context),
          builder: (context, state) {
            switch (state) {
              case UnAuthinticated():
                return const SizedBox.shrink();
              default:
                return ProfilePageItem(
                  icon: Icons.star_rounded,
                  label: AppLocalizations.of(context)!.rateTitle,
                  onTap: () => context.push(AppRoutes.rate),
                );
            }
          },
        ),
        BlocBuilder<MiddlewareCubit, MiddlewareState>(
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
        const ProfilePageFooter(),
        SizedBox(height: 80.h),
      ],
    );
  }
}
