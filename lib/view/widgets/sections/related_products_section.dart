import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/controller/blocs/cubit/products_cubit/products_cubit.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/model/product/product_model.dart';
import 'package:kalivra/view/widgets/cards/product_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

class RelatedProductsSection extends StatefulWidget {
  const RelatedProductsSection({super.key, required this.productId});

  final int productId;

  @override
  State<RelatedProductsSection> createState() => _RelatedProductsSectionState();
}

class _RelatedProductsSectionState extends State<RelatedProductsSection> {
  late final ProductsCubit _productsCubit;

  @override
  void initState() {
    super.initState();
    _productsCubit = ProductsCubit()..loadRelatedProducts(widget.productId);
  }

  @override
  void didUpdateWidget(covariant RelatedProductsSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.productId != widget.productId) {
      _productsCubit.loadRelatedProducts(widget.productId);
    }
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

    return BlocBuilder<ProductsCubit, ProductsState>(
      bloc: _productsCubit,
      builder: (context, state) {
        switch (state) {
          case ProductsLoaded():
            if (state.products.isEmpty) return const SizedBox.shrink();
            return _RelatedProductsList(
              title: l10n.relatedProducts,
              products: state.products,
             
            );
          case ProductsFailed():
            return const SizedBox.shrink();
          default:
            return _RelatedProductsList(
              title: l10n.relatedProducts,
              products: const [],
              isLoading: true,
              titleStyle: textTheme.titleMedium,
            );
        }
      },
    );
  }
}

class _RelatedProductsList extends StatelessWidget {
  const _RelatedProductsList({
    required this.title,
    required this.products,
    this.isLoading = false,
    this.titleStyle,
  });

  final String title;
  final List<ProductModel> products;
  final bool isLoading;
  final TextStyle? titleStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayProducts = isLoading
        ? List<ProductModel>.filled(2, _skeletonProduct)
        : products;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: titleStyle ?? theme.textTheme.titleMedium),
              
            ],
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 224.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemCount: displayProducts.length,
            itemBuilder: (context, index) {
              final card = SizedBox(
                width: 160.w,
                height: 220.h,
                child: ProductCard(product: displayProducts[index]),
              );

              return Padding(
                padding: EdgeInsetsDirectional.only(end: 12.w),
                child: isLoading ? Skeletonizer(child: card) : card,
              );
            },
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
