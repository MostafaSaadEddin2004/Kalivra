import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/core/app_theme.dart';

class NavItem extends StatelessWidget {
  const NavItem({
    super.key,
    required this.icon,
    required this.title,
    required this.index,
    required this.currentIndex,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final int index;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final isSelected = index == currentIndex;
    final color = isSelected ? AppColors.offWhite : AppColors.taupe;
    return InkWell(
      onTap: () => onTap(index),
      borderRadius: BorderRadius.circular(12.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24.r,
              color: color,
            ),
            SizedBox(height: 4.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 11.sp,
                color: color,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
