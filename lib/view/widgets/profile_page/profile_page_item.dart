import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfilePageItem extends StatelessWidget {
  const ProfilePageItem({
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

    return InkWell(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r),),
        child: Container(
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
    );
  }
}
