import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/view/widgets/confirm_dialog.dart';

class PopScopeExitApp extends StatelessWidget {
  const PopScopeExitApp({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async{
        if (didPop) return;
        final shouldExit = await showDialog<bool>(
          context: context,
          builder: (_) => ConfirmDialog(
            title: l10n.exitAppTitle,
            message: l10n.exitAppConfirmation,
            onConfirm: () {
              Navigator.pop(context, true);
            },
          ),
        );
        if (shouldExit == true) {
          SystemNavigator.pop();
        }
      },
      child: child,
    );
  }
}
