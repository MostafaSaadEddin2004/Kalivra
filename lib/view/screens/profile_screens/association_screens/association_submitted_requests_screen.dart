import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:kalivra/controller/blocs/cubit/assoiciation_link_cubit/association_link_cubit.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/model/association/association_request_summary.dart';
import 'package:kalivra/view/widgets/profile_page/screen_app_bar.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AssociationSubmittedRequestsScreen extends StatefulWidget {
  const AssociationSubmittedRequestsScreen({super.key});

  @override
  State<AssociationSubmittedRequestsScreen> createState() =>
      _AssociationSubmittedRequestsScreenState();
}

class _AssociationSubmittedRequestsScreenState
    extends State<AssociationSubmittedRequestsScreen> {
  final _associationCubit = AssociationLinkCubit();

  @override
  void initState() {
    super.initState();
    _reload();
  }

  @override
  void dispose() {
    _associationCubit.close();
    super.dispose();
  }

  Future<void> _reload() async {
    await _associationCubit.fetchRequests();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: ScreenAppBar(title: l10n.associationSubmittedRequestsTitle),
      body: BlocBuilder<AssociationLinkCubit, AssociationLinkState>(
        bloc: _associationCubit,
        builder: (context, state) {
          if (state is AssociationLinkLoading) {
            return Skeletonizer(
              child: ListView.builder(
                padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 32.h),
                itemCount: 3,
                itemBuilder: (context, index) {
                  return _RequestCard(
                    request: AssociationRequestSummary(
                      id: 0,
                      requestNumber: 'REQ-0000000$index',
                      type: 'type',
                      typeLabel: 'type',
                      status: 'status',
                      createdAt: DateTime.now(),
                      updatedAt: DateTime.now(),
                      documents: const [],
                    ),
                  );
                },
              ),
            );
          }

          if (state is AssociationLinkFailure) {
            return _ErrorState(onRetry: _reload);
          }
          if (state is AssociationLinkRequestsFetched) {
            final requests = [...state.linkRequests]
              ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
            if (requests.isEmpty) {
              return _EmptyState(
                onNewRequest: () async {
                  await context.push(AppRoutes.associationRequestsAndServices);
                  await _reload();
                },
              );
            }
            return RefreshIndicator(
              onRefresh: _reload,
              child: ListView.builder(
                padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 32.h),
                itemCount: requests.length,
                itemBuilder: (context, index) {
                  return _RequestCard(request: requests[index]);
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _RequestCard extends StatefulWidget {
  const _RequestCard({required this.request});

  final AssociationRequestSummary request;

  @override
  State<_RequestCard> createState() => _RequestCardState();
}

class _RequestCardState extends State<_RequestCard> {
  bool _isExpanded = false;

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final request = widget.request;

    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: BorderSide(
          color: theme.colorScheme.onTertiaryFixed.withValues(alpha: 0.12),
        ),
      ),
      child: InkWell(
        onTap: _toggleExpanded,
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: AnimatedCrossFade(
            duration: const Duration(milliseconds: 260),
            reverseDuration: const Duration(milliseconds: 200),
            firstCurve: Curves.easeOutCubic,
            secondCurve: Curves.easeInCubic,
            sizeCurve: Curves.easeInOutCubic,
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: _RequestCardHeader(
              request: request,
              isExpanded: _isExpanded,
            ),
            secondChild: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _RequestCardHeader(request: request, isExpanded: _isExpanded),
                SizedBox(height: 14.h),
                _RequestDetailsPanel(
                  children: [
                    _RequestDetailLine(
                      icon: Icons.sticky_note_2_outlined,
                      label: l10n.associationRequestCustomerNote,
                      value: _textOrFallback(context, request.customerNote),
                    ),
                    _RequestDetailLine(
                      icon: Icons.mark_chat_read_outlined,
                      label: l10n.associationRequestReplyMessage,
                      value: _textOrFallback(
                        context,
                        request.effectiveReplyMessage,
                      ),
                    ),
                    _RequestDetailLine(
                      icon: Icons.schedule_outlined,
                      label: l10n.associationRequestReplyAt,
                      value: _dateTimeLabel(context, request.effectiveReplyAt),
                    ),
                    SizedBox(height: 4.h),
                    FilledButton.icon(
                      onPressed: () => context.push(
                        AppRoutes.associationRequestDetails,
                        extra: request,
                      ),
                      icon: const Icon(Icons.open_in_new_rounded),
                      label: Text(l10n.associationRequestViewAllDetails),
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

class _RequestCardHeader extends StatelessWidget {
  const _RequestCardHeader({required this.request, required this.isExpanded});

  final AssociationRequestSummary request;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = _statusColor(context, request);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 46.r,
          height: 46.r,
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Icon(_statusIcon(request), color: statusColor, size: 24.r),
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
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 8.h),
              Wrap(
                spacing: 8.w,
                runSpacing: 6.h,
                children: [
                  _InfoChip(
                    icon: Icons.label_outline_rounded,
                    label: _textOrFallback(context, request.displayType),
                  ),
                  _StatusChip(request: request),
                ],
              ),
            ],
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
    );
  }
}

class _RequestDetailsPanel extends StatelessWidget {
  const _RequestDetailsPanel({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.r),
        color: theme.colorScheme.onTertiaryFixed.withValues(alpha: 0.06),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}

class _RequestDetailLine extends StatelessWidget {
  const _RequestDetailLine({
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
          Icon(icon, size: 18.r, color: theme.colorScheme.onTertiaryFixed),
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
        color: theme.colorScheme.onTertiaryFixed.withValues(alpha: 0.1),
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

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onNewRequest});

  final VoidCallback onNewRequest;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 72.r,
              color: theme.colorScheme.onTertiaryFixed.withValues(alpha: 0.4),
            ),
            SizedBox(height: 20.h),
            Text(
              l10n.associationNoSubmittedRequests,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onTertiaryFixed,
              ),
            ),
            SizedBox(height: 24.h),
            FilledButton(
              onPressed: onNewRequest,
              child: Text(l10n.associationLinkSubmit),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 56.r,
              color: theme.colorScheme.error,
            ),
            SizedBox(height: 16.h),
            Text(
              l10n.associationMemberLoadFailed,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
            ),
            SizedBox(height: 20.h),
            FilledButton(onPressed: onRetry, child: Text(l10n.retry)),
          ],
        ),
      ),
    );
  }
}
