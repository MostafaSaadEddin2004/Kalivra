import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/controllers/blocs/cubit/cart_cubit.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/data/brands_data.dart';
import 'package:kalivra/data/categories_data.dart';
import 'package:kalivra/models/brand_model.dart';
import 'package:kalivra/models/product_model.dart';
import 'package:kalivra/views/widgets/sections/brands_section.dart';
import 'package:kalivra/views/widgets/sections/products_section.dart';
import 'package:kalivra/views/widgets/sections/sales_section.dart';
import 'package:kalivra/views/widgets/slider_widgets/ad_slider.dart';

/// Home tab: welcome, carousel ads, categories grid, value propositions.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static List<BrandModel> get _brands => BrandsData.brands;

  static List<ProductModel> get _filteredProducts => CategoriesData.products;

  static List<ProductModel> get _saleProducts => CategoriesData.saleProducts;

  void _addToCart(BuildContext context, ProductModel product) {
    context.read<CartCubit>().addItem(product);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تمت إضافة "${product.name}" إلى السلة'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: SizedBox(height: 8.h)),
        SliverToBoxAdapter(
          child: AdSlider(
            onAdTap: (ad) =>
                context.push(AppRoutes.adDetails, extra: ad),
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
          child: ProductsSection(
            filteredProducts: _filteredProducts,
            onAddToCart: (p) => _addToCart(context, p),
            onProductTap: (p) => context.push(AppRoutes.productDetails, extra: p),
            onShowAllTap: () => context.push(AppRoutes.allProducts),
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: 24.h)),
        SliverToBoxAdapter(
          child: AdSlider(
            onAdTap: (ad) =>
                context.push(AppRoutes.adDetails, extra: ad),
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: 24.h)),
        SliverToBoxAdapter(
          child: SalesSection(
            saleProducts: _saleProducts,
            onAddToCart: (p) => _addToCart(context, p),
            onProductTap: (p) => context.push(AppRoutes.productDetails, extra: p),
            onShowAllTap: () => context.push(AppRoutes.allSaleProducts),
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: 16.h)),
      ],
    );
  }
}


