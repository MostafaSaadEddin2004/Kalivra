import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/data/brands_data.dart';
import 'package:kalivra/views/widgets/drawer/drawer_screen_app_bar.dart';
import 'package:kalivra/views/widgets/cards/brand_card.dart';

/// Full-screen list of all brands. Tap a brand to open brand details.
class AllBrandsScreen extends StatelessWidget {
  const AllBrandsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final brands = BrandsData.brands;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const DrawerScreenAppBar(title: 'العلامات التجارية'),
      body: brands.isEmpty
          ? Center(
              child: Text(
                'لا توجد علامات تجارية',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 24.h),
              child: Wrap(
                spacing: 12.w,
                runSpacing: 12.h,
                children: [
                  for (final brand in brands)
                    SizedBox(
                      width: 90.w,
                      height: 120.h,
                      child: BrandCard(
                        brand: brand,
                        onTap: () =>
                            context.push(AppRoutes.brandDetails, extra: brand),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}
