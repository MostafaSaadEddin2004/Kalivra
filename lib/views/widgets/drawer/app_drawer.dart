import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/views/widgets/drawer/drawer_footer.dart';
import 'package:kalivra/views/widgets/drawer/drawer_header.dart';
import 'package:kalivra/views/widgets/drawer/drawer_item.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  static bool get isLoggedIn => false;

  void _openScreen(BuildContext context, String path) {
    context.push(path);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.colorScheme.secondaryFixed,
      child: SafeArea(
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
                    label: 'حسابي',
                    onTap: () => _openScreen(context, AppRoutes.account),
                  ),
                  DrawerItem(
                    icon: Icons.receipt_long_outlined,
                    label: 'طلباتي',
                    onTap: () => _openScreen(context, AppRoutes.orders),
                  ),
                  DrawerItem(
                    icon: Icons.favorite_border_rounded,
                    label: 'المفضلة',
                    onTap: () => _openScreen(context, AppRoutes.favorites),
                  ),
                  DrawerItem(
                    icon: Icons.settings_outlined,
                    label: 'الإعدادات',
                    onTap: () => _openScreen(context, AppRoutes.settings),
                  ),
                  DrawerItem(
                    icon: Icons.phone_outlined,
                    label: 'تواصل معنا',
                    onTap: () => _openScreen(context, AppRoutes.contact),
                  ),
                  DrawerItem(
                    icon: Icons.info_outline_rounded,
                    label: 'حول التطبيق',
                    onTap: () => _openScreen(context, AppRoutes.about),
                  ),
                  DrawerItem(
                    icon: Icons.privacy_tip_outlined,
                    label: 'سياسة الخصوصية',
                    onTap: () => _openScreen(context, AppRoutes.privacy),
                  ),
                  DrawerItem(
                    icon: Icons.share_rounded,
                    label: 'مشاركة',
                    onTap: () => _openScreen(context, AppRoutes.share),
                  ),
                  DrawerItem(
                    icon: Icons.star_rounded,
                    label: 'تقييم',
                    onTap: () => _openScreen(context, AppRoutes.rate),
                  ),
                  DrawerItem(
                    icon: isLoggedIn
                        ? Icons.logout_rounded
                        : Icons.login_rounded,
                    label: isLoggedIn ? 'تسجيل خروج' : 'تسجيل دخول',
                    onTap: () => _openScreen(context, AppRoutes.login),
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
