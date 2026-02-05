import 'package:flutter/material.dart';
import '../../core/app_theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    required this.onMenuTap,
  });

  final String title;
  final VoidCallback onMenuTap;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.burgundy,
      foregroundColor: AppColors.offWhite,
      elevation: 0,
      centerTitle: true,
      leading:IconButton(
          icon: const Icon(Icons.menu_rounded),
          onPressed: onMenuTap,
          tooltip: 'القائمة',
        ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.offWhite,
              fontWeight: FontWeight.w600,
            ),
      ),
      actions: [
         Padding(
        padding: const EdgeInsets.only(left: 8,right: 8),
        child: Image.asset(
          'assets/images/logo_splash.png',
          height: 28,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.store_rounded, size: 28, color: AppColors.offWhite),
        ),
      ),
      ],
    );
  }
}