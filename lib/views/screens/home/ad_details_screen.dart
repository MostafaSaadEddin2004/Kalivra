import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/models/advertisement_model.dart';
import 'package:kalivra/views/widgets/drawer/drawer_screen_app_bar.dart';

/// Single ad details screen with company info. Opened when user taps an ad on home.
class AdDetailsScreen extends StatelessWidget {
  const AdDetailsScreen({super.key, required this.ad});

  final AdvertisementModel ad;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: DrawerScreenAppBar(
        title: ad.companyName ?? ad.title,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 32.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Promo header card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24.w),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(14.r),
                        decoration: BoxDecoration(
                          color: (isDark ? AppColors.offWhite : Colors.white)
                              .withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        child: Icon(
                          Icons.campaign_rounded,
                          size: 40.r,
                          color:
                              isDark ? AppColors.goldLight : AppColors.burgundy,
                        ),
                      ),
                      SizedBox(width: 20.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ad.title,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                color: isDark
                                    ? AppColors.offWhite
                                    : Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              ad.subtitle,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: (isDark
                                        ? AppColors.offWhite
                                        : Colors.white)
                                    .withValues(alpha: 0.95),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            // Company details card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'تفاصيل الشركة',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: isDark ? AppColors.goldLight : AppColors.burgundy,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    if (ad.companyName != null) ...[
                      _DetailRow(
                        icon: Icons.business_rounded,
                        label: 'اسم الشركة',
                        value: ad.companyName!,
                        isDark: isDark,
                      ),
                      SizedBox(height: 12.h),
                    ],
                    if (ad.whatTheySell != null) ...[
                      _DetailRow(
                        icon: Icons.shopping_bag_outlined,
                        label: 'ما تقدمه الشركة',
                        value: ad.whatTheySell!,
                        isDark: isDark,
                        maxLines: 3,
                      ),
                      SizedBox(height: 12.h),
                    ],
                    if (ad.location != null) ...[
                      _DetailRow(
                        icon: Icons.location_on_outlined,
                        label: 'الموقع',
                        value: ad.location!,
                        isDark: isDark,
                        maxLines: 3,
                      ),
                      SizedBox(height: 12.h),
                    ],
                    if (ad.phone != null) ...[
                      _DetailRow(
                        icon: Icons.phone_outlined,
                        label: 'رقم الهاتف',
                        value: ad.phone!,
                        isDark: isDark,
                      ),
                      SizedBox(height: 12.h),
                    ],
                    if (ad.website != null) ...[
                      _DetailRow(
                        icon: Icons.language_outlined,
                        label: 'الموقع الإلكتروني',
                        value: ad.website!,
                        isDark: isDark,
                      ),
                      SizedBox(height: 12.h),
                    ],
                    if (ad.description != null) ...[
                      _DetailRow(
                        icon: Icons.info_outline_rounded,
                        label: 'وصف إضافي',
                        value: ad.description!,
                        isDark: isDark,
                        maxLines: 4,
                      ),
                    ],
                    if (ad.companyName == null &&
                        ad.whatTheySell == null &&
                        ad.location == null &&
                        ad.phone == null &&
                        ad.website == null &&
                        ad.description == null)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        child: Text(
                          'لا توجد تفاصيل إضافية لهذا الإعلان',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: isDark ? AppColors.taupe : AppColors.burgundy,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.isDark,
    this.maxLines = 1,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool isDark;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 22.r,
          color: isDark ? AppColors.goldLight : AppColors.burgundy,
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isDark ? AppColors.taupe : AppColors.burgundy,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                value,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: isDark ? AppColors.offWhite : AppColors.black,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: maxLines,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
