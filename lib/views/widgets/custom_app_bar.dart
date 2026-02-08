import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    final colorScheme = Theme.of(context).colorScheme;
    return AppBar(
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.menu_rounded),
        onPressed: onMenuTap,
        tooltip: 'القائمة',
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.headlineLarge,
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(left: 8.w, right: 8.w),
          child: Image.asset(
            'assets/images/logo_splash.png',
            height: 28.h,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) =>
                Icon(Icons.store_rounded, size: 28.r, color: colorScheme.onPrimary),
          ),
        ),
      ],
    );
  }
}