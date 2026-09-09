import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/model/association/association_request_summary.dart';
import 'package:kalivra/view/widgets/files/network_file_action_tile.dart';
import 'package:kalivra/view/widgets/profile_page/screen_app_bar.dart';

class AssociationRequestDetailsScreen extends StatelessWidget {
  const AssociationRequestDetailsScreen({super.key, required this.request});

  final AssociationRequestSummary request;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: ScreenAppBar(title: l10n.associationRequestDetailsTitle),
      body: ListView(
        padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
        children: [
          _RequestSummaryPanel(request: request),
          SizedBox(height: 14.h),
          _DetailsPanel(
            children: [
              _DetailRow(
                icon: Icons.confirmation_number_outlined,
                label: l10n.associationRequestNumber,
                value: request.displayNumber,
              ),
              _DetailRow(
                icon: Icons.label_outline_rounded,
                label: l10n.associationRequestType,
                value: _textOrFallback(context, request.displayType),
              ),
              _DetailRow(
                icon: Icons.info_outline_rounded,
                label: l10n.associationRequestStatus,
                value: _statusLabel(context, request),
              ),
              _DetailRow(
                icon: Icons.sticky_note_2_outlined,
                label: l10n.associationRequestCustomerNote,
                value: _textOrFallback(context, request.customerNote),
              ),
              _DetailRow(
                icon: Icons.mark_chat_read_outlined,
                label: l10n.associationRequestReplyMessage,
                value: _textOrFallback(context, request.effectiveReplyMessage),
              ),
              _DetailRow(
                icon: Icons.schedule_outlined,
                label: l10n.associationRequestReplyAt,
                value: _dateTimeLabel(context, request.effectiveReplyAt),
              ),
              _DetailRow(
                icon: Icons.calendar_today_outlined,
                label: l10n.associationRequestCreatedAt,
                value: _dateTimeLabel(context, request.createdAt),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          _DocumentsPanel(request: request),
        ],
      ),
    );
  }
}

class _RequestSummaryPanel extends StatelessWidget {
  const _RequestSummaryPanel({required this.request});

  final AssociationRequestSummary request;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.onTertiaryFixed,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46.r,
            height: 46.r,
            decoration: BoxDecoration(
              color: AppColors.offWhite.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(
              _statusIcon(request),
              color: AppColors.offWhite,
              size: 24.r,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  request.displayNumber,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.offWhite,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  _textOrFallback(context, request.displayType),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.offWhite.withValues(alpha: 0.88),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 10.h),
                _StatusChip(request: request),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailsPanel extends StatelessWidget {
  const _DetailsPanel({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.onTertiaryFixed.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(children: children),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34.r,
            height: 34.r,
            decoration: BoxDecoration(
              color: theme.colorScheme.onTertiaryFixed.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              icon,
              size: 18.r,
              color: theme.colorScheme.onTertiaryFixed,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onTertiaryFixed,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DocumentsPanel extends StatelessWidget {
  const _DocumentsPanel({required this.request});

  final AssociationRequestSummary request;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final documentUrl = request.documentUrl?.trim();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.associationRequestDocuments,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 10.h),
            if (request.documents.isEmpty &&
                (documentUrl == null || documentUrl.isEmpty))
              Text(
                l10n.associationRequestNoDocuments,
                style: theme.textTheme.bodyMedium,
              )
            else ...[
              ...request.documents.map(
                (document) => NetworkFileActionTile(
                  name: document.displayName,
                  url: document.fileUrl,
                  subtitle: document.definition?.displayName,
                  icon: Icons.description_outlined,
                  openDirectly: true,
                ),
              ),
              if (request.documents.isEmpty && documentUrl?.isNotEmpty == true)
                NetworkFileActionTile(
                  name:
                      request.documentDefinition ??
                      l10n.associationRequestViewDocument,
                  url: documentUrl,
                  icon: Icons.description_outlined,
                  openDirectly: true,
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.request});

  final AssociationRequestSummary request;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _statusColor(context, request);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        _statusLabel(context, request),
        style: theme.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

IconData _statusIcon(AssociationRequestSummary request) {
  if (request.isApproved) return Icons.check_circle_outline_rounded;
  if (request.isRejected) return Icons.cancel_outlined;
  return Icons.hourglass_empty_rounded;
}

Color _statusColor(BuildContext context, AssociationRequestSummary request) {
  if (request.isApproved) return Colors.green;
  if (request.isRejected) return Theme.of(context).colorScheme.onError;
  return AppColors.goldDark;
}

String _statusLabel(BuildContext context, AssociationRequestSummary request) {
  final l10n = AppLocalizations.of(context)!;
  if (request.isApproved) return l10n.associationRequestStatusApproved;
  if (request.isRejected) return l10n.associationRequestStatusRejected;
  if (request.isPending) return l10n.associationRequestStatusPending;
  return request.status.trim().isNotEmpty
      ? request.status
      : l10n.associationMemberNoData;
}

String _textOrFallback(BuildContext context, String? value) {
  final text = value?.trim();
  if (text?.isNotEmpty == true) return text!;
  return AppLocalizations.of(context)!.associationMemberNoData;
}

String _dateTimeLabel(BuildContext context, DateTime? date) {
  final l10n = AppLocalizations.of(context)!;
  if (date == null) return l10n.associationMemberNoData;
  return DateFormat.yMMMd().add_jm().format(date.toLocal());
}
