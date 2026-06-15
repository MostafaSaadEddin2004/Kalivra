import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/l10n/app_localizations.dart';

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    required this.onConfirm,
    this.isLoading = false,
  });

  final String title;
  final String message;
  final VoidCallback onConfirm;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(title, style: theme.textTheme.titleLarge),
      content: Text(message, style: theme.textTheme.bodyMedium),
      actions: [
        TextButton(onPressed: () => context.pop(), child: Text(l10n.no)),
        Container(
        constraints: BoxConstraints(maxWidth: 80.w),
          child: FilledButton(
            onPressed: onConfirm,
            child: isLoading
                ? SpinKitFadingCircle(color: AppColors.offWhite, size: 20.r)
                : Text(l10n.yes),
          ),
        ),
      ],
      actionsPadding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 16.h),
    );
  }
}
