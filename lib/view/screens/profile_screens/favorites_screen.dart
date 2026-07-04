import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/controller/blocs/cubit/wishlist_cubit/wishlist_cubit.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/model/product/product_model.dart';
import 'package:kalivra/view/widgets/cards/product_card.dart';
import 'package:kalivra/view/widgets/profile_page/screen_app_bar.dart';
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

  // void _addToCart(BuildContext context, ProductModel product) {
  //   context.read<CartCubit>().addItem(product);
  // }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: ScreenAppBar(title: l10n.favorites),
      body: BlocBuilder<WishlistCubit, WishlistState>(
        bloc: WishlistCubit()..loadWishlist(),
        builder: (context, state) {
          switch (state) {
            case WishlistLoaded():
              final products = state.wishlist;
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
                          l10n.favoritesEmpty,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: isDark
                                ? AppColors.offWhite
                                : AppColors.burgundy,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          l10n.favoritesPrompt,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: isDark ? AppColors.taupe : AppColors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 24.h),
                        FilledButton.icon(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(Icons.shopping_bag_rounded, size: 22.r),
                          label: Text(l10n.shopNow),
                          style: FilledButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: 28.w,
                              vertical: 14.h,
                            ),
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
                  return Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: ProductCard(product: products[index]),
                  );
                },
              );
            case WishlistFailed():
              return Center(
                child: Text(state.message),
              );
            default:
              return ListView.builder(
                padding: EdgeInsets.all(16.w),
                itemCount: 4,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: Skeletonizer(
                      child: ProductCard(
                        product: ProductModel(
                                id: 0,
                                sku: '',
                                name: '',
                                urlKey: '',
                                images: [],
                                isNew: true,
                                prices: ProductPrices(regular: PriceDetail(price: '')),
                                isFeatured: true,
                                onSale: true,
                                isSaleable: true,
                                isWishlist: true,
                                ratings: ProductRatings(average: '', total: 0),
                                reviews: ProductReviews(total: 0),
                              ),
                      ),
                    ),
                  );
                },
              );
          }
        },
      ),
    );
  }
}
