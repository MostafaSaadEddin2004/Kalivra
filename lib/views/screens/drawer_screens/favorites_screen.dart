import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/controllers/blocs/cubit/cart_cubit/cart_cubit.dart';
import 'package:kalivra/controllers/blocs/cubit/wishlist_cubit/wishlist_cubit.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/core/network/api_error_handler.dart';
import 'package:kalivra/models/product_model.dart';
import 'package:kalivra/views/widgets/cards/product_card.dart';
import 'package:kalivra/views/widgets/drawer/drawer_screen_app_bar.dart';
import 'package:skeletonizer/skeletonizer.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<WishlistCubit>().loadWishlist();
  }

  void _addToCart(BuildContext context, ProductModel product) {
    context.read<CartCubit>().addItem(product);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: const DrawerScreenAppBar(title: 'المفضلة'),
      body: BlocConsumer<WishlistCubit, WishlistState>(
        listener: (context, state) {
          if (state.hasError) {
            ApiErrorHandler.showSnackBar(context, state.error!,
                fallbackMessage: 'فشل تحميل المفضلة');
          }
        },
        builder: (context, state) {
          if (state.isLoading && state.products.isEmpty) {
            return Skeletonizer(
              enabled: true,
              child: ListView.builder(
                padding: EdgeInsets.all(16.w),
                itemCount: 6,
                itemBuilder: (_, i) => Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: ProductCard(
                    product: ProductModel(
                      id: '$i',
                      name: 'منتج',
                      categoryId: '1',
                      price: 0,
                      quantity: 1,
                    ),
                    onAddToCart: () {},
                    onTap: () {},
                  ),
                ),
              ),
            );
          }
          final products = state.products;
          if (products.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(32.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite_border_rounded,
                      size: 88.r,
                      color: isDark
                          ? AppColors.taupe.withValues(alpha: 0.6)
                          : AppColors.burgundy.withValues(alpha: 0.5),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      'قائمة المفضلة فارغة',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: isDark ? AppColors.offWhite : AppColors.burgundy,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'أضف المنتجات إلى المفضلة من خلال زر القلب في صفحة المنتج',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDark ? AppColors.taupe : AppColors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 24.h),
                    FilledButton.icon(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(Icons.shopping_bag_rounded, size: 22.r),
                      label: const Text('تسوق الآن'),
                      style: FilledButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            horizontal: 28.w, vertical: 14.h),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: ProductCard(
                  product: product,
                  onAddToCart: () => _addToCart(context, product),
                  onTap: () =>
                      context.push(AppRoutes.productDetails, extra: product),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
