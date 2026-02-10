import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/core/app_theme.dart';

class DrawerScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DrawerScreenAppBar({
    super.key,
    required this.title,
    this.actions,
  });

  final String title;
  final List<Widget>? actions;

  @override
  Size get preferredSize => Size.fromHeight(56.h);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fgColor = theme.appBarTheme.foregroundColor ?? AppColors.offWhite;

    return AppBar(
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.keyboard_arrow_right_rounded, color: fgColor, size: 20.r),
        onPressed: () => context.pop(),
        tooltip: 'رجوع',
      ),
      title: Text(
        title,
        style: theme.textTheme.titleLarge?.copyWith(
          color: fgColor,
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: actions ?? [SizedBox(width: 48.w)],
    );
  }
}
