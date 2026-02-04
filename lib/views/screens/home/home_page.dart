import 'package:flutter/material.dart';
import 'package:kalivra/views/widgets/slider_widgets/ad_slider.dart';

/// Home tab: welcome, carousel ads, categories grid, value propositions.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(child: SizedBox(height: 8)),
        const SliverToBoxAdapter(child: AdSlider()),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
       ],
    );
  }
}