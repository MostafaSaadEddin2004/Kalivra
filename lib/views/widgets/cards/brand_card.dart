import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/core/app_theme.dart';

class BrandCard extends StatelessWidget {
  const BrandCard({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () {},
      child: Container(
        // padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 10.w),
        decoration: BoxDecoration(
          color: theme.colorScheme.onTertiary,
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primaryFixed,
              blurRadius: 0.5.r,
              spreadRadius: 0.1.r
            )
          ],
          borderRadius: BorderRadius.circular(12.r),
        ),

        width: 90.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 70.h,
              width: 90.w,
              decoration: BoxDecoration(
                color: AppColors.lightGray,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.store_rounded,
                size: 28.r,
                color: AppColors.burgundy,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                label,
                style: theme.textTheme.displaySmall,
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
