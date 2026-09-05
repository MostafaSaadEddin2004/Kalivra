import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptyStateView extends StatelessWidget {
  const EmptyStateView({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.actionLabel,
    this.actionIcon = Icons.refresh_rounded,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String description;
  final String? actionLabel;
  final IconData actionIcon;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final showAction =
        onAction != null && actionLabel != null && actionLabel!.isNotEmpty;

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 72.r,
          color: colorScheme.onTertiaryFixed,
        ),
        SizedBox(height: 18.h),
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            color: colorScheme.primaryFixed,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8.h),
        Text(
          description,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.primaryFixed.withValues(alpha: 0.78),
          ),
          textAlign: TextAlign.center,
        ),
        if (showAction) ...[
          SizedBox(height: 20.h),
          FilledButton.icon(
            onPressed: onAction,
            icon: Icon(actionIcon),
            label: Text(actionLabel!),
          ),
        ],
      ],
    );
  }
}
