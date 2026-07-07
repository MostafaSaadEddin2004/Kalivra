import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/view/widgets/profile_page/screen_app_bar.dart';

class AssociationAnnouncementsScreen extends StatelessWidget {
  const AssociationAnnouncementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final announcements = _Announcement.samples(l10n);
    final deliveredCount = announcements
        .where((item) => item.status == l10n.associationAnnouncementDelivered)
        .length;
    final pendingCount = announcements.length - deliveredCount;

    return Scaffold(
      appBar: ScreenAppBar(title: l10n.associationAnnouncementsTitle),
      body: ListView(
        padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
        children: [
          _AnnouncementsHeader(
            totalCount: announcements.length,
            deliveredCount: deliveredCount,
            pendingCount: pendingCount,
          ),
          SizedBox(height: 18.h),
          Text(
            l10n.associationAnnouncementsHint,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(height: 14.h),
          ...announcements.map(
            (announcement) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: _AnnouncementCard(announcement: announcement),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnnouncementsHeader extends StatelessWidget {
  const _AnnouncementsHeader({
    required this.totalCount,
    required this.deliveredCount,
    required this.pendingCount,
  });

  final int totalCount;
  final int deliveredCount;
  final int pendingCount;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: isDark
              ? [
                  AppColors.burgundy.withValues(alpha: 0.9),
                  AppColors.black.withValues(alpha: 0.92),
                ]
              : [AppColors.burgundy, AppColors.goldDark],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Icon(
                  Icons.campaign_rounded,
                  color: AppColors.offWhite,
                  size: 28.r,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.associationAnnouncementsTitle,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: AppColors.offWhite,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      l10n.associationAnnouncementsSubtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.offWhite.withValues(alpha: 0.86),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 18.h),
          Row(
            children: [
              Expanded(
                child: _HeaderStat(
                  label: l10n.associationAnnouncementTotal,
                  value: totalCount.toString(),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _HeaderStat(
                  label: l10n.associationAnnouncementDelivered,
                  value: deliveredCount.toString(),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _HeaderStat(
                  label: l10n.associationAnnouncementPending,
                  value: pendingCount.toString(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderStat extends StatelessWidget {
  const _HeaderStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.offWhite,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.offWhite.withValues(alpha: 0.84),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnnouncementCard extends StatelessWidget {
  const _AnnouncementCard({required this.announcement});

  final _Announcement announcement;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final statusColor =
        announcement.status == l10n.associationAnnouncementDelivered
        ? Colors.green
        : AppColors.goldDark;

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
      child: Theme(
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: EdgeInsets.fromLTRB(16.w, 12.h, 12.w, 12.h),
          childrenPadding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
          leading: Container(
            width: 44.r,
            height: 44.r,
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: isDark ? 0.22 : 0.12),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(Icons.article_outlined, color: statusColor, size: 24.r),
          ),
          title: Text(
            announcement.title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          subtitle: Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: Wrap(
              spacing: 8.w,
              runSpacing: 6.h,
              children: [
                _InfoChip(
                  icon: Icons.confirmation_number_outlined,
                  label: announcement.number,
                ),
                _InfoChip(
                  icon: Icons.calendar_today_outlined,
                  label: announcement.date,
                ),
                _StatusChip(label: announcement.status, color: statusColor),
              ],
            ),
          ),
          children: [
            _DetailsPanel(
              children: [
                _DetailRow(
                  icon: Icons.category_outlined,
                  label: l10n.associationAnnouncementCategory,
                  value: announcement.category,
                ),
                _DetailRow(
                  icon: Icons.label_outline_rounded,
                  label: l10n.associationAnnouncementType,
                  value: announcement.type,
                ),
                _DetailRow(
                  icon: Icons.groups_outlined,
                  label: l10n.associationAnnouncementRecipients,
                  value: announcement.recipients,
                ),
                _DetailRow(
                  icon: Icons.hourglass_bottom_outlined,
                  label: l10n.associationAnnouncementDeadline,
                  value: announcement.deadline,
                ),
                _DetailRow(
                  icon: Icons.link_outlined,
                  label: l10n.associationAnnouncementRelatedEntity,
                  value: announcement.relatedEntity,
                ),
                _DetailRow(
                  icon: Icons.outgoing_mail,
                  label: l10n.associationAnnouncementChannels,
                  value: announcement.channels.join(', '),
                ),
                _ContentBlock(
                  title: l10n.associationAnnouncementContent,
                  content: announcement.content,
                ),
                _AttachmentsBlock(attachments: announcement.attachments),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailsPanel extends StatelessWidget {
  const _DetailsPanel({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.r),
        color: isDark
            ? AppColors.taupe.withValues(alpha: 0.12)
            : AppColors.burgundy.withValues(alpha: 0.045),
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
          Icon(
            icon,
            size: 19.r,
            color: isDark ? AppColors.goldLight : AppColors.burgundy,
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
                SizedBox(height: 3.h),
                Text(value, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ContentBlock extends StatelessWidget {
  const _ContentBlock({required this.title, required this.content});

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(top: 2.h, bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 8.h),
          Text(content, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _AttachmentsBlock extends StatelessWidget {
  const _AttachmentsBlock({required this.attachments});

  final List<String> attachments;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.associationAnnouncementAttachments,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: 8.h),
        if (attachments.isEmpty)
          Text(
            l10n.associationAnnouncementNoAttachments,
            style: theme.textTheme.bodyMedium,
          )
        else
          ...attachments.map(
            (attachment) => Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Row(
                children: [
                  Icon(Icons.attach_file_rounded, size: 18.r),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      attachment,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.onSecondaryFixed,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.r, color: theme.colorScheme.onTertiaryFixed),
          SizedBox(width: 5.w),
          Text(label, style: theme.textTheme.labelSmall),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _Announcement {
  const _Announcement({
    required this.number,
    required this.date,
    required this.title,
    required this.category,
    required this.type,
    required this.status,
    required this.recipients,
    required this.deadline,
    required this.relatedEntity,
    required this.channels,
    required this.content,
    required this.attachments,
  });

  final String number;
  final String date;
  final String title;
  final String category;
  final String type;
  final String status;
  final String recipients;
  final String deadline;
  final String relatedEntity;
  final List<String> channels;
  final String content;
  final List<String> attachments;

  static List<_Announcement> samples(AppLocalizations l10n) {
    return [
      _Announcement(
        number: 'ANN-2026-014',
        date: '2026-07-01',
        title: l10n.associationAnnouncementSampleTitle1,
        category: l10n.associationAnnouncementCategoryElectronic,
        type: l10n.associationAnnouncementTypePaymentNotice,
        status: l10n.associationAnnouncementPending,
        recipients: l10n.associationAnnouncementSampleRecipients1,
        deadline: l10n.associationAnnouncementSampleDeadline1,
        relatedEntity: l10n.associationAnnouncementSampleRelated1,
        channels: [
          l10n.associationAnnouncementChannelInApp,
          l10n.associationAnnouncementChannelWhatsapp,
        ],
        content: l10n.associationAnnouncementSampleContent1,
        attachments: [
          l10n.associationAnnouncementSampleAttachment1,
          l10n.associationAnnouncementSampleAttachment2,
        ],
      ),
      _Announcement(
        number: 'ANN-2026-009',
        date: '2026-06-18',
        title: l10n.associationAnnouncementSampleTitle2,
        category: l10n.associationAnnouncementCategoryOfficial,
        type: l10n.associationAnnouncementTypeMeetingInvitation,
        status: l10n.associationAnnouncementDelivered,
        recipients: l10n.associationAnnouncementSampleRecipients2,
        deadline: l10n.associationAnnouncementSampleDeadline2,
        relatedEntity: l10n.associationAnnouncementSampleRelated2,
        channels: [
          l10n.associationAnnouncementChannelInApp,
          l10n.associationAnnouncementChannelSms,
          l10n.associationAnnouncementChannelEmail,
        ],
        content: l10n.associationAnnouncementSampleContent2,
        attachments: [l10n.associationAnnouncementSampleAttachment3],
      ),
      _Announcement(
        number: 'ANN-2026-003',
        date: '2026-05-27',
        title: l10n.associationAnnouncementSampleTitle3,
        category: l10n.associationAnnouncementCategoryElectronic,
        type: l10n.associationAnnouncementTypeDecisionNotice,
        status: l10n.associationAnnouncementDelivered,
        recipients: l10n.associationAnnouncementSampleRecipients3,
        deadline: l10n.associationAnnouncementNoDeadline,
        relatedEntity: l10n.associationAnnouncementSampleRelated3,
        channels: [
          l10n.associationAnnouncementChannelInApp,
          l10n.associationAnnouncementChannelEmail,
        ],
        content: l10n.associationAnnouncementSampleContent3,
        attachments: const [],
      ),
    ];
  }
}
