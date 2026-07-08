import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:kalivra/controller/blocs/cubit/notifications_cubit/notifications_cubit.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/model/notifications/app_notification.dart';
import 'package:kalivra/view/widgets/cards/notification_card.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ScreenAppBar(
        title: AppLocalizations.of(context)!.navNotifications,
      ),
      body: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
          if (state.loginRequired) {
            return LoginRequiredPlaceholder(
              icon: Icons.notifications_off_outlined,
              title: AppLocalizations.of(
                context,
              )!.loginRequiredForNotifications,
              description: AppLocalizations.of(
                context,
              )!.notificationsLoginPrompt,
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
