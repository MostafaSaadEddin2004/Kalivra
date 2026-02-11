import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/models/product_model.dart';
import 'package:kalivra/views/widgets/cards/product_card.dart';

class ProductsSection extends StatelessWidget {
  const ProductsSection({
    super.key,
    required List<ProductModel> filteredProducts,
    this.onAddToCart,
    this.onProductTap,
    this.onShowAllTap,
  }) : _filteredProducts = filteredProducts;

  final List<ProductModel> _filteredProducts;
  final void Function(ProductModel product)? onAddToCart;
  final void Function(ProductModel product)? onProductTap;
  final VoidCallback? onShowAllTap;

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
              Text('المنتجات', style: textTheme.titleMedium),
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
          height: 220.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            clipBehavior: Clip.none,
            itemCount: _filteredProducts.length,
            itemBuilder: (context, index) {
              final product = _filteredProducts[index];
              return Padding(
                padding: EdgeInsets.only(left: 12.w),
                child: SizedBox(
                  width: 160.w,
                  height: 220.h,
                  child: ProductCard(
                    product: product,
                    onTap: onProductTap != null ? () => onProductTap!(product) : null,
                    onAddToCart: onAddToCart != null
                        ? () => onAddToCart!(product)
                        : null,
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
