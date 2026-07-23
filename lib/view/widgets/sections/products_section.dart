import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/controller/blocs/cubit/products_cubit/products_cubit.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/model/product/product_model.dart';
import 'package:kalivra/view/widgets/cards/product_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProductsSection extends StatefulWidget {
  const ProductsSection({super.key});

  @override
  State<ProductsSection> createState() => _ProductsSectionState();
}

class _ProductsSectionState extends State<ProductsSection> {
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(l10n.products, style: textTheme.titleMedium),
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: 12.h)),
        BlocBuilder<ProductsCubit, ProductsState>(
          bloc: _productsCubit,
          builder: (context, state) {
            switch (state) {
              case ProductsFailed():
                debugPrint(state.message);
                return SliverToBoxAdapter(
                  child: Center(child: Text(state.message)),
                );

              case ProductsLoaded():
                final products = state.products;
                if (products.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 24.h),
                      child: Center(child: Text(l10n.noProducts)),
                    ),
                  );
                }

                return _ProductsGrid(
                  childCount: products.length,
                  itemBuilder: (context, index) {
                    return ProductCard(product: products[index]);
                  },
                );

              default:
                return _ProductsGrid(
                  childCount: 4,
                  itemBuilder: (context, index) {
                    return Skeletonizer(
                      child: ProductCard(product: _skeletonProduct),
                    );
                  },
                );
            }
          },
        ),
      ],
    );
  }
}

class _ProductsGrid extends SliverPadding {
  _ProductsGrid({
    required int childCount,
    required NullableIndexedWidgetBuilder itemBuilder,
  }) : super(
         padding: EdgeInsets.symmetric(horizontal: 16.w),
         sliver: SliverGrid(
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
         ),
       );
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
