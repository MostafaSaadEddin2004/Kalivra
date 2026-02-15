import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/controllers/blocs/cubit/cart_cubit.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/views/widgets/custom_snack_bar.dart';
import 'package:kalivra/data/categories_data.dart';
import 'package:kalivra/models/product_model.dart';
import 'package:kalivra/views/widgets/drawer/drawer_screen_app_bar.dart';
import 'package:kalivra/views/widgets/cards/product_card.dart';

/// Full-screen grid of all sale products. Tap a product to open product details.
class AllSaleProductsScreen extends StatelessWidget {
  const AllSaleProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final products = CategoriesData.saleProducts;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    void addToCart(ProductModel product) {
      context.read<CartCubit>().addItem(product);
      CustomSnackBar.show(
        context,
        'تمت إضافة "${product.name}" إلى السلة',
      );
    }

    return Scaffold(
      appBar: const DrawerScreenAppBar(title: 'العروض'),
      body: products.isEmpty
          ? Center(
              child: Text(
                'لا توجد عروض حالياً',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            )
          : CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDark
                            ? [
                                AppColors.goldDark.withValues(alpha: 0.35),
                                AppColors.goldLight.withValues(alpha: 0.2),
                              ]
                            : [
                                AppColors.goldDark.withValues(alpha: 0.15),
                                AppColors.goldLight.withValues(alpha: 0.12),
                              ],
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.local_offer_rounded,
                          size: 22.r,
                          color: isDark ? AppColors.goldLight : AppColors.goldDark,
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Text(
                            'جميع المنتجات المخفضة',
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: isDark ? AppColors.offWhite : AppColors.burgundy,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16.h,
                      crossAxisSpacing: 16.w,
                      childAspectRatio: 0.68,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final product = products[index];
                        return ProductCard(
                          product: product,
                          onTap: () => context.push(
                              AppRoutes.productDetails, extra: product),
                          onAddToCart: () => addToCart(product),
                        );
                      },
                      childCount: products.length,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
