import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/controller/blocs/cubit/middleware_cubit/middleware_cubit.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/view/widgets/drawer/drawer_footer.dart';
import 'package:kalivra/view/widgets/drawer/drawer_header.dart';
import 'package:kalivra/view/widgets/drawer/drawer_item.dart';
import 'package:share_plus/share_plus.dart';

const String kalivraShareUrl = 'https://kalivra.com';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  Future<ShareResult> _shareApp(BuildContext context) async {
    return SharePlus.instance.share(
      ShareParams(text: kalivraShareUrl, subject: 'Kalivra'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.colorScheme.secondaryFixed,
      child: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomDrawerHeader(onClose: () => context.pop(context)),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerItem(
                    icon: Icons.person_outline_rounded,
                    label: AppLocalizations.of(context)!.drawerMyAccount,
                    onTap: () =>
                        AppRouter.openScreenWithPop(context, AppRoutes.account),
                  ),
                  DrawerItem(
                    icon: Icons.receipt_long_outlined,
                    label: AppLocalizations.of(context)!.drawerMyOrders,
                    onTap: () =>
                        AppRouter.openScreenWithPop(context, AppRoutes.orders),
                  ),
                  DrawerItem(
                    icon: Icons.favorite_border_rounded,
                    label: AppLocalizations.of(context)!.drawerFavorites,
                    onTap: () => AppRouter.openScreenWithPop(
                      context,
                      AppRoutes.favorites,
                    ),
                  ),
                  DrawerItem(
                    icon: Icons.settings_outlined,
                    label: AppLocalizations.of(context)!.drawerSettings,
                    onTap: () => AppRouter.openScreenWithPop(
                      context,
                      AppRoutes.settings,
                    ),
                  ),
                  DrawerItem(
                    icon: Icons.phone_outlined,
                    label: AppLocalizations.of(context)!.drawerContactUs,
                    onTap: () =>
                        AppRouter.openScreenWithPop(context, AppRoutes.contact),
                  ),
                  DrawerItem(
                    icon: Icons.info_outline_rounded,
                    label: AppLocalizations.of(context)!.drawerAboutApp,
                    onTap: () =>
                        AppRouter.openScreenWithPop(context, AppRoutes.about),
                  ),
                  DrawerItem(
                    icon: Icons.privacy_tip_outlined,
                    label: AppLocalizations.of(context)!.drawerPrivacyPolicy,
                    onTap: () =>
                        AppRouter.openScreenWithPop(context, AppRoutes.privacy),
                  ),
                  DrawerItem(
                    icon: Icons.share_rounded,
                    label: AppLocalizations.of(context)!.drawerShare,
                    onTap: () => _shareApp(context),
                  ),
                  DrawerItem(
                    icon: Icons.star_rounded,
                    label: AppLocalizations.of(context)!.rateTitle,
                    onTap: () =>
                        AppRouter.openScreenWithPop(context, AppRoutes.rate),
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
                  const DrawerFooter(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
