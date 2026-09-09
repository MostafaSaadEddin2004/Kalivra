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
import 'package:skeletonizer/skeletonizer.dart';

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

          return Skeletonizer(
            child: ListView.separated(
              padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
              itemCount: 3,
              separatorBuilder: (context, index) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                return _AnnouncementCardHeader(
                  isExpanded: false,
                  announcement: AssociationAnnouncementModel(
                    id: 0,
                    referenceNumber: '4224',
                    type: 'type',
                    typeLabel: 'typeLabel',
                    title: 'title',
                    attachments: [],
                  ),
                );
              },
            ),
          );
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
        child: EmptyStateView(
          icon: Icons.campaign_outlined,
          title: l10n.associationAnnouncementEmptyTitle,
          description: l10n.associationAnnouncementEmptyDescription,
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: () async => onRetry(),
      child: ListView.separated(
        padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
        itemCount: announcements.length,
        separatorBuilder: (context, index) => SizedBox(height: 12.h),
        itemBuilder: (context, index) {
          return _AnnouncementCard(announcement: announcements[index]);
        },
      ),
    );
  }
}

class _AnnouncementCard extends StatefulWidget {
  const _AnnouncementCard({required this.announcement});

  final AssociationAnnouncementModel announcement;

  @override
  State<_AnnouncementCard> createState() => _AnnouncementCardState();
}

class _AnnouncementCardState extends State<_AnnouncementCard> {
  bool _isExpanded = false;

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final announcement = widget.announcement;
    return InkWell(
      onTap: _toggleExpanded,
      child: AnimatedCrossFade(
        duration: const Duration(milliseconds: 260),
        reverseDuration: const Duration(milliseconds: 200),
        firstCurve: Curves.easeOutCubic,
        secondCurve: Curves.easeInCubic,
        sizeCurve: Curves.easeInOutCubic,
        crossFadeState: _isExpanded
            ? CrossFadeState.showSecond
            : CrossFadeState.showFirst,
        firstChild: _AnnouncementCardHeader(
          announcement: announcement,
          isExpanded: _isExpanded,
        ),
        secondChild: Card(
          elevation: 2,
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 44.r,
                      height: 44.r,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.onTertiaryFixed.withValues(
                          alpha: 0.1,
                        ),
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Icon(
                        _typeIcon(announcement.type),
                        color: theme.colorScheme.onTertiaryFixed,
                        size: 24.r,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                announcement.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  color: theme.colorScheme.onTertiaryFixed,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              AnimatedRotation(
                                turns: _isExpanded ? 0.5 : 0,
                                duration: const Duration(milliseconds: 220),
                                curve: Curves.easeInOutCubic,
                                child: Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: theme.colorScheme.onTertiaryFixed,
                                  size: 26.r,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          Wrap(
                            spacing: 8.w,
                            runSpacing: 6.h,
                            children: [
                              _InfoChip(
                                label: announcement.referenceNumber.isNotEmpty
                                    ? announcement.referenceNumber
                                    : l10n.associationMemberNoData,
                              ),
                              _InfoChip(
                                icon: Icons.label_outline_rounded,
                                label: announcement.typeLabel,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14.h),
                _DetailsPanel(
                  children: [
                    _DetailRow(
                      icon: Icons.category_outlined,
                      label: l10n.associationAnnouncementCategory,
                      value:
                          announcement.category ?? l10n.associationMemberNoData,
                    ),
                    _DetailRow(
                      icon: Icons.calendar_today_outlined,
                      label: l10n.associationAnnouncementDate,
                      value: _dateLabel(context, announcement.announcementDate),
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
        ),
      ),
    );
  }
}

class _AnnouncementCardHeader extends StatelessWidget {
  const _AnnouncementCardHeader({
    required this.announcement,
    required this.isExpanded,
  });

  final AssociationAnnouncementModel announcement;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final typeLabel = _announcementTypeLabel(context, announcement);

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 44.r,
              height: 44.r,
              decoration: BoxDecoration(
                color: theme.colorScheme.onTertiaryFixed.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Icon(
                _typeIcon(announcement.type),
                color: theme.colorScheme.onTertiaryFixed,
                size: 24.r,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        announcement.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: theme.colorScheme.onTertiaryFixed,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      AnimatedRotation(
                        turns: isExpanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeInOutCubic,
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: theme.colorScheme.onTertiaryFixed,
                          size: 26.r,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 6.h,
                    children: [
                      _InfoChip(
                        label: announcement.referenceNumber.isNotEmpty
                            ? announcement.referenceNumber
                            : l10n.associationMemberNoData,
                      ),
                      _InfoChip(
                        icon: Icons.label_outline_rounded,
                        label: typeLabel,
                      ),
                    ],
                  ),
                ],
              ),
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
          Icon(icon, size: 19.r, color: theme.colorScheme.onTertiaryFixed),
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
  const _InfoChip({this.icon, required this.label});

  final IconData? icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryFixed.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14.r, color: theme.colorScheme.primaryFixed),
            SizedBox(width: 5.w),
          ],
          Text(
            label,
            style: theme.textTheme.labelSmall!.copyWith(
              color: theme.colorScheme.primaryFixed,
            ),
          ),
        ],
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

String _announcementTypeLabel(
  BuildContext context,
  AssociationAnnouncementModel announcement,
) {
  final l10n = AppLocalizations.of(context)!;
  final typeLabel = announcement.typeLabel.trim();
  if (typeLabel.isNotEmpty) return typeLabel;

  final type = announcement.type.trim();
  if (type.isNotEmpty) return type;

  return l10n.associationMemberNoData;
}

String _dateLabel(BuildContext context, DateTime? date) {
  final l10n = AppLocalizations.of(context)!;
  if (date == null) return l10n.associationMemberNoData;
  return DateFormat.yMMMd().format(date.toLocal());
}
