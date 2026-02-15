import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/views/widgets/buttons/custom_icon_button.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key, required this.onMenuTap, this.onCartTap});

  final VoidCallback onMenuTap;
  final VoidCallback? onCartTap;

  @override
  Size get preferredSize => Size.fromHeight(56.h);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconColor = theme.appBarTheme.foregroundColor ?? AppColors.offWhite;
    return AppBar(
      elevation: 0,
      centerTitle: true,
      leadingWidth: onCartTap != null ? 120.w : null,
      leading: Row(
        spacing: 4.w,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconButton(
            icon: Icons.menu_rounded,
            color: iconColor,
            iconSize: 28.r,
            onPressed: onMenuTap,
            tooltip: 'القائمة',
          ),
          if (onCartTap != null) ...[
            CustomIconButton(
              icon: Icons.shopping_cart_rounded,
              color: iconColor,
              iconSize: 26.r,
              onPressed: onCartTap,
              tooltip: 'السلة',
            ),
          ],
        ],
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(left: 8.w, right: 8.w),
          child: Image.asset(
            'assets/images/logo_splash.png',
            height: 28.h,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) =>
                Icon(Icons.store_rounded, size: 28.r, color: iconColor),
          ),
        ),
      ],
    );
  }
}
