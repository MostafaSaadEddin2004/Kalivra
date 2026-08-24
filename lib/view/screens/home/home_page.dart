import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/view/widgets/app_refresh_indicator.dart';
import 'package:kalivra/view/widgets/sections/brands_section.dart';
import 'package:kalivra/view/widgets/sections/products_section.dart';
import 'package:kalivra/view/widgets/slider_widgets/ad_slider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _reloadKey = 0;

  Future<void> _refreshHome() async {
    setState(() => _reloadKey++);
  }

  @override
  Widget build(BuildContext context) {
    return AppRefreshIndicator(
      onRefresh: _refreshHome,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: AdSlider(key: ValueKey('ads-$_reloadKey'))),
          SliverToBoxAdapter(child: SizedBox(height: 16.h)),
          SliverToBoxAdapter(
            child: BrandsSection(key: ValueKey('brands-$_reloadKey')),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 16.h)),
          ProductsSection(key: ValueKey('products-$_reloadKey')),
          SliverToBoxAdapter(child: SizedBox(height: 72.h)),
        ],
      ),
    );
  }
}
