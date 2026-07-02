import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
 
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: AdSlider()),
        SliverToBoxAdapter(child: SizedBox(height: 24.h)),
        SliverToBoxAdapter(child: BrandsSection()),
        SliverToBoxAdapter(child: SizedBox(height: 24.h)),
        SliverToBoxAdapter(child: ProductsSection()),
        SliverToBoxAdapter(child: SizedBox(height: 24.h)),
        SliverToBoxAdapter(child: AdSlider()),
        SliverToBoxAdapter(child: SizedBox(height: 24.h)),
        SliverToBoxAdapter(child: SalesSection()),
        SliverToBoxAdapter(child: SizedBox(height: 72.h)),
      ],
    );
  }
}
