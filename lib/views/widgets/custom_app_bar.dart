import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/core/app_theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    required this.onMenuTap,
  });

  final String title;
  final VoidCallback onMenuTap;

  @override
  Size get preferredSize => Size.fromHeight(56.h);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // App bar uses theme appBarTheme (burgundy/black bg); foreground = offWhite
    final iconColor = theme.appBarTheme.foregroundColor ?? AppColors.offWhite;
    return AppBar(
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.menu_rounded, color: iconColor, size: 28.r),
        onPressed: onMenuTap,
        tooltip: 'القائمة',
      ),
      title: Text(
        title,
        style: theme.textTheme.headlineLarge?.copyWith(
          color: iconColor,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(left: 8.w, right: 8.w),
          child: Image.asset(
            'assets/images/logo_splash.png',
            height: 28.h,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Icon(
              Icons.store_rounded,
              size: 28.r,
              color: iconColor,
            ),
          ),
        ),
      ],
    );
  }
}