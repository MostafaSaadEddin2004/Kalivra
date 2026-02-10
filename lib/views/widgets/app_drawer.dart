import 'package:flutter/material.dart';
import 'package:kalivra/views/widgets/drawer/drawer_footer.dart';
import 'package:kalivra/views/widgets/drawer/drawer_header.dart';
import 'package:kalivra/views/widgets/drawer/drawer_item.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  static bool get isLoggedIn => false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: theme.colorScheme.secondaryFixed,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomDrawerHeader(onClose: () => Navigator.pop(context)),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerItem(
                    icon: Icons.person_outline_rounded,
                    label: 'حسابي',
                    onTap: () => Navigator.pop(context),
                  ),
                  DrawerItem(
                    icon: Icons.receipt_long_outlined,
                    label: 'طلباتي',
                    onTap: () => Navigator.pop(context),
                  ),
                  DrawerItem(
                    icon: Icons.favorite_border_rounded,
                    label: 'المفضلة',
                    onTap: () => Navigator.pop(context),
                  ),
                  DrawerItem(
                    icon: Icons.settings_outlined,
                    label: 'الإعدادات',
                    onTap: () => Navigator.pop(context),
                  ),
                  DrawerItem(
                    icon: Icons.phone_outlined,
                    label: 'تواصل معنا',
                    onTap: () => Navigator.pop(context),
                  ),
                  DrawerItem(
                    icon: Icons.info_outline_rounded,
                    label: 'حول التطبيق',
                    onTap: () => Navigator.pop(context),
                  ),
                  DrawerItem(
                    icon: Icons.privacy_tip_outlined,
                    label: 'سياسة الخصوصية',
                    onTap: () => Navigator.pop(context),
                  ),
                  DrawerItem(
                    icon: Icons.share_rounded,
                    label: 'مشاركة',
                    onTap: () => Navigator.pop(context),
                  ),
                  DrawerItem(
                    icon: Icons.star_rounded,
                    label: 'تقييم',
                    onTap: () => Navigator.pop(context),
                  ),
                  DrawerItem(
                    icon: isLoggedIn
                        ? Icons.logout_rounded
                        : Icons.login_rounded,
                    label: isLoggedIn ? 'تسجيل خروج' : 'تسجيل دخول',
                    onTap: () => Navigator.pop(context),
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
