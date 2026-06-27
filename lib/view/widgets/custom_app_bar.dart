import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/controller/blocs/cubit/notifications_cubit/notifications_cubit.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/view/widgets/buttons/custom_icon_button.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.onSearchTap,
    required this.onNotificationsTap,
  });

  final VoidCallback onSearchTap;
  final VoidCallback onNotificationsTap;

  @override
  Size get preferredSize => Size.fromHeight(56.h);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconColor = theme.appBarTheme.foregroundColor ?? AppColors.offWhite;
    return AppBar(
      elevation: 0,
      centerTitle: true,
      leadingWidth: 120.w,
      leading: Row(
        spacing: 4.w,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconButton(
            icon: Icons.search_rounded,
            color: iconColor,
            iconSize: 25.r,
            onPressed: onSearchTap,
            tooltip: AppLocalizations.of(context)!.navSearch,
          ),
          BlocBuilder<NotificationsCubit, NotificationsState>(
            buildWhen: (previous, current) =>
                previous.unreadCount != current.unreadCount,
            builder: (context, state) {
              return _NotificationIconButton(
                unreadCount: state.unreadCount,
                iconColor: iconColor,
                onPressed: onNotificationsTap,
              );
            },
          ),
        ],
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(left: 8.w, right: 8.w),
          child: Image.asset(
            'assets/images/light_logo.png',
            height: 20.h,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) =>
                Icon(Icons.store_rounded, size: 28.r, color: iconColor),
          ),
        ),
      ],
    );
  }
}

class _NotificationIconButton extends StatelessWidget {
  const _NotificationIconButton({
    required this.unreadCount,
    required this.iconColor,
    required this.onPressed,
  });

  final int unreadCount;
  final Color iconColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final visibleCount = unreadCount > 99 ? '99+' : unreadCount.toString();

    return Stack(
      clipBehavior: Clip.none,
      children: [
        CustomIconButton(
          icon: Icons.notifications_rounded,
          color: iconColor,
          iconSize: 25.r,
          onPressed: onPressed,
          tooltip: AppLocalizations.of(context)!.navNotifications,
        ),
        if (unreadCount > 0)
          PositionedDirectional(
            top: 4.h,
            end: 2.w,
            child: Container(
              constraints: BoxConstraints(minWidth: 18.r, minHeight: 18.r),
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.error,
                borderRadius: BorderRadius.circular(9.r),
                border: Border.all(color: iconColor, width: 1.2.w),
              ),
              alignment: Alignment.center,
              child: Text(
                visibleCount,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onError,
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w700,
                  height: 1,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
