import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/views/widgets/buttons/custom_icon_button.dart';

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
      leading: CustomIconButton(
        icon: Icons.arrow_back_rounded,
        color: fgColor,
        iconSize: 20.r,
        onPressed: () => context.pop(),
        tooltip: AppLocalizations.of(context)!.back,
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
