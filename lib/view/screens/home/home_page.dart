import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/model/brand/brand_model.dart';
import 'package:kalivra/view/widgets/sections/brands_section.dart';
import 'package:kalivra/view/widgets/sections/products_section.dart';
import 'package:kalivra/view/widgets/sections/sales_section.dart';
import 'package:kalivra/view/widgets/slider_widgets/ad_slider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<BrandModel> brands = [
    BrandModel(id: '0', name: 'name 0', shopCount: 1, locations: ['location']),
    BrandModel(
      id: '1',
      name: 'name 1',
      shopCount: 2,
      locations: ['location 1', 'location 2'],
    ),
    BrandModel(
      id: '2',
      name: 'name 2',
      shopCount: 3,
      locations: ['location 1', 'location 2', 'location 3'],
    ),
    BrandModel(
      id: '3',
      name: 'name 3',
      shopCount: 4,
      locations: ['location 1', 'location 2', 'location 3', 'location 4'],
    ),
    BrandModel(
      id: '4',
      name: 'name 4',
      shopCount: 5,
      locations: [
        'location 1',
        'location 2',
        'location 3',
        'location 4',
        'location 5',
      ],
    ),
    BrandModel(
      id: '5',
      name: 'name 5',
      shopCount: 6,
      locations: [
        'location 1',
        'location 2',
        'location 3',
        'location 4',
        'location 5',
        'location 6',
      ],
    ),
    BrandModel(
      id: '6',
      name: 'name 6',
      shopCount: 7,
      locations: [
        'location 1',
        'location 2',
        'location 3',
        'location 4',
        'location 5',
        'location 6',
        'location 7',
      ],
    ),
    BrandModel(
      id: '7',
      name: 'name 7',
      shopCount: 8,
      locations: [
        'location 1',
        'location 2',
        'location 3',
        'location 4',
        'location 5',
        'location 6',
        'location 7',
        'location 8',
      ],
    ),
    BrandModel(
      id: '8',
      name: 'name 8',
      shopCount: 9,
      locations: [
        'location 1',
        'location 2',
        'location 3',
        'location 4',
        'location 5',
        'location 6',
        'location 7',
        'location 8',
        'location 9',
      ],
    ),
    BrandModel(
      id: '9',
      name: 'name 9',
      shopCount: 10,
      locations: [
        'location 1',
        'location 2',
        'location 3',
        'location 4',
        'location 5',
        'location 6',
        'location 7',
        'location 8',
        'location 9',
        'location 10',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: AdSlider()),
        SliverToBoxAdapter(child: SizedBox(height: 24.h)),
        SliverToBoxAdapter(child: BrandsSection(brands: brands)),
        SliverToBoxAdapter(child: SizedBox(height: 24.h)),
        SliverToBoxAdapter(child: ProductsSection()),
        SliverToBoxAdapter(child: SizedBox(height: 24.h)),
        SliverToBoxAdapter(child: AdSlider()),
        SliverToBoxAdapter(child: SizedBox(height: 24.h)),
        SliverToBoxAdapter(child: SalesSection()),
        SliverToBoxAdapter(child: SizedBox(height: 16.h)),
      ],
    );
  }
}
