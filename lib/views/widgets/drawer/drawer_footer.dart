import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DrawerFooter extends StatelessWidget {
  const DrawerFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ClipOval(
            child: Container(
              width: 40.w,
              height: 40.h,
              color: theme.colorScheme.surface,
              padding: EdgeInsets.all(6.r),
              child: Image.asset(
                'assets/images/logo_small.png',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.store_rounded,
                  size: 24.r,
                  color: theme.colorScheme.onSecondaryFixed,
                ),
              ),
            ),
          ),
          Text('الإصدار 1.0.0', style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}
