import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/controller/blocs/bloc/locale_bloc/locale_bloc_bloc.dart';
import 'package:kalivra/controller/blocs/cubit/cart_cubit/cart_cubit.dart';
import 'package:kalivra/controller/prefs/pref_keys.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/model/product/product_model.dart';
import 'package:kalivra/view/screens/home/product_details_screen.dart';
import 'package:kalivra/view/widgets/buttons/cart_button.dart';
import 'package:kalivra/view/widgets/cards/custom_network_image.dart';
import 'package:kalivra/view/widgets/cards/text_slider.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product, });

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final surfaceColor = isDark
        ? AppColors.burgundy.withValues(alpha: 0.15)
        : AppColors.burgundy.withValues(alpha: 0.06);

    final l10n = AppLocalizations.of(context)!;
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: SizedBox(width: 160.w,
        child: InkWell(
          onTap: () => context.push(AppRoutes.productDetails, extra: product),
          borderRadius: BorderRadius.circular(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 110.h,
                    width: double.infinity,
                    color: surfaceColor,
                    child: CustomNetworkImage(
                      imageUrl: product.baseImage?.originalImageUrl,
                      defaultIcon: Icons.inventory_2_rounded,
                    ),
                  ),
                  Positioned(
                    top: 8.h,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {},
                        borderRadius: BorderRadius.circular(20.r),
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 8.w),
                          padding: EdgeInsets.all(6.r),
                          decoration: BoxDecoration(
                            color: theme.scaffoldBackgroundColor.withValues(
                              alpha: 0.9,
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 6,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Icon(Icons.favorite_border_rounded, size: 22.r),
                        ),
                      ),
                    ),
                  ),
                  if (product.isNew)
                    BlocBuilder<LocaleBloc, LocaleBlocState>(
                      builder: (context, state) {
                        switch (state) {
                          case LocaleFetched():
                            return Positioned(
                              top: 8.h,
                              right:
                                  state.locale.languageCode ==
                                      PrefKeys.arLocaleKey
                                  ? null
                                  : 8.h,
                              left:
                                  state.locale.languageCode ==
                                      PrefKeys.arLocaleKey
                                  ? 8.h
                                  : null,
                              child: ProductBadgeChip(
                                badge: ProductBadgeData(
                                  label: l10n.productNew,
                                  icon: Icons.fiber_new_rounded,
                                  color: AppColors.goldDark,
                                ),
                              ),
                            );
                        }
                      },
                    ),
                ],
              ),
              Container(
                padding: EdgeInsets.all(8.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextSlider(text: product.name,),
                    if (product.prices.final_?.price != null)
                      ProductBadgeChip(
                              badge: ProductBadgeData(
                                label: _salePercent(),
                                icon: Icons.percent,
                                color: AppColors.red,
                              ),
                            ),
                    SizedBox(height: 4.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _PriceBlock(product: product, isDark: isDark),
                        CardButton(
                          onTap: () => context.read<CartCubit>().addItem(
                            product.id.toString(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _salePercent() {
    final regularStr = product.prices.regular.price;
    final finalStr = product.prices.final_!.price;

    final regular = double.tryParse(regularStr);
    final finalP = double.tryParse(finalStr);

    if (regular == null || finalP == null || regular == 0) return '';

    final percent = ((regular - finalP) / regular * 100).round();
    if (percent <= 0) return '';

    return '-$percent%';
  }
}

class _PriceBlock extends StatelessWidget {
  const _PriceBlock({required this.product, required this.isDark});

  final ProductModel product;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (product.prices.final_?.price == null) {
      return Text(
        product.prices.regular.formattedPrice.toString(),
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: isDark ? AppColors.goldLight : AppColors.burgundy,
          fontSize: 14.sp,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          product.prices.regular.formattedPrice.toString(),
          style: theme.textTheme.bodySmall?.copyWith(
            decoration: TextDecoration.lineThrough,
            color: isDark
                ? AppColors.taupe.withValues(alpha: 0.8)
                : AppColors.lightGray,
            fontSize: 12.sp,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          product.prices.final_!.formattedPrice.toString(),
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.goldLight : AppColors.burgundy,
            fontSize: 14.sp,
          ),
        ),
      ],
    );
  }
}
