import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/controller/blocs/cubit/brand_cubit/brand_cubit.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/model/brand/brand_model.dart';
import 'package:kalivra/model/product/product_model.dart';
import 'package:kalivra/view/widgets/cards/product_card.dart';
import 'package:kalivra/view/widgets/profile_page/screen_app_bar.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BrandDetailsScreen extends StatelessWidget {
  const BrandDetailsScreen({super.key, required this.brand});

  final BrandModel brand;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isDark = theme.brightness == Brightness.dark;
    final primary = theme.colorScheme.primary;
    final surfaceColor = isDark
        ? AppColors.burgundy.withValues(alpha: 0.15)
        : AppColors.burgundy.withValues(alpha: 0.06);

    return BlocProvider(
      create: (_) => BrandCubit()..fetchProductsByBrandId(brand.id),
      child: Scaffold(
        appBar: ScreenAppBar(title: brand.name),
        body: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
              sliver: SliverToBoxAdapter(
                child: _BrandHeaderCard(
                  brand: brand,
                  primary: primary,
                  surfaceColor: surfaceColor,
                  isDark: isDark,
                ),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 20.h)),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              sliver: SliverToBoxAdapter(
                child: Text(
                  l10n.products,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            BlocBuilder<BrandCubit, BrandState>(
              builder: (context, state) {
                switch (state) {
                  case BrandProductsLoading():
                    return _ProductsGridSliver(
                      products: _placeholderProducts(),
                      isLoading: true,
                    );
                  case BrandProductFetched():
                    final products = state.brandProducts;
                    if (products.isEmpty) {
                      return _MessageSliver(message: l10n.noProductsForBrand);
                    }
                    return _ProductsGridSliver(products: products);
                  case BrandProductsFailure():
                    return _MessageSliver(message: state.message);
                  default:
                    return const SliverToBoxAdapter(child: SizedBox.shrink());
                }
              },
            ),
            SliverToBoxAdapter(child: SizedBox(height: 32.h)),
          ],
        ),
      ),
    );
  }

  List<ProductModel> _placeholderProducts() {
    return List.generate(
      4,
      (_) => ProductModel(
        id: 0,
        sku: 'sku',
        name: 'name',
        urlKey: 'urlKey',
        images: const [],
        isNew: false,
        isFeatured: false,
        onSale: false,
        isSaleable: false,
        isWishlist: false,
        prices: ProductPrices(regular: PriceDetail(price: '')),
        ratings: ProductRatings(average: '', total: 1),
        reviews: ProductReviews(total: 1),
      ),
    );
  }
}

class _BrandHeaderCard extends StatelessWidget {
  const _BrandHeaderCard({
    required this.brand,
    required this.primary,
    required this.surfaceColor,
    required this.isDark,
  });

  final BrandModel brand;
  final Color primary;
  final Color surfaceColor;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
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
        ],
      ),
    );
  }
}

class _ProductsGridSliver extends StatelessWidget {
  const _ProductsGridSliver({required this.products, this.isLoading = false});

  final List<ProductModel> products;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16.h,
          crossAxisSpacing: 16.w,
          childAspectRatio: 0.68,
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          final card = ProductCard(product: products[index]);
          return isLoading ? Skeletonizer(child: card) : card;
        }, childCount: products.length),
      ),
    );
  }
}

class _MessageSliver extends StatelessWidget {
  const _MessageSliver({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ),
    );
  }
}
