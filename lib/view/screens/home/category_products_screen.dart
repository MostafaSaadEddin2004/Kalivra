import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/controller/blocs/cubit/products_cubit/products_cubit.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/model/category/category_api_model.dart';
import 'package:kalivra/model/product/product_model.dart';
import 'package:kalivra/view/widgets/cards/custom_network_image.dart';
import 'package:kalivra/view/widgets/cards/product_card.dart';
import 'package:kalivra/view/widgets/profile_page/screen_app_bar.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CategoryProductsScreen extends StatelessWidget {
  const CategoryProductsScreen({super.key, required this.category});

  final CategoryApiModel category;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductsCubit()..loadProductByCategoryId(category.id),
      child: Scaffold(
        appBar: ScreenAppBar(title: category.name),
        body: _CategoryProductsBody(category: category),
      ),
    );
  }
}

class _CategoryProductsBody extends StatelessWidget {
  const _CategoryProductsBody({required this.category});

  final CategoryApiModel category;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocBuilder<ProductsCubit, ProductsState>(
      builder: (context, state) {
        final productCount = state is ProductsLoaded
            ? state.products.length
            : category.productCount;

        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 14.h),
                child: _CategoryHeaderCard(
                  category: category,
                  productCount: productCount,
                ),
              ),
            ),
            switch (state) {
              ProductsLoaded() =>
                state.products.isEmpty
                    ? SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.inventory_2_outlined,
                                size: 64.r,
                                color: isDark
                                    ? AppColors.taupe
                                    : AppColors.burgundy.withValues(alpha: 0.6),
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                l10n.noProductsInCategory,
                                style: theme.textTheme.titleMedium,
                              ),
                            ],
                          ),
                        ),
                      )
                    : SliverPadding(
                        padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 28.h),
                        sliver: _ProductsGrid(
                          childCount: state.products.length,
                          itemBuilder: (context, index) =>
                              ProductCard(product: state.products[index]),
                        ),
                      ),
              ProductsFailed() => SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: Text(state.message)),
              ),
              _ => SliverPadding(
                padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 28.h),
                sliver: _ProductsGrid(
                  childCount: 4,
                  itemBuilder: (context, index) => Skeletonizer(
                    child: ProductCard(product: _skeletonProduct),
                  ),
                ),
              ),
            },
          ],
        );
      },
    );
  }
}

class _CategoryHeaderCard extends StatelessWidget {
  const _CategoryHeaderCard({required this.category, this.productCount});

  final CategoryApiModel category;
  final int? productCount;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final imageUrl = _categoryImageUrl(category);

    return Container(
      height: 154.h,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.r)),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (imageUrl?.trim().isNotEmpty == true)
            CustomNetworkImage(
              imageUrl: imageUrl,
              defaultIcon: Icons.category_rounded,
            )
          else
            Container(
              color: theme.colorScheme.primary.withValues(alpha: 0.12),
              child: Icon(
                Icons.category_rounded,
                size: 64.r,
                color: theme.colorScheme.primary,
              ),
            ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.05),
                  Colors.black.withValues(alpha: 0.68),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (productCount != null) ...[
                  SizedBox(height: 8.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 5.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '${productCount!} ${l10n.products}',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductsGrid extends SliverGrid {
  _ProductsGrid({
    required int childCount,
    required NullableIndexedWidgetBuilder itemBuilder,
  }) : super(
         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
           crossAxisCount: 2,
           mainAxisSpacing: 12.h,
           crossAxisSpacing: 12.w,
           childAspectRatio: 0.72,
         ),
         delegate: SliverChildBuilderDelegate(
           itemBuilder,
           childCount: childCount,
         ),
       );
}

String? _categoryImageUrl(CategoryApiModel category) {
  return category.banner?.preferredUrl ??
      category.imageUrl ??
      category.logo?.preferredUrl;
}

final _skeletonProduct = ProductModel(
  id: 0,
  sku: '',
  name: '',
  urlKey: '',
  images: const [],
  isNew: true,
  prices: ProductPrices(regular: PriceDetail(price: '')),
  isFeatured: true,
  onSale: true,
  isSaleable: true,
  isWishlist: true,
  ratings: ProductRatings(average: '', total: 0),
  reviews: ProductReviews(total: 0),
);
