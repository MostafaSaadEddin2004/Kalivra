import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _slides.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: EdgeInsets.symmetric(horizontal: 3.w),
          width: _currentPage == index ? 20.w : 8.w,
          height: 8.h,
          decoration: BoxDecoration(
            color: _currentPage == index
                ? colorScheme.secondary
                : AppColors.taupe,
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
      ),
    );
  }
}

