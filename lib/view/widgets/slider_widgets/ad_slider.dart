import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/controller/blocs/cubit/ads_cubit/ads_cubit.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/model/ads_model.dart';
import 'package:kalivra/view/widgets/empty_state_view.dart';
import 'package:kalivra/view/widgets/slider_widgets/ad_card.dart';
import 'package:kalivra/view/widgets/slider_widgets/custom_indicator.dart';
import 'package:skeletonizer/skeletonizer.dart';

List<({AdsModel carousel, AdsInfoModel slide})> _flattenSlides(
  List<AdsModel> ads,
) {
  final out = <({AdsModel carousel, AdsInfoModel slide})>[];
  for (final carousel in ads) {
    for (final slide in carousel.adsInfo) {
      out.add((carousel: carousel, slide: slide));
    }
  }
  return out;
}

class AdSlider extends StatefulWidget {
  const AdSlider({super.key});

  @override
  State<AdSlider> createState() => AdSliderState();
}

class AdSliderState extends State<AdSlider> {
  late final PageController _pageController;
  late final AdsCubit _adsCubit;
  Timer? _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.92);
    _adsCubit = AdsCubit()..fetchAds();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!_pageController.hasClients) return;
      final state = _adsCubit.state;
      final slideCount = switch (state) {
        AdsFetched(:final ads) => _flattenSlides(ads).length,
        _ => 3,
      };
      if (slideCount == 0) return;
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
    _adsCubit.close();
    _pageController.dispose();
    super.dispose();
  }

  // void _openDetails(
  //   BuildContext context,
  //   AdsModel carousel,
  //   AdsInfoModel slide,
  // ) {
  //   final title = slide.title.trim().isNotEmpty
  //       ? slide.title.trim()
  //       : carousel.name;
  //   context.push(
  //     AppRoutes.adDetails,
  //     extra: AdvertisementModel(
  //       title: title,
  //       subtitle: carousel.name,
  //       gradientStart: AppColors.burgundy,
  //       gradientEnd: AppColors.goldLight,
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return BlocBuilder<AdsCubit, AdsState>(
      bloc: _adsCubit,
      builder: (context, state) {
        switch (state) {
          case AdsFailed():
            final l10n = AppLocalizations.of(context)!;
            return SizedBox(
              height: 260.h,
              child: EmptyStateView(
                icon: Icons.campaign_outlined,
                title: l10n.unexpectedError,
                description: state.errorMessage,
                actionLabel: l10n.retry,
                onAction: _adsCubit.fetchAds,
              ),
            );
          case AdsFetched():
            final entries = _flattenSlides(state.ads);
            if (entries.isEmpty) {
              return const SizedBox.shrink();
            }
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 152.h,
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) =>
                        setState(() => _currentPage = index),
                    itemCount: entries.length,
                    itemBuilder: (context, index) {
                      final item = entries[index];
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6.w),
                        child: AdCard(
                          imageUrl: item.slide.image,
                          // onTap: () =>
                          //     _openDetails(context, item.carousel, item.slide),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 12.h),
                CustomIndicator(
                  itemCount: entries.length,
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
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.r),
                                color: colorScheme.surfaceContainerHighest
                                    .withValues(alpha: 0.45),
                              ),
                            ),
                          ),
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
