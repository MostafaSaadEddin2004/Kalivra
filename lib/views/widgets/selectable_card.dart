import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/core/app_theme.dart';

/// Shared selectable card for settings (theme mode, language, etc.).
/// Shows label, optional subtitle, optional icon, and check when selected.
class SelectableCard extends StatelessWidget {
  const SelectableCard({
    super.key,
    required this.label,
    this.subtitle,
    this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final String? subtitle;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.r),
        side: isSelected
            ? BorderSide(color: theme.colorScheme.inversePrimary, width: 1.5)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Row(
            children: [
              if (icon != null)
                Icon(
                  icon,
                  size: 24.r,
                  color: isSelected ? theme.colorScheme.inversePrimary : AppColors.taupe,
                ),
              if (icon != null) SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: isDark ? AppColors.offWhite : AppColors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (subtitle != null) ...[
                      SizedBox(height: 2.h),
                      Text(
                        subtitle!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isDark ? AppColors.taupe : AppColors.burgundy,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle_rounded,
                  color: theme.colorScheme.inversePrimary,
                  size: 24.r,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
