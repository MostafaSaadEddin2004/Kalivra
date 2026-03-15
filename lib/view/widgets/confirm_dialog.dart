import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/l10n/app_localizations.dart';

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({
    super.key,
    required this.title,
    required this.message,
  });

  final String title;
  final String message;

  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String message,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => ConfirmDialog(
        title: title,
        message: message,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(title, style: theme.textTheme.titleLarge),
      content: Text(message, style: theme.textTheme.bodyMedium),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: Text(l10n.no),
        ),
        FilledButton(
          onPressed: () => context.pop(),
          child: Text(l10n.yes),
        ),
      ],
      actionsPadding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 16.h),
    );
  }
}
