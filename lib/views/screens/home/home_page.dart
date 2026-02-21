import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/controllers/blocs/cubit/cart_cubit/cart_cubit.dart';
import 'package:kalivra/controllers/blocs/cubit/products_cubit/products_cubit.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/core/network/api_error_handler.dart';
import 'package:kalivra/data/brands_data.dart';
import 'package:kalivra/models/brand_model.dart';
import 'package:kalivra/models/product_model.dart';
import 'package:kalivra/views/widgets/sections/brands_section.dart';
import 'package:kalivra/views/widgets/sections/products_section.dart';
import 'package:kalivra/views/widgets/sections/sales_section.dart';
import 'package:kalivra/views/widgets/slider_widgets/ad_slider.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// Home tab: ads (local), brands (local), products & sales from API.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static List<BrandModel> get _brands => BrandsData.brands;

  void _addToCart(BuildContext context, ProductModel product) {
    context.read<CartCubit>().addItem(product);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductsCubit, ProductsState>(
      listener: (context, state) {
        if (state.error != null) {
          ApiErrorHandler.showSnackBar(context, state.error!,
              fallbackMessage: 'فشل تحميل المنتجات');
        }
      },
      builder: (context, state) {
        final isLoading = state.isLoading;
        final products = state.products;

        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: SizedBox(height: 8.h)),
            SliverToBoxAdapter(
              child: AdSlider(
                onAdTap: (ad) => context.push(AppRoutes.adDetails, extra: ad),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 24.h)),
            SliverToBoxAdapter(
              child: BrandsSection(
                brands: _brands,
                onBrandTap: (brand) =>
                    context.push(AppRoutes.brandDetails, extra: brand),
                onShowAllTap: () => context.push(AppRoutes.allBrands),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 24.h)),
            SliverToBoxAdapter(
              child: isLoading && products.isEmpty
                  ? Skeletonizer(
                      enabled: true,
                      child: ProductsSection(
                        filteredProducts: _placeholderProducts(6),
                        onAddToCart: (_) {},
                        onProductTap: (_) {},
                        onShowAllTap: () {},
                      ),
                    )
                  : ProductsSection(
                      filteredProducts: products.isNotEmpty
                          ? products
                          : state.hasError
                              ? <ProductModel>[]
                              : state.products,
                      onAddToCart: (p) => _addToCart(context, p),
                      onProductTap: (p) =>
                          context.push(AppRoutes.productDetails, extra: p),
                      onShowAllTap: () => context.push(AppRoutes.allProducts),
                    ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 24.h)),
            SliverToBoxAdapter(
              child: AdSlider(
                onAdTap: (ad) => context.push(AppRoutes.adDetails, extra: ad),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 24.h)),
            SliverToBoxAdapter(
              child: isLoading && products.isEmpty
                  ? Skeletonizer(
                      enabled: true,
                      child: SalesSection(
                        saleProducts: _placeholderProducts(4),
                        onAddToCart: (_) {},
                        onProductTap: (_) {},
                        onShowAllTap: () {},
                      ),
                    )
                  : SalesSection(
                      saleProducts: products,
                      onAddToCart: (p) => _addToCart(context, p),
                      onProductTap: (p) =>
                          context.push(AppRoutes.productDetails, extra: p),
                      onShowAllTap: () => context.push(AppRoutes.allSaleProducts),
                    ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 16.h)),
          ],
        );
      },
    );
  }

  List<ProductModel> _placeholderProducts(int n) {
    return List.generate(
      n,
      (i) => ProductModel(
        id: '$i',
        name: 'منتج',
        categoryId: '1',
        price: 0,
        quantity: 1,
      ),
    );
  }
}
