import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/model/association/association_request_summary.dart';
import 'package:kalivra/model/services/api/association_link_api_service.dart';
import 'package:kalivra/view/widgets/drawer/drawer_screen_app_bar.dart';

class AssociationSubmittedRequestsScreen extends StatefulWidget {
  const AssociationSubmittedRequestsScreen({super.key});

  @override
  State<AssociationSubmittedRequestsScreen> createState() =>
      _AssociationSubmittedRequestsScreenState();
}

class _AssociationSubmittedRequestsScreenState
    extends State<AssociationSubmittedRequestsScreen> {
  final _api = AssociationLinkApiService();
  late Future<List<AssociationRequestSummary>> _requestsFuture;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    setState(() => _requestsFuture = _api.fetchRequests());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: DrawerScreenAppBar(title: l10n.associationSubmittedRequestsTitle),
      body: FutureBuilder<List<AssociationRequestSummary>>(
        future: _requestsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return _ErrorState(onRetry: _reload);
          }

          final requests = snapshot.data ?? [];

          if (requests.isEmpty) {
            return _EmptyState(
              onNewRequest: () async {
                await context.push(AppRoutes.associationLinkRequest);
                _reload();
              },
            );
          }

          return RefreshIndicator(
            onRefresh: () async => _reload(),
            child: ListView.builder(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 32.h),
              itemCount: requests.length,
              itemBuilder: (context, index) {
                return _RequestCard(request: requests[index]);
              },
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Request card
// ─────────────────────────────────────────────────────────────────────────────

class _RequestCard extends StatelessWidget {
  const _RequestCard({required this.request});

  final AssociationRequestSummary request;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    final borderColor = isDark
        ? AppColors.taupe.withValues(alpha: 0.2)
        : AppColors.burgundy.withValues(alpha: 0.12);

    final createdLabel = DateFormat.yMMMd().add_jm().format(
      request.createdAt.toLocal(),
    );

    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      color: isDark ? AppColors.burgundy.withValues(alpha: 0.08) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: BorderSide(color: borderColor),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status icon
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: _statusIconBackground(isDark),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                _statusIcon(),
                color: _statusIconColor(isDark),
                size: 24.r,
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Request ID + status chip
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${l10n.associationRequestNumber} #${request.id}',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? AppColors.offWhite
                                : AppColors.burgundy,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      _StatusChip(request: request),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  // Submitted at
                  _InfoLine(
                    icon: Icons.calendar_today_outlined,
                    text: '${l10n.associationRequestCreatedAt}: $createdLabel',
                    isDark: isDark,
                  ),
                  // Approved at (if any)
                  if (request.approvedAt != null) ...[
                    SizedBox(height: 4.h),
                    _InfoLine(
                      icon: Icons.check_circle_outline_rounded,
                      text:
                          '${l10n.associationRequestApprovedAt}: ${DateFormat.yMMMd().format(request.approvedAt!.toLocal())}',
                      isDark: isDark,
                    ),
                  ],
                  // Document URL (if any)
                  if (request.documentUrl != null &&
                      request.documentUrl!.isNotEmpty) ...[
                    SizedBox(height: 8.h),
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.open_in_new_rounded, size: 16.r),
                      label: Text(l10n.associationRequestViewDocument),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        textStyle: TextStyle(fontSize: 12.sp),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _statusIcon() {
    if (request.isApproved) return Icons.check_circle_outline_rounded;
    if (request.isRejected) return Icons.cancel_outlined;
    return Icons.hourglass_empty_rounded;
  }

  Color _statusIconBackground(bool isDark) {
    if (request.isApproved) {
      return isDark
          ? Colors.green.withValues(alpha: 0.2)
          : Colors.green.withValues(alpha: 0.1);
    }
    if (request.isRejected) {
      return isDark
          ? Colors.red.withValues(alpha: 0.2)
          : Colors.red.withValues(alpha: 0.1);
    }
    return isDark
        ? AppColors.goldDark.withValues(alpha: 0.2)
        : AppColors.goldDark.withValues(alpha: 0.1);
  }

  Color _statusIconColor(bool isDark) {
    if (request.isApproved) return Colors.green;
    if (request.isRejected) return Colors.red;
    return isDark ? AppColors.goldLight : AppColors.goldDark;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Status chip
// ─────────────────────────────────────────────────────────────────────────────

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.request});

  final AssociationRequestSummary request;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    Color bgColor;
    Color textColor;
    String label;

    if (request.isApproved) {
      bgColor = Colors.green.withValues(alpha: 0.15);
      textColor = Colors.green.shade700;
      label = l10n.associationRequestStatusApproved;
    } else if (request.isRejected) {
      bgColor = Colors.red.withValues(alpha: 0.15);
      textColor = Colors.red.shade700;
      label = l10n.associationRequestStatusRejected;
    } else {
      bgColor = AppColors.goldDark.withValues(alpha: 0.15);
      textColor = AppColors.goldDark;
      label = l10n.associationRequestStatusPending;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Info line helper
// ─────────────────────────────────────────────────────────────────────────────

class _InfoLine extends StatelessWidget {
  const _InfoLine({
    required this.icon,
    required this.text,
    required this.isDark,
  });

  final IconData icon;
  final String text;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final color = isDark
        ? AppColors.taupe
        : AppColors.burgundy.withValues(alpha: 0.7);

    return Row(
      children: [
        Icon(icon, size: 14.r, color: color),
        SizedBox(width: 6.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 12.sp, color: color),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Empty state
// ─────────────────────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onNewRequest});

  final VoidCallback onNewRequest;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 72.r,
              color: (isDark ? AppColors.taupe : AppColors.burgundy).withValues(
                alpha: 0.4,
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              l10n.associationNoSubmittedRequests,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: isDark ? AppColors.taupe : AppColors.burgundy,
              ),
            ),
            SizedBox(height: 24.h),
            FilledButton.icon(
              onPressed: onNewRequest,
              icon: const Icon(Icons.send_outlined),
              label: Text(l10n.associationLinkSubmit),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Error state
// ─────────────────────────────────────────────────────────────────────────────

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
