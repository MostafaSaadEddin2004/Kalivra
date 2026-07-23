import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:kalivra/controller/blocs/cubit/assoiciation_link_cubit/association_link_cubit.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/model/association/association_announcement_model.dart';
import 'package:kalivra/view/widgets/empty_state_view.dart';
import 'package:kalivra/view/widgets/files/network_file_action_tile.dart';
import 'package:kalivra/view/widgets/profile_page/screen_app_bar.dart';

class AssociationAnnouncementDetailsScreen extends StatefulWidget {
  const AssociationAnnouncementDetailsScreen({
    super.key,
    required this.announcementId,
    this.initialAnnouncement,
  });

  final int announcementId;
  final AssociationAnnouncementModel? initialAnnouncement;

  @override
  State<AssociationAnnouncementDetailsScreen> createState() =>
      _AssociationAnnouncementDetailsScreenState();
}

class _AssociationAnnouncementDetailsScreenState
    extends State<AssociationAnnouncementDetailsScreen> {
  late final AssociationLinkCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = AssociationLinkCubit()..fetchAnnouncement(widget.announcementId);
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: ScreenAppBar(title: l10n.associationAnnouncementDetailsTitle),
      body: BlocBuilder<AssociationLinkCubit, AssociationLinkState>(
        bloc: _cubit,
        builder: (context, state) {
          if (state is AssociationAnnouncementDetailsFetched) {
            return _AnnouncementDetailsBody(announcement: state.announcement);
          }

          if (state is AssociationLinkFailure) {
            final fallback = widget.initialAnnouncement;
            if (fallback != null) {
              return _AnnouncementDetailsBody(announcement: fallback);
            }

            return _FailureView(
              message: state.errorMessage,
              onRetry: () => _cubit.fetchAnnouncement(widget.announcementId),
            );
          }

          final fallback = widget.initialAnnouncement;
          if (fallback != null) {
            return Stack(
              children: [
                _AnnouncementDetailsBody(announcement: fallback),
                const Positioned.fill(
                  child: IgnorePointer(
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ),
              ],
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class _AnnouncementDetailsBody extends StatelessWidget {
  const _AnnouncementDetailsBody({required this.announcement});

  final AssociationAnnouncementModel announcement;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final statusColor = announcement.isDelivered
        ? Colors.green
        : AppColors.goldDark;

    return ListView(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
      children: [
        Container(
          padding: EdgeInsets.all(18.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.r),
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: theme.brightness == Brightness.dark
                  ? [
                      AppColors.burgundy.withValues(alpha: 0.9),
                      AppColors.black.withValues(alpha: 0.96),
                    ]
                  : [AppColors.burgundy, AppColors.goldDark],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48.r,
                    height: 48.r,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: Icon(
                      _typeIcon(announcement.type),
                      color: AppColors.offWhite,
                      size: 26.r,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          announcement.title,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: AppColors.offWhite,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Wrap(
                          spacing: 8.w,
                          runSpacing: 8.h,
                          children: [
                            _LightChip(label: announcement.referenceNumber),
                            _LightChip(
                              label: announcement.typeLabel.isNotEmpty
                                  ? announcement.typeLabel
                                  : announcement.type,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 18.h),
              _StatusBanner(
                label: announcement.isDelivered
                    ? l10n.associationAnnouncementDelivered
                    : l10n.associationAnnouncementPending,
                color: statusColor,
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        _DetailsSection(
          children: [
            _DetailRow(
              icon: Icons.confirmation_number_outlined,
              label: l10n.associationAnnouncementReferenceNumber,
              value: announcement.referenceNumber,
            ),
            _DetailRow(
              icon: Icons.calendar_today_outlined,
              label: l10n.associationAnnouncementDate,
              value: _dateLabel(context, announcement.announcementDate),
            ),
            _DetailRow(
              icon: Icons.label_outline_rounded,
              label: l10n.associationAnnouncementType,
              value: announcement.typeLabel.isNotEmpty
                  ? announcement.typeLabel
                  : announcement.type,
            ),
            _DetailRow(
              icon: Icons.category_outlined,
              label: l10n.associationAnnouncementCategory,
              value: announcement.category ?? l10n.associationMemberNoData,
            ),
            _DetailRow(
              icon: Icons.hourglass_bottom_outlined,
              label: l10n.associationAnnouncementDeadline,
              value: _dateLabel(context, announcement.legalDeadline),
            ),
            _DetailRow(
              icon: Icons.mark_email_read_outlined,
              label: l10n.associationAnnouncementDeliveredAt,
              value: _dateTimeLabel(context, announcement.deliveredAt),
            ),
          ],
        ),
        SizedBox(height: 14.h),
        _ContentSection(content: announcement.content),
        SizedBox(height: 14.h),
        _AttachmentsSection(attachments: announcement.attachments),
      ],
    );
  }
}

class _DetailsSection extends StatelessWidget {
  const _DetailsSection({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.taupe.withValues(alpha: 0.12)
            : AppColors.burgundy.withValues(alpha: 0.045),
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
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34.r,
            height: 34.r,
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.taupe.withValues(alpha: 0.14)
                  : AppColors.burgundy.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              icon,
              size: 18.r,
              color: isDark ? AppColors.goldLight : AppColors.burgundy,
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
                    color: isDark ? AppColors.taupe : AppColors.burgundy,
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

class _ContentSection extends StatelessWidget {
  const _ContentSection({required this.content});

  final String? content;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.associationAnnouncementContent,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              content?.trim().isNotEmpty == true
                  ? content!.trim()
                  : l10n.associationMemberNoData,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.55),
            ),
          ],
        ),
      ),
    );
  }
}

class _AttachmentsSection extends StatelessWidget {
  const _AttachmentsSection({required this.attachments});

  final List<AssociationAnnouncementAttachment> attachments;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.associationAnnouncementAttachments,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 10.h),
            if (attachments.isEmpty)
              Text(
                l10n.associationAnnouncementNoAttachments,
                style: theme.textTheme.bodyMedium,
              )
            else
              ...attachments.map(
                (attachment) => NetworkFileActionTile(
                  name: attachment.name,
                  url: attachment.url,
                  icon: Icons.attach_file_rounded,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _StatusBanner extends StatelessWidget {
  const _StatusBanner({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          Container(
            width: 10.r,
            height: 10.r,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          SizedBox(width: 8.w),
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppColors.offWhite,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _LightChip extends StatelessWidget {
  const _LightChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: AppColors.offWhite,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _FailureView extends StatelessWidget {
  const _FailureView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        Expanded(
          child: EmptyStateView(
            icon: Icons.error_outline_rounded,
            title: l10n.associationMemberNoData,
            description: message,
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 24.h),
          child: FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: Text(l10n.retry),
          ),
        ),
      ],
    );
  }
}

IconData _typeIcon(String type) {
  switch (type) {
    case 'payment_notice':
      return Icons.payments_outlined;
    case 'meeting':
      return Icons.groups_2_outlined;
    case 'decision':
      return Icons.gavel_outlined;
    case 'warning':
      return Icons.warning_amber_rounded;
    case 'administrative':
      return Icons.admin_panel_settings_outlined;
    default:
      return Icons.campaign_outlined;
  }
}

String _dateLabel(BuildContext context, DateTime? date) {
  final l10n = AppLocalizations.of(context)!;
  if (date == null) return l10n.associationMemberNoData;
  return DateFormat.yMMMd().format(date.toLocal());
}

String _dateTimeLabel(BuildContext context, DateTime? date) {
  final l10n = AppLocalizations.of(context)!;
  if (date == null) return l10n.associationMemberNoData;
  return DateFormat.yMMMd().add_jm().format(date.toLocal());
}
