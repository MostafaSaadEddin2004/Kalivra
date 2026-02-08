import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

  static List<AdvertisementModel> _buildSlides(ColorScheme colorScheme) {
    return [
      AdvertisementModel(
        title: 'عروض الدهانات',
        subtitle: 'خصم حتى 20% على تشكيلة الدهانات',
        gradientStart: colorScheme.primary,
        gradientEnd: colorScheme.primary.withValues(alpha: 0.8),
      ),
      AdvertisementModel(
        title: 'مواد البناء',
        subtitle: 'أسعار منافسة على السيراميك والحديد',
        gradientStart: colorScheme.secondary.withValues(alpha: 0.8),
        gradientEnd: colorScheme.secondary,
      ),
      AdvertisementModel(
        title: 'توصيل سريع',
        subtitle: 'توصيل لجميع المناطق',
        gradientStart: colorScheme.primary,
        gradientEnd: colorScheme.surfaceContainerHighest,
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.92);
    _startAutoPlay();
  }

  void _startAutoPlay() {
    const slideCount = 3;
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!_pageController.hasClients) return;
      final next = (_currentPage + 1) % slideCount;
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
    final slides = _buildSlides(Theme.of(context).colorScheme);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 152.h,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemCount: slides.length,
            itemBuilder: (context, index) {
              final slide = slides[index];
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: AdCard(slide: slide),
              );
            },
          ),
        ),
        SizedBox(height: 12.h),
        CustomSliderIndicator(slides: slides, currentPage: _currentPage),
      ],
    );
  }
}
