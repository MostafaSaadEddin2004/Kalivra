import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/model/brand/brand_model.dart';
import 'package:kalivra/view/widgets/buttons/show_all_button.dart';
import 'package:kalivra/view/widgets/cards/brand_card.dart';

class BrandsSection extends StatelessWidget {
  const BrandsSection({
    super.key,
    required List<BrandModel> brands,
    this.onBrandTap,
    this.onShowAllTap,
  }) : _brands = brands;

  final List<BrandModel> _brands;
  final void Function(BrandModel brand)? onBrandTap;
  final VoidCallback? onShowAllTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.brandsSection, style: textTheme.titleMedium),
             ShowAllButton(
                onShowAllTap: () => context.push(AppRoutes.allBrands),
                l10n: l10n,
                textTheme: textTheme,
                colorScheme: colorScheme,
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 120.h,
          child: ListView.separated(
            separatorBuilder: (context, index) => SizedBox(width: 12.w),
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            clipBehavior: Clip.none,
            itemCount: _brands.length,
            itemBuilder: (context, index) {
              final brand = _brands[index];
              return BrandCard(
                brand: brand,
                onTap: onBrandTap != null ? () => onBrandTap!(brand) : null,
              );
            },
          ),
        ),
      ],
    );
  }
}
