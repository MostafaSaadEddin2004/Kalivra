import 'package:flutter/material.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/view/screens/home/notifications_page.dart';
import 'package:kalivra/view/widgets/profile_page/screen_app_bar.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ScreenAppBar(
        title: AppLocalizations.of(context)!.navNotifications,
      ),
      body: const NotificationsPage(),
    );
  }
}
