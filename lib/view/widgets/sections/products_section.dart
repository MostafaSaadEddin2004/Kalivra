import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/controller/blocs/cubit/products_cubit/products_cubit.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/model/product/product_model.dart';
import 'package:kalivra/view/widgets/buttons/show_all_button.dart';
import 'package:kalivra/view/widgets/cards/product_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProductsSection extends StatelessWidget {
  const ProductsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.products, style: textTheme.titleMedium),
              ShowAllButton(
                onShowAllTap: () => context.push(AppRoutes.allProducts),
                l10n: l10n,
                textTheme: textTheme,
                colorScheme: colorScheme,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 224.h,
          child: BlocBuilder<ProductsCubit, ProductsState>(
            bloc: ProductsCubit()..loadProducts(),
            builder: (context, state) {
              switch (state) {
                case ProductsFailed():
                  debugPrint(state.message);
                  return Center(child: Text(state.message));
                case ProductsLoaded():
                  final products = state.products;
                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    separatorBuilder: (context, index) => SizedBox(width: 8.w),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return ProductCard(product: products[index]);
                    },
                  );
                default:
                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    separatorBuilder: (context, index) => SizedBox(width: 8.w),
                    itemCount: 2,
                    itemBuilder: (context, index) {
                      return Skeletonizer(
                        child: SizedBox(
                          width: 160.w,
                          height: 220.h,
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
                        ),
                      );
                    },
                  );
              }
            },
          ),
        ),
      ],
    );
  }
}
