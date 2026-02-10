import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDrawerHeader extends StatelessWidget {
  const CustomDrawerHeader({super.key, required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('القائمة', style: theme.textTheme.titleLarge),
              const Spacer(),
              IconButton(
                icon: Icon(
                  Icons.close_rounded,
                  color: theme.colorScheme.onTertiaryFixed,
                  size: 26.r,
                ),
                onPressed: onClose,
                tooltip: 'إغلاق',
              ),
            ],
          ),
        ),
        Divider(height: 1.h, color: theme.colorScheme.tertiaryFixed),
      ],
    );
  }
}
