import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/data/categories_data.dart';
import 'package:kalivra/models/product_model.dart';
import 'package:kalivra/views/widgets/cards/product_card.dart';
import 'package:kalivra/views/widgets/sections/brands_section.dart';
import 'package:kalivra/views/widgets/sections/products_section.dart';
import 'package:kalivra/views/widgets/sections/sales_section.dart';
import 'package:kalivra/views/widgets/slider_widgets/ad_slider.dart';

/// Home tab: welcome, carousel ads, categories grid, value propositions.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const List<String> _brandNames = [
    'براند 1',
    'براند ٢',
    'براند ٣',
    'براند ٤',
    'براند ٥',
    'براند ٦',
    'براند ٧',
    'براند ٨',
  ];

  static List<ProductModel> get _filteredProducts => CategoriesData.products;

  static List<ProductModel> get _saleProducts =>
      CategoriesData.products.take(8).toList();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: SizedBox(height: 8.h)),
        const SliverToBoxAdapter(child: AdSlider()),
        SliverToBoxAdapter(child: SizedBox(height: 24.h)),
        SliverToBoxAdapter(
          child: BrandsSection(
            brandNames: _brandNames,
          ),
        ),

        SliverToBoxAdapter(child: SizedBox(height: 24.h)),
        SliverToBoxAdapter(
          child: ProductsSection(filteredProducts: _filteredProducts),
        ),
        SliverToBoxAdapter(child: SizedBox(height: 24.h)),
        const SliverToBoxAdapter(child: AdSlider()),
        SliverToBoxAdapter(child: SizedBox(height: 24.h)),
        SliverToBoxAdapter(
          child: SalesSection(saleProducts: _saleProducts),
        ),
        SliverToBoxAdapter(child: SizedBox(height: 16.h)),
      ],
    );
  }
}


