import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/controller/blocs/cubit/wishlist_cubit/wishlist_cubit.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/model/product/product_model.dart';
import 'package:kalivra/view/widgets/cards/product_card.dart';
import 'package:kalivra/view/widgets/empty_state_view.dart';
import 'package:kalivra/view/widgets/login_required_placeholder.dart';
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

    return Scaffold(
      appBar: ScreenAppBar(title: l10n.favorites),
      body: BlocBuilder<WishlistCubit, WishlistState>(
        builder: (context, state) {
          switch (state) {
            case WishlistLoginRequired():
              return LoginRequiredPlaceholder(
                icon: Icons.favorite_border_rounded,
                title: l10n.loginRequiredForFavorites,
                description: l10n.favoritesLoginPrompt,
                onLoginTap: () => context.push(AppRoutes.login),
              );
            case WishlistLoaded():
              final products = state.wishlist;
              if (products.isEmpty) {
                return EmptyStateView(
                  icon: Icons.favorite_border_rounded,
                  title: l10n.favoritesEmpty,
                  description: l10n.favoritesPrompt,
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
              return Center(child: Text(state.message));
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
                          prices: ProductPrices(
                            regular: PriceDetail(price: ''),
                          ),
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
