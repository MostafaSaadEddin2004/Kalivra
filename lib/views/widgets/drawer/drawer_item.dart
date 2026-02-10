import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DrawerItem extends StatelessWidget {
  const DrawerItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            child: Row(
              children: [
                Icon(icon, color: theme.colorScheme.onTertiary, size: 24.r),
                SizedBox(width: 12.w),
                Text(
                  label,
                  style: theme.textTheme.bodyLarge,
                  textAlign: TextAlign.end,
                ),
                const Spacer(),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 22.r,
                  color: theme.colorScheme.onTertiary,
                ),
              ],
            ),
          ),
        ),
        Divider(height: 1.h, color: theme.colorScheme.tertiaryFixed),
      ],
    );
  }
}
