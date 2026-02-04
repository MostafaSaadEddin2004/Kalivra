

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/models/advertisement_model.dart';
import 'package:kalivra/views/widgets/slider_widgets/ad_card.dart';
import 'package:kalivra/views/widgets/slider_widgets/custom_slider_indicator.dart';

class AdSlider extends StatefulWidget {
  const AdSlider({super.key});

  @override
  State<AdSlider> createState() => AdSliderState();
}

class AdSliderState extends State<AdSlider> {
  late final PageController _pageController;
  Timer? _timer;
  int _currentPage = 0;

  static const List<AdvertisementModel> _slides = [
    AdvertisementModel(
      title: 'عروض الدهانات',
      subtitle: 'خصم حتى 20% على تشكيلة الدهانات',
      gradientStart: AppColors.burgundy,
      gradientEnd: Color(0xFF6B1A24),
    ),
    AdvertisementModel(
      title: 'مواد البناء',
      subtitle: 'أسعار منافسة على السيراميك والحديد',
      gradientStart: AppColors.goldDark,
      gradientEnd: AppColors.goldLight,
    ),
    AdvertisementModel(
      title: 'توصيل سريع',
      subtitle: 'توصيل لجميع المناطق',
      gradientStart: AppColors.burgundy,
      gradientEnd: AppColors.taupe,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.92);
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!_pageController.hasClients) return;
      final next = (_currentPage + 1) % _slides.length;
      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 152,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemCount: _slides.length,
            itemBuilder: (context, index) {
              final slide = _slides[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: AdCard(slide: slide),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        CustomSliderIndicator(slides: _slides, currentPage: _currentPage),
      ],
    );
  }
}
