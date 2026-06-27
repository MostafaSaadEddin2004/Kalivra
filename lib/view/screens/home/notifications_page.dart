import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:kalivra/controller/blocs/cubit/notifications_cubit/notifications_cubit.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/model/notifications/app_notification.dart';
import 'package:kalivra/view/widgets/cards/notification_card.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationsCubit>().refresh();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsCubit, NotificationsState>(
      builder: (context, state) {
        if (state.loginRequired) {
          return _LoginRequiredPlaceholder(
            onLoginTap: () => context.push(AppRoutes.login),
          );
        }

        if (state.notifications.isEmpty) {
          return const _EmptyNotificationsPlaceholder();
        }

        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: SizedBox(height: 8.h)),
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
        return AppRoutes.associationRequestsAndServices;
      case AppNotificationType.manualSystemNotice:
        return AppRoutes.settings;
      case AppNotificationType.deliveryFailure:
        return AppRoutes.contact;
    }
  }
}

class _EmptyNotificationsPlaceholder extends StatelessWidget {
  const _EmptyNotificationsPlaceholder();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none_rounded,
              size: 64.r,
              color: colorScheme.primary.withValues(alpha: 0.6),
            ),
            SizedBox(height: 20.h),
            Text(
              AppLocalizations.of(context)!.navNotifications,
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _LoginRequiredPlaceholder extends StatelessWidget {
  const _LoginRequiredPlaceholder({required this.onLoginTap});

  final VoidCallback onLoginTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_off_outlined,
              size: 64.r,
              color: isDark
                  ? AppColors.taupe
                  : AppColors.burgundy.withValues(alpha: 0.6),
            ),
            SizedBox(height: 20.h),
            Text(
              AppLocalizations.of(context)!.loginRequiredForNotifications,
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),
            Text(
              AppLocalizations.of(context)!.loginPromptNotifications,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark
                    ? AppColors.taupe
                    : AppColors.burgundy.withValues(alpha: 0.8),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            FilledButton(
              onPressed: onLoginTap,
              style: FilledButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(AppLocalizations.of(context)!.signIn),
            ),
          ],
        ),
      ),
    );
  }
}
