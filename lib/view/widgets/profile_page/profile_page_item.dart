import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/core/app_theme.dart';

enum ProfilePageItemVariant { regular, action, danger }

class ProfilePageItem extends StatelessWidget {
  const ProfilePageItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.subtitle,
    this.variant = ProfilePageItemVariant.regular,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final String? subtitle;
  final ProfilePageItemVariant variant;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isAction = variant != ProfilePageItemVariant.regular;
    final foreground = variant == ProfilePageItemVariant.danger
        ? AppColors.burgundy
        : colorScheme.primaryFixed;
    final iconBackground = AppColors.burgundy.withValues(alpha: 0.06);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: Card(
        elevation: 1.5,
        margin: EdgeInsets.symmetric(vertical: 4.h),
        color: theme.cardTheme.color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isAction ? 14.w : 16.w,
            vertical: isAction ? 13.h : 12.h,
          ),
          child: Row(
            children: [
              Container(
                width: isAction ? 34.r : 42.r,
                height: isAction ? 34.r : 42.r,
                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  icon,
                  color: foreground,
                  size: isAction ? 20.r : 24.r,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: foreground,
                        fontWeight: isAction
                            ? FontWeight.w700
                            : FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitle != null && subtitle!.trim().isNotEmpty) ...[
                      SizedBox(height: 2.h),
                      Text(
                        subtitle!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.primaryFixed.withValues(
                            alpha: 0.48,
                          ),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              if (!isAction)
                Icon(
                  Icons.chevron_right_rounded,
                  size: 22.r,
                  color: AppColors.burgundy,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
