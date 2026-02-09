import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/views/widgets/cards/brand_card.dart';

class BrandsSection extends StatelessWidget {
  const BrandsSection({
    super.key,
    required this.textTheme,
    required this.colorScheme,
    required List<String> brandNames,
  }) : _brandNames = brandNames;

  final TextTheme textTheme;
  final ColorScheme colorScheme;
  final List<String> _brandNames;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('العلامات التجارية', style: textTheme.titleMedium),
              InkWell(
                onTap: () {},
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.onSecondaryFixed,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    'عرض الكل',
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.burgundy,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 120.h,
          child: ListView.separated(
            separatorBuilder: (context, index) => SizedBox(width: 12.w),
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            clipBehavior: Clip.none,
            itemCount: _brandNames.length,
            itemBuilder: (context, index) {
              return BrandCard(label: _brandNames[index]);
            },
          ),
        ),
      ],
    );
  }
}
