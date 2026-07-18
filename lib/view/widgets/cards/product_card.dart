import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/controller/blocs/bloc/locale_bloc/locale_bloc_bloc.dart';
import 'package:kalivra/controller/blocs/cubit/cart_cubit/cart_cubit.dart';
import 'package:kalivra/controller/blocs/cubit/wishlist_cubit/wishlist_cubit.dart';
import 'package:kalivra/controller/prefs/pref_keys.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/model/product/product_model.dart';
import 'package:kalivra/view/screens/home/product_details_screen.dart';
import 'package:kalivra/view/widgets/buttons/cart_button.dart';
import 'package:kalivra/view/widgets/cards/custom_network_image.dart';
import 'package:kalivra/view/widgets/cards/text_slider.dart';
import 'package:kalivra/view/widgets/custom_snack_bar.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({super.key, required this.product, this.itemId});

  final ProductModel product;
  final int? itemId;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  late bool _isWishlist;
  bool _wishlistLoading = false;

  @override
  void initState() {
    super.initState();
    _isWishlist = widget.product.isWishlist;
  }

  @override
  void didUpdateWidget(covariant ProductCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.product.id != widget.product.id ||
        oldWidget.product.isWishlist != widget.product.isWishlist) {
      _isWishlist = widget.product.isWishlist;
    }
  }

  Future<void> _onWishlistTap() async {
    if (_wishlistLoading) return;

    final l10n = AppLocalizations.of(context)!;
    final wishlistCubit = context.read<WishlistCubit>();

    setState(() => _wishlistLoading = true);

    if (!_isWishlist) {
      final added = await wishlistCubit.addToWishlist(
        productId: widget.product.id,
        productName: widget.product.name,
        context: context,
      );
      if (!mounted) return;

      setState(() {
        _isWishlist = added ? true : _isWishlist;
        _wishlistLoading = false;
      });

      if (added) {
        CustomSnackBar.show(
          context,
          l10n.addToWishlistSuccess(widget.product.name),
        );
      } else if (wishlistCubit.state is WishlistFailed) {
        CustomSnackBar.show(context, l10n.addToWishlistFailed);
      }
      return;
    }

    final itemId = widget.itemId;
    final removed = itemId == null
        ? await wishlistCubit.removeProductFromWishlist(
            productId: widget.product.id,
          )
        : await wishlistCubit.removeFromWishlist(itemId: itemId);
    if (!mounted) return;

    setState(() {
      _isWishlist = removed ? false : _isWishlist;
      _wishlistLoading = false;
    });

    if (removed) {
      CustomSnackBar.show(
        context,
        l10n.removeFromWishlistSuccess(widget.product.name),
      );
    } else if (wishlistCubit.state is WishlistFailed) {
      CustomSnackBar.show(context, l10n.removeFromWishlistFailed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
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
      child: SizedBox(
        width: 160.w,
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
                    child: InkWell(
                      onTap: _onWishlistTap,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 8.w),
                        padding: EdgeInsets.all(6.r),
                        decoration: BoxDecoration(
                          color: AppColors.black.withValues(alpha: 0.3),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 6,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: _wishlistLoading
                            ? SizedBox(
                                height: 22.r,
                                width: 22.r,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.2.r,
                                  color: AppColors.offWhite,
                                ),
                              )
                            : Icon(
                                _isWishlist
                                    ? Icons.favorite_rounded
                                    : Icons.favorite_border_rounded,
                                size: 22.r,
                                color: _isWishlist
                                    ? AppColors.red
                                    : AppColors.offWhite,
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
                    TextSlider(text: product.name),
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
    final regularStr = widget.product.prices.regular.price;
    final finalStr = widget.product.prices.final_!.price;

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
