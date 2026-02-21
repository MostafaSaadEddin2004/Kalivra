import 'package:flutter/material.dart';
import 'package:kalivra/core/network/app_interceptor.dart';
import 'package:kalivra/l10n/app_localizations.dart';

/// Shows API errors via SnackBar or Dialog.
class ApiErrorHandler {
  ApiErrorHandler._();

  /// Show error as SnackBar. Use for non-critical failures (e.g. load list failed).
  static void showSnackBar(BuildContext context, dynamic error, {String? fallbackMessage}) {
    if (!context.mounted) return;
    final message = _message(context, error, fallback: fallbackMessage);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Show error in a dialog. Use for critical failures (e.g. checkout failed).
  static Future<void> showErrorDialog(BuildContext context, dynamic error, {String? fallbackMessage}) async {
    if (!context.mounted) return;
    final message = _message(context, error, fallback: fallbackMessage);
    return showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.error),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(AppLocalizations.of(context)!.ok),
          ),
        ],
      ),
    );
  }

  static String _message(BuildContext context, dynamic error, {String? fallback}) {
    if (error is ApiException) return error.message;
    if (error is Exception) return error.toString();
    return fallback ?? AppLocalizations.of(context)!.unexpectedError;
  }
}
