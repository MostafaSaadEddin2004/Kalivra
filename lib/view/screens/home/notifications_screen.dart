import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:kalivra/controller/blocs/cubit/notifications_cubit/notifications_cubit.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/model/notifications/app_notification.dart';
import 'package:kalivra/view/widgets/app_refresh_indicator.dart';
import 'package:kalivra/view/widgets/cards/notification_card.dart';
import 'package:kalivra/view/widgets/empty_state_view.dart';
import 'package:kalivra/view/widgets/login_required_placeholder.dart';
import 'package:kalivra/view/widgets/profile_page/screen_app_bar.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationsCubit>().refresh();
  }

  Future<void> _refreshNotifications() {
    return context.read<NotificationsCubit>().refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ScreenAppBar(
        title: AppLocalizations.of(context)!.navNotifications,
      ),
      body: AppRefreshIndicator(
        onRefresh: _refreshNotifications,
        child: BlocBuilder<NotificationsCubit, NotificationsState>(
          builder: (context, state) {
            if (state.loginRequired) {
              return RefreshableStateBox(
                child: LoginRequiredPlaceholder(
                  icon: Icons.notifications_off_outlined,
                  title: AppLocalizations.of(
                    context,
                  )!.loginRequiredForNotifications,
                  description: AppLocalizations.of(
                    context,
                  )!.notificationsLoginPrompt,
                ),
              );
            }

            if (state.isLoading) {
              return RefreshableStateBox(
                child: Center(
                  child: SpinKitFadingCircle(
                    size: 42.r,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              );
            }

            if (state.errorMessage.isNotEmpty) {
              return RefreshableStateBox(
                child: EmptyStateView(
                  icon: Icons.notifications_off_outlined,
                  title: AppLocalizations.of(context)!.error,
                  description: state.errorMessage,
                  actionLabel: AppLocalizations.of(context)!.retry,
                  onAction: _refreshNotifications,
                ),
              );
            }

            if (state.notifications.isEmpty) {
              final l10n = AppLocalizations.of(context)!;
              return RefreshableStateBox(
                child: Center(
                  child: EmptyStateView(
                    icon: Icons.notifications_none_rounded,
                    title: l10n.noNotifications,
                    description: l10n.notificationsEmptyPrompt,
                  ),
                ),
              );
            }

            return CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(child: SizedBox(height: 8.h)),
                SliverToBoxAdapter(
                  child: _UnreadNotificationsSummary(
                    unreadCount: state.unreadCount,
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final notification = state.notifications[index];
                    return NotificationCard(
                      typeLabel: notification.typeLabel,
                      priorityLabel: notification.priorityLabel,
                      statusLabel: notification.statusLabel,
                      title: notification.title,
                      body: notification.message,
                      time: _formatNotificationTime(
                        context,
                        notification.createdAt,
                      ),
                      icon: notification.icon,
                      isRead: notification.isRead,
                      isMandatory: notification.isMandatory,
                      onTap: () => _openNotification(context, notification),
                    );
                  }, childCount: state.notifications.length),
                ),
                SliverToBoxAdapter(child: SizedBox(height: 16.h)),
              ],
            );
          },
        ),
      ),
    );
  }

  String _formatNotificationTime(BuildContext context, DateTime createdAt) {
    final difference = DateTime.now().difference(createdAt);
    final l10n = AppLocalizations.of(context)!;

    if (difference.inHours < 1) {
      return l10n.now;
    }
    if (difference.inDays == 1) {
      return l10n.yesterday;
    }
    if (difference.inDays == 2) {
      return l10n.twoDaysAgo;
    }

    final locale = Localizations.localeOf(context).toString();
    return DateFormat.MMMd(locale).format(createdAt);
  }

  void _openNotification(BuildContext context, AppNotification notification) {
    context.read<NotificationsCubit>().markAsRead(notification.id);
    context.push(_routeForNotification(notification));
  }

  String _routeForNotification(AppNotification notification) {
    switch (notification.type) {
      case AppNotificationType.memberOperation:
        return AppRoutes.associationMemberProfile;
      case AppNotificationType.financialOperation:
        return AppRoutes.orders;
      case AppNotificationType.decisionSession:
      case AppNotificationType.officialAnnouncement:
      case AppNotificationType.legalDeadline:
        return AppRoutes.associationAnnouncements;
      case AppNotificationType.manualSystemNotice:
        return AppRoutes.settings;
      case AppNotificationType.deliveryFailure:
        return AppRoutes.contact;
    }
  }
}

class _UnreadNotificationsSummary extends StatelessWidget {
  const _UnreadNotificationsSummary({required this.unreadCount});

  final int unreadCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 12.h),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.colorScheme.tertiaryFixed.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: theme.colorScheme.primary.withValues(alpha: 0.12),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          child: Row(
            children: [
              Icon(
                Icons.mark_email_unread_outlined,
                color: theme.colorScheme.primary,
                size: 22.r,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  l10n.notificationUnread,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primaryFixed,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                constraints: BoxConstraints(minWidth: 34.r),
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(999.r),
                ),
                alignment: Alignment.center,
                child: Text(
                  unreadCount.toString(),
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.onPrimaryFixed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
