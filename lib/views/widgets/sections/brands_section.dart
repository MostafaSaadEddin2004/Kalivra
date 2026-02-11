import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/models/brand_model.dart';
import 'package:kalivra/views/widgets/cards/brand_card.dart';

class BrandsSection extends StatelessWidget {
  const BrandsSection({
    super.key,
    required List<BrandModel> brands,
    this.onBrandTap,
    this.onShowAllTap,
  }) : _brands = brands;

  final List<BrandModel> _brands;
  final void Function(BrandModel brand)? onBrandTap;
  final VoidCallback? onShowAllTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('العلامات التجارية', style: textTheme.titleMedium),
              InkWell(
                onTap: onShowAllTap,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
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
            itemCount: _brands.length,
            itemBuilder: (context, index) {
              final brand = _brands[index];
              return BrandCard(
                brand: brand,
                onTap: onBrandTap != null ? () => onBrandTap!(brand) : null,
              );
            },
          ),
        ),
      ],
    );
  }
}
