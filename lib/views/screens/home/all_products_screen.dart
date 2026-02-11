import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/controllers/blocs/cubit/cart_cubit.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/data/categories_data.dart';
import 'package:kalivra/models/product_model.dart';
import 'package:kalivra/views/widgets/drawer/drawer_screen_app_bar.dart';
import 'package:kalivra/views/widgets/cards/product_card.dart';

/// Full-screen grid of all products. Tap a product to open product details.
class AllProductsScreen extends StatelessWidget {
  const AllProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final products = CategoriesData.products;
    final theme = Theme.of(context);

    void addToCart(ProductModel product) {
      context.read<CartCubit>().addItem(product);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تمت إضافة "${product.name}" إلى السلة'),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }

    return Scaffold(
      appBar: const DrawerScreenAppBar(title: 'المنتجات'),
      body: products.isEmpty
          ? Center(
              child: Text(
                'لا توجد منتجات',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            )
          : CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 24.h),
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
