import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/controller/blocs/cubit/notifications_cubit/notifications_cubit.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/l10n/app_localizations.dart';
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
        return CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate([
                NotificationCard(
                  title: AppLocalizations.of(context)!.notificationsWelcomeTitle,
                  body: AppLocalizations.of(context)!.notificationsWelcomeBody,
                  time: AppLocalizations.of(context)!.now,
                  icon: Icons.campaign_rounded,
                ),
                NotificationCard(
                  title: AppLocalizations.of(context)!.notificationsPaintOfferTitle,
                  body: AppLocalizations.of(context)!.notificationsPaintOfferBody,
                  time: AppLocalizations.of(context)!.yesterday,
                  icon: Icons.local_offer_rounded,
                ),
                NotificationCard(
                  title: AppLocalizations.of(context)!.notificationsOrderProcessingTitle,
                  body: AppLocalizations.of(context)!.notificationsOrderProcessingBody,
                  time: AppLocalizations.of(context)!.twoDaysAgo,
                  icon: Icons.inventory_2_outlined,
                ),
              ]),
            ),
          ],
        );
      },
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
              color: isDark ? AppColors.taupe : AppColors.burgundy.withValues(alpha: 0.6),
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
                color: isDark ? AppColors.taupe : AppColors.burgundy.withValues(alpha: 0.8),
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