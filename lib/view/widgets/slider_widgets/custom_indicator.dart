import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/core/app_theme.dart';

class CustomIndicator extends StatelessWidget {
  const CustomIndicator({
    super.key,
    required this.itemCount,
    required this.currentPage,
  });

  final int itemCount;
  final int currentPage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        itemCount,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: EdgeInsets.symmetric(horizontal: 3.w),
          width: currentPage == index ? 20.w : 8.h,
          height: 8.h,
          decoration: BoxDecoration(
            color: currentPage == index
                ? theme.colorScheme.onTertiaryFixed
                : AppColors.lightGray,
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
      ),
    );
  }
}
