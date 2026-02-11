import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/data/ads_data.dart';
import 'package:kalivra/models/advertisement_model.dart';
import 'package:kalivra/views/widgets/drawer/drawer_screen_app_bar.dart';

/// Full-screen list of all ads (same as those on home) with details.
class AllAdsScreen extends StatelessWidget {
  const AllAdsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final ads = AdsData.getAds(colorScheme);

    return Scaffold(
      appBar: const DrawerScreenAppBar(title: 'الإعلانات'),
      body: ads.isEmpty
          ? Center(
              child: Text(
                'لا توجد إعلانات',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            )
          : ListView.separated(
              padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 24.h),
              itemCount: ads.length,
              separatorBuilder: (_, __) => SizedBox(height: 16.h),
              itemBuilder: (context, index) {
                final ad = ads[index];
                return _AdDetailCard(ad: ad);
              },
            ),
    );
  }
}

class _AdDetailCard extends StatelessWidget {
  const _AdDetailCard({required this.ad});

  final AdvertisementModel ad;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: LinearGradient(
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
          colors: [ad.gradientStart, ad.gradientEnd],
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.onSurface.withValues(alpha: 0.12),
            blurRadius: 12.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: (isDark ? AppColors.offWhite : Colors.white)
                      .withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.campaign_rounded,
                  size: 32.r,
                  color: isDark ? AppColors.goldLight : AppColors.burgundy,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ad.title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: isDark ? AppColors.offWhite : Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      ad.subtitle,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: (isDark ? AppColors.offWhite : Colors.white)
                            .withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
