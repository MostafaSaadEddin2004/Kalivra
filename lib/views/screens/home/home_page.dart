import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/views/widgets/sections/brands_section.dart';
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

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: SizedBox(height: 8.h)),
        const SliverToBoxAdapter(child: AdSlider()),
        SliverToBoxAdapter(child: SizedBox(height: 24.h)),
        SliverToBoxAdapter(
          child: BrandsSection(textTheme: textTheme, colorScheme: colorScheme, brandNames: _brandNames),
        ),

        SliverToBoxAdapter(child: SizedBox(height: 24.h)),
      ],
    );
  }
}

