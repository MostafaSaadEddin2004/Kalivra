import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/views/widgets/drawer/drawer_footer.dart';
import 'package:kalivra/views/widgets/drawer/drawer_header.dart';
import 'package:kalivra/views/widgets/drawer/drawer_item.dart';
import 'package:share_plus/share_plus.dart';

/// Kalivra URL shared when user taps "مشاركة".
const String kalivraShareUrl = 'https://kalivra.com';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  void _openScreen(BuildContext context, String path) {
    context.push(path);
  }

  Future<void> _shareApp(BuildContext context) {
    return Share.share(
      kalivraShareUrl,
      subject: 'Kalivra',
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final statusBarBrightness =
        ThemeData.estimateBrightnessForColor(primary) == Brightness.dark
            ? Brightness.light
            : Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: primary,
        statusBarIconBrightness: statusBarBrightness,
        statusBarBrightness: statusBarBrightness,
      ),
      child: Container(
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
                    onTap: () => _shareApp(context),
                  ),
                  DrawerItem(
                    icon: Icons.star_rounded,
                    label: 'تقييم',
                    onTap: () => _openScreen(context, AppRoutes.rate),
                  ),
                  const DrawerFooter(),
                ],
              ),
            ),
            ],
          ),
        ),
      ),
    );
  }
}
