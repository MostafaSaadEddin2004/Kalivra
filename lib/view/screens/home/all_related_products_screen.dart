import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/controller/blocs/cubit/products_cubit/products_cubit.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/model/product/product_model.dart';
import 'package:kalivra/view/widgets/app_refresh_indicator.dart';
import 'package:kalivra/view/widgets/cards/product_card.dart';
import 'package:kalivra/view/widgets/profile_page/screen_app_bar.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AllRelatedProductsScreen extends StatefulWidget {
  const AllRelatedProductsScreen({super.key, required this.productId});

  final int productId;

  @override
  State<AllRelatedProductsScreen> createState() =>
      _AllRelatedProductsScreenState();
}

class _AllRelatedProductsScreenState extends State<AllRelatedProductsScreen> {
  late final ProductsCubit _productsCubit;

  @override
  void initState() {
    super.initState();
    _productsCubit = ProductsCubit()..loadRelatedProducts(widget.productId);
  }

  @override
  void dispose() {
    _productsCubit.close();
    super.dispose();
  }

  Future<void> _refreshProducts() {
    return _productsCubit.loadRelatedProducts(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: ScreenAppBar(title: l10n.relatedProducts),
      body: AppRefreshIndicator(
        onRefresh: _refreshProducts,
        child: BlocBuilder<ProductsCubit, ProductsState>(
          bloc: _productsCubit,
          builder: (context, state) {
            switch (state) {
              case ProductsLoading():
                return _ProductsGrid(
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return Skeletonizer(
                      child: ProductCard(product: _skeletonProduct),
                    );
                  },
                );
              case ProductsLoaded():
                if (state.products.isEmpty) {
                  return RefreshableStateBox(
                    child: Center(child: Text(l10n.noProducts)),
                  );
                }

                return _ProductsGrid(
                  itemCount: state.products.length,
                  itemBuilder: (context, index) {
                    return ProductCard(product: state.products[index]);
                  },
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

class _ProductsGrid extends StatelessWidget {
  const _ProductsGrid({required this.itemCount, required this.itemBuilder});

  final int itemCount;
  final NullableIndexedWidgetBuilder itemBuilder;

  @override
  Widget build(BuildContext context) {
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
            delegate: SliverChildBuilderDelegate(
              itemBuilder,
              childCount: itemCount,
            ),
          ),
        ),
      ],
    );
  }
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
