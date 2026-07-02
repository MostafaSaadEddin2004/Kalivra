import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
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
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          await showDialog<bool>(
            context: context,
            builder: (_) => ConfirmDialog(
              title: l10n.exitAppTitle,
              message: l10n.exitAppConfirmation,
              onConfirm: () {
                Navigator.pop(context, true);
                SystemNavigator.pop();
              },
            ),
          );
        }
        context.pop();
      },
      child: child,
    );
  }
}
