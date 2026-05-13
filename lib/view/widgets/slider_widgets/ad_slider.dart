import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/controller/blocs/cubit/ads_cubit/ads_cubit.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/view/widgets/slider_widgets/ad_card.dart';
import 'package:kalivra/view/widgets/slider_widgets/custom_indicator.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AdSlider extends StatefulWidget {
  const AdSlider({super.key});

  @override
  State<AdSlider> createState() => AdSliderState();
}

class AdSliderState extends State<AdSlider> {
  late final PageController _pageController;
  Timer? _timer;
  int _currentPage = 0;

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
    return BlocBuilder<AdsCubit, AdsState>(
      bloc: AdsCubit()..fetchAds(),
      builder: (context, state) {
        switch (state) {
          case AdsFailed():
            return Center(child: Text(state.errorMessage));
          case AdsFetched():
            final slides = state.ads;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 152.h,
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) =>
                        setState(() => _currentPage = index),
                    itemCount: slides.length,
                    itemBuilder: (context, index) {
                      final slide = slides[index].adsInfo[index].image;
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6.w),
                        child: AdCard(
                          imageUrl: slide,
                          onTap: () => context.push(
                            AppRoutes.adDetails,
                            extra: slides[index],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 12.h),
                CustomIndicator(
                  itemCount: slides.length,
                  currentPage: _currentPage,
                ),
              ],
            );
          default:
            return Skeletonizer(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 152.h,
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) =>
                          setState(() => _currentPage = index),
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6.w),
                          child: AdCard(imageUrl: 'slide', onTap: () {}),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 12.h),
                  CustomIndicator(itemCount: 3, currentPage: _currentPage),
                ],
              ),
            );
        }
      },
    );
  }
}
