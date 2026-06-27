import 'package:flutter/material.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/view/screens/home/notifications_page.dart';
import 'package:kalivra/view/widgets/drawer/drawer_screen_app_bar.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DrawerScreenAppBar(
        title: AppLocalizations.of(context)!.navNotifications,
      ),
      body: const NotificationsPage(),
    );
  }
}
