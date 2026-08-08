import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/l10n/app_localizations.dart';

class ConfirmDialog extends StatefulWidget {
  const ConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    required this.onConfirm,
    this.isLoading = false,
  });

  final String title;
  final String message;
  final FutureOr<void> Function() onConfirm;
  final bool isLoading;

  @override
  State<ConfirmDialog> createState() => _ConfirmDialogState();
}

class _ConfirmDialogState extends State<ConfirmDialog> {
  bool _isConfirming = false;
  bool _isDisposed = false;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  Future<void> _confirm() async {
    if (_isConfirming || widget.isLoading) return;
    setState(() => _isConfirming = true);
    try {
      await Future<void>.sync(widget.onConfirm);
    } finally {
      if (!_isDisposed) {
        setState(() => _isConfirming = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isLoading = widget.isLoading || _isConfirming;

    return AlertDialog(
      title: Text(widget.title, style: theme.textTheme.titleLarge),
      content: Text(
        widget.message,
        style: theme.textTheme.bodyMedium!.copyWith(color: AppColors.black),
      ),
      actions: [
        TextButton(
          onPressed: isLoading ? null : () => context.pop(),
          child: Text(l10n.no),
        ),
        Container(
          constraints: BoxConstraints(maxWidth: 80.w),
          child: FilledButton(
            onPressed: isLoading ? null : _confirm,
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
