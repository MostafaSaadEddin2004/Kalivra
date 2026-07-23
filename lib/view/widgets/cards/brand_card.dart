import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/model/brand/brand_model.dart';
import 'package:kalivra/view/widgets/cards/custom_network_image.dart';
import 'package:kalivra/view/widgets/cards/text_slider.dart';

class BrandCard extends StatelessWidget {
  const BrandCard({super.key, required this.brand, this.expanded = false});

  final BrandModel brand;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: InkWell(
        onTap: () => context.push(AppRoutes.brandDetails, extra: brand),
        child: SizedBox(
          width: expanded ? null : 90.w,
          height: 100.h,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 70.h,
                width: double.infinity,
                color: colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.5,
                ),
                child: CustomNetworkImage(
                  imageUrl: brand.logo,
                  defaultIcon: Icons.store_rounded,
                  defaultIconColor: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10.w, 8.h, 10.w, 8.h),
                child: TextSlider(
                  text: brand.name,
                  textStyle: textTheme.titleSmall,
                  sliderSpeed: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
