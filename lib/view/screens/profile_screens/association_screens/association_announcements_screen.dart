import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:kalivra/controller/blocs/cubit/assoiciation_link_cubit/association_link_cubit.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/model/association/association_announcement_model.dart';
import 'package:kalivra/view/widgets/empty_state_view.dart';
import 'package:kalivra/view/widgets/profile_page/screen_app_bar.dart';

class AssociationAnnouncementsScreen extends StatefulWidget {
  const AssociationAnnouncementsScreen({super.key});

  @override
  State<AssociationAnnouncementsScreen> createState() =>
      _AssociationAnnouncementsScreenState();
}

class _AssociationAnnouncementsScreenState
    extends State<AssociationAnnouncementsScreen> {
  late final AssociationLinkCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = AssociationLinkCubit()..fetchAnnouncements();
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
      appBar: ScreenAppBar(title: l10n.associationAnnouncementsTitle),
      body: BlocBuilder<AssociationLinkCubit, AssociationLinkState>(
        bloc: _cubit,
        builder: (context, state) {
          if (state is AssociationAnnouncementsFetched) {
            return _AnnouncementsList(
              announcements: state.announcements,
              onRetry: _cubit.fetchAnnouncements,
            );
          }

          if (state is AssociationLinkFailure) {
            return _FailureView(
              message: state.errorMessage,
              onRetry: _cubit.fetchAnnouncements,
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class _AnnouncementsList extends StatelessWidget {
  const _AnnouncementsList({
    required this.announcements,
    required this.onRetry,
  });

  final List<AssociationAnnouncementModel> announcements;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (announcements.isEmpty) {
      return RefreshIndicator(
        onRefresh: () async => onRetry(),
        child: ListView(
          children: [
            SizedBox(height: 120.h),
            EmptyStateView(
              icon: Icons.campaign_outlined,
              title: l10n.associationAnnouncementEmptyTitle,
              description: l10n.associationAnnouncementEmptyDescription,
            ),
          ],
        ),
      );
    }

    final deliveredCount = announcements
        .where((announcement) => announcement.isDelivered)
        .length;
    final pendingCount = announcements.length - deliveredCount;

    return RefreshIndicator(
      onRefresh: () async => onRetry(),
      child: ListView.separated(
        padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
        itemCount: announcements.length + 2,
        separatorBuilder: (context, index) => SizedBox(height: 12.h),
        itemBuilder: (context, index) {
          if (index == 0) {
            return _AnnouncementsHeader(
              totalCount: announcements.length,
              deliveredCount: deliveredCount,
              pendingCount: pendingCount,
            );
          }

          if (index == 1) {
            return Text(
              l10n.associationAnnouncementsHint,
              style: Theme.of(context).textTheme.bodyMedium,
            );
          }

          return _AnnouncementCard(announcement: announcements[index - 2]);
        },
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

  final AssociationAnnouncementModel announcement;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final statusColor = announcement.isDelivered
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
            child: Icon(
              _typeIcon(announcement.type),
              color: statusColor,
              size: 24.r,
            ),
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
                  label: announcement.referenceNumber,
                ),
                _InfoChip(
                  icon: Icons.calendar_today_outlined,
                  label: _dateLabel(context, announcement.announcementDate),
                ),
                _StatusChip(
                  label: announcement.isDelivered
                      ? l10n.associationAnnouncementDelivered
                      : l10n.associationAnnouncementPending,
                  color: statusColor,
                ),
              ],
            ),
          ),
          children: [
            _DetailsPanel(
              children: [
                _DetailRow(
                  icon: Icons.category_outlined,
                  label: l10n.associationAnnouncementCategory,
                  value: announcement.category ?? l10n.associationMemberNoData,
                ),
                _DetailRow(
                  icon: Icons.label_outline_rounded,
                  label: l10n.associationAnnouncementType,
                  value: announcement.typeLabel.isNotEmpty
                      ? announcement.typeLabel
                      : announcement.type,
                ),
                _DetailRow(
                  icon: Icons.hourglass_bottom_outlined,
                  label: l10n.associationAnnouncementDeadline,
                  value: _dateLabel(context, announcement.legalDeadline),
                ),
                _ContentPreview(content: announcement.content),
                SizedBox(height: 8.h),
                FilledButton.icon(
                  onPressed: () => context.push(
                    AppRoutes.associationAnnouncementDetails,
                    extra: announcement,
                  ),
                  icon: const Icon(Icons.open_in_new_rounded),
                  label: Text(l10n.associationAnnouncementShowDetails),
                ),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
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

class _ContentPreview extends StatelessWidget {
  const _ContentPreview({required this.content});

  final String? content;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final value = content?.trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.associationAnnouncementContent,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          value?.isNotEmpty == true ? value! : l10n.associationMemberNoData,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodyMedium?.copyWith(height: 1.45),
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
