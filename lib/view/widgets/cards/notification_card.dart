import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/l10n/app_localizations.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    super.key,
    required this.title,
    required this.body,
    required this.time,
    required this.icon,
    required this.typeLabel,
    required this.priorityLabel,
    required this.statusLabel,
    this.isRead = false,
    this.isMandatory = false,
    this.onTap,
  });

  final String title;
  final String body;
  final String time;
  final IconData icon;
  final String typeLabel;
  final String priorityLabel;
  final String statusLabel;
  final bool isRead;
  final bool isMandatory;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        leading: Container(
          padding: EdgeInsets.all(10.r),
          decoration: BoxDecoration(
            color: colorScheme.onSecondaryFixed,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(icon, color: colorScheme.primary, size: 24.r),
        ),
        title: Text(
          title,
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: Padding(
          padding: EdgeInsets.only(top: 4.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 6.w,
                runSpacing: 4.h,
                children: [
                  if (typeLabel.isNotEmpty)
                    _NotificationMetaChip(label: typeLabel),
                  _NotificationMetaChip(label: priorityLabel),
                  _NotificationMetaChip(label: statusLabel),
                  _NotificationReadStatusChip(
                    label: isRead
                        ? l10n.notificationRead
                        : l10n.notificationUnread,
                    isRead: isRead,
                  ),
                  if (isMandatory)
                    _NotificationMetaChip(label: l10n.notificationMandatory),
                ],
              ),
              SizedBox(height: 6.h),
              Text(
                body,
                style: Theme.of(context).textTheme.bodySmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        trailing: Text(time, style: Theme.of(context).textTheme.labelSmall),
        onTap: onTap,
      ),
    );
  }
}

class _NotificationReadStatusChip extends StatelessWidget {
  const _NotificationReadStatusChip({
    required this.label,
    required this.isRead,
  });

  final String label;
  final bool isRead;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isRead
        ? Colors.green.withValues(alpha: 0.14)
        : Colors.orange.withValues(alpha: 0.16);
    final foregroundColor = isRead
        ? Colors.green.shade700
        : Colors.orange.shade800;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: foregroundColor,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _NotificationMetaChip extends StatelessWidget {
  const _NotificationMetaChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: colorScheme.onSecondaryFixed,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
