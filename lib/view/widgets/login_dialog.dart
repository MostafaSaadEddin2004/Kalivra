import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/l10n/app_localizations.dart';

class GoToLoginDialog extends StatelessWidget {
  const GoToLoginDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(l10n.login, style: theme.textTheme.titleLarge),
      content: Text(
        l10n.areYouSureYouWantToSignIn,
        style: theme.textTheme.bodyMedium,
      ),
      actions: [
        TextButton(onPressed: () => context.pop(), child: Text(l10n.no)),
        FilledButton(
          onPressed: () => context.go(AppRoutes.login),
          child: Text(l10n.login),
        ),
      ],
      actionsPadding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 16.h),
    );
  }
}
