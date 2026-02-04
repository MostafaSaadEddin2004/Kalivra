import 'package:flutter/material.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/models/advertisement_model.dart';

class CustomSliderIndicator extends StatelessWidget {
  const CustomSliderIndicator({
    super.key,
    required List<AdvertisementModel> slides,
    required int currentPage,
  }) : _slides = slides, _currentPage = currentPage;

  final List<AdvertisementModel> _slides;
  final int _currentPage;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _slides.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: _currentPage == index ? 20 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: _currentPage == index
                ? AppColors.burgundy
                : AppColors.taupe.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}

