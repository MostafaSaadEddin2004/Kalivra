import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/controller/blocs/cubit/products_cubit/products_cubit.dart';
import 'package:kalivra/model/product/product_model.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/view/widgets/app_refresh_indicator.dart';
import 'package:kalivra/view/widgets/cards/product_card.dart';
import 'package:kalivra/view/widgets/profile_page/screen_app_bar.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AllProductsScreen extends StatefulWidget {
  const AllProductsScreen({super.key});

  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  late final ProductsCubit _productsCubit;

  @override
  void initState() {
    super.initState();
    _productsCubit = ProductsCubit()..loadProducts();
  }

  @override
  void dispose() {
    _productsCubit.close();
    super.dispose();
  }

  Future<void> _refreshProducts() {
    return _productsCubit.loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: ScreenAppBar(title: l10n.products),
      body: AppRefreshIndicator(
        onRefresh: _refreshProducts,
        child: BlocBuilder<ProductsCubit, ProductsState>(
          bloc: _productsCubit,
          builder: (context, state) {
            switch (state) {
              case ProductsLoading():
                return CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
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
                        delegate: SliverChildBuilderDelegate((context, index) {
                          return Skeletonizer(
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
                          );
                        }, childCount: 4),
                      ),
                    ),
                  ],
                );
              case ProductsLoaded():
                return CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
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
                        delegate: SliverChildBuilderDelegate((context, index) {
                          return ProductCard(product: state.products[index]);
                        }, childCount: state.products.length),
                      ),
                    ),
                  ],
                );
              case ProductsFailed():
                return RefreshableStateBox(
                  child: Center(child: Text(state.message)),
                );
              default:
                return const RefreshableStateBox(child: SizedBox.shrink());
            }
          },
        ),
      ),
    );
  }
}
