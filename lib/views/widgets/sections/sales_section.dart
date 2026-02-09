import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/models/product_model.dart';
import 'package:kalivra/views/widgets/cards/product_card.dart';

class SalesSection extends StatelessWidget {
  const SalesSection({super.key, required List<ProductModel> saleProducts})
    : _saleProducts = saleProducts;

  final List<ProductModel> _saleProducts;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('العروض', style: textTheme.titleMedium),
              InkWell(
                onTap: () {},
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
          height: 220.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            clipBehavior: Clip.none,
            itemCount: _saleProducts.length,
            itemBuilder: (context, index) {
              final product = _saleProducts[index];
              return Padding(
                padding: EdgeInsets.only(left: 12.w),
                child: SizedBox(
                  width: 160.w,
                  height: 220.h,
                  child: ProductCard(
                    product: product,
                    onTap: () {},
                    onAddToCart: () {},
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
