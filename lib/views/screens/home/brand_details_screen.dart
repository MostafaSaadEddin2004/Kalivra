import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/controllers/blocs/cubit/cart_cubit.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/views/widgets/custom_snack_bar.dart';
import 'package:kalivra/data/categories_data.dart';
import 'package:kalivra/models/brand_model.dart';
import 'package:kalivra/models/product_model.dart';
import 'package:kalivra/views/widgets/drawer/drawer_screen_app_bar.dart';
import 'package:kalivra/views/widgets/sections/products_section.dart';
import 'package:kalivra/views/widgets/sections/sales_section.dart';

/// Brand details: name, shops count, locations, then products and sale products.
class BrandDetailsScreen extends StatelessWidget {
  const BrandDetailsScreen({super.key, required this.brand});

  final BrandModel brand;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primary = theme.colorScheme.primary;
    final surfaceColor = isDark
        ? AppColors.burgundy.withValues(alpha: 0.15)
        : AppColors.burgundy.withValues(alpha: 0.06);

    final brandProducts = CategoriesData.productsForBrand(brand.id);
    final brandSaleProducts = CategoriesData.saleProductsForBrand(brand.id);

    void addToCart(ProductModel product) {
      context.read<CartCubit>().addItem(product);
      CustomSnackBar.show(
        context,
        'تمت إضافة "${product.name}" إلى السلة',
      );
    }

    return Scaffold(
      appBar: DrawerScreenAppBar(title: brand.name),
      body: ListView(
        padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
        children: [
          // Brand header
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              children: [
                Container(
                  height: 80.h,
                  width: 80.w,
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Icon(
                    Icons.store_rounded,
                    size: 44.r,
                    color: primary.withValues(alpha: 0.8),
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  brand.name,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: isDark ? AppColors.offWhite : AppColors.black,
                    fontWeight: FontWeight.w800,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (brand.description != null) ...[
                  SizedBox(height: 8.h),
                  Text(
                    brand.description!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isDark ? AppColors.taupe : AppColors.burgundy,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          SizedBox(height: 20.h),
          // Details card: shops, locations, phone, website
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DetailRow(
                    icon: Icons.storefront_outlined,
                    label: 'عدد الفروع',
                    value: '${brand.shopCount} فرع',
                    isDark: isDark,
                  ),
                  if (brand.locations.isNotEmpty) ...[
                    SizedBox(height: 12.h),
                    _DetailRow(
                      icon: Icons.location_on_outlined,
                      label: 'المواقع',
                      value: brand.locations.join(' • '),
                      isDark: isDark,
                      maxLines: 5,
                    ),
                  ],
                  if (brand.phone != null) ...[
                    SizedBox(height: 12.h),
                    _DetailRow(
                      icon: Icons.phone_outlined,
                      label: 'الهاتف',
                      value: brand.phone!,
                      isDark: isDark,
                    ),
                  ],
                  if (brand.website != null) ...[
                    SizedBox(height: 12.h),
                    _DetailRow(
                      icon: Icons.language_outlined,
                      label: 'الموقع',
                      value: brand.website!,
                      isDark: isDark,
                    ),
                  ],
                ],
              ),
            ),
          ),
          SizedBox(height: 24.h),
          // Products section (all brand products)
          ProductsSection(
            filteredProducts: brandProducts,
            onAddToCart: (p) => addToCart(p),
            onProductTap: (p) => context.push(AppRoutes.productDetails, extra: p),
          ),
          if (brandProducts.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Center(
                child: Text(
                  'لا توجد منتجات لهذه العلامة حالياً',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isDark ? AppColors.taupe : AppColors.burgundy,
                  ),
                ),
              ),
            )
          else
            SizedBox(height: 24.h),
          // Sale products section (brand products on sale)
          SalesSection(
            saleProducts: brandSaleProducts,
            onAddToCart: (p) => addToCart(p),
            onProductTap: (p) => context.push(AppRoutes.productDetails, extra: p),
          ),
          if (brandSaleProducts.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Center(
                child: Text(
                  'لا توجد عروض لهذه العلامة حالياً',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isDark ? AppColors.taupe : AppColors.burgundy,
                  ),
                ),
              ),
            )
          else
            SizedBox(height: 16.h),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.isDark,
    this.maxLines = 1,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool isDark;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 22.r,
          color: isDark ? AppColors.goldLight : AppColors.burgundy,
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isDark ? AppColors.taupe : AppColors.burgundy,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                value,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: isDark ? AppColors.offWhite : AppColors.black,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: maxLines,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
