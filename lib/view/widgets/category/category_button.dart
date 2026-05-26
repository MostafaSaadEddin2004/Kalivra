import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/model/category/category_api_model.dart';

class CategoryButton extends StatelessWidget {
  const CategoryButton({
    super.key,
    required this.category,
    required this.onTap,
    required this.currentIndex,
    required this.index,
  });

  final CategoryApiModel category;
  final VoidCallback onTap;
  final int currentIndex;
  final int index;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isSelected = currentIndex == index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: isSelected
                ? colorScheme.onTertiary
                : colorScheme.onSecondaryFixed,
            borderRadius: BorderRadius.circular(24.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Text(
            category.name,
            style: textTheme.labelLarge?.copyWith(
              color: isSelected
                  ? colorScheme.onPrimaryFixed
                  : colorScheme.onTertiary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
          //      Row(
          //   mainAxisSize: MainAxisSize.min,
          //   children: [
          //     Image.network(
          //       category.imageUrl??'',
          //       height: 20.h,
          //       width: 20.w,
          //       color: isSelected
          //           ? colorScheme.onPrimaryFixed
          //           : colorScheme.onTertiary,
          //     ),
          //     SizedBox(width: 8.w),

          //   ],
          // ),
        ),
      ),
    );
  }
}
