import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/model/category/category_api_model.dart';
import 'package:kalivra/view/widgets/cards/custom_network_image.dart';

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
    final isAllCategory = category.id < 0;
    final circleSize = isSelected ? 78.r : 68.r;
    final iconSize = isSelected ? 34.r : 28.r;

    return InkWell(
      borderRadius: BorderRadius.circular(12.r),
      onTap: onTap,
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutCubic,
                height: circleSize,
                width: circleSize,
                decoration: BoxDecoration(
                  color:  colorScheme.onTertiaryFixed,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.goldLight
                        : Colors.transparent,
                    width: isSelected ? 2.5.w : 0,
                  ),
                 
                ),
                child: ClipOval(
                  child: isAllCategory
                      ? Center(
                          child: Icon(
                            Icons.apps_rounded,
                            color:colorScheme.onSurfaceVariant,
                            size: iconSize,
                          ),
                        )
                      : CustomNetworkImage(
                          imageUrl: category.imageUrl,
                          defaultIcon: Icons.category_rounded,
                        ),
                ),
              ),
              SizedBox(height: isSelected ? 6.h : 5.h),
              Text(
                category.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style:
                    (isSelected
                            ? textTheme.labelMedium
                            : textTheme.labelSmall)
                        ?.copyWith(
                          color: isSelected
                              ? colorScheme.onTertiary
                              : colorScheme.primaryFixed,
                          fontWeight: isSelected
                              ? FontWeight.w900
                              : FontWeight.w600,
                          height: 1.1,
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
