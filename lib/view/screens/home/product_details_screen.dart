import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/controller/blocs/cubit/cart_cubit/cart_cubit.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/model/product/product_model.dart';
import 'package:kalivra/view/widgets/drawer/drawer_screen_app_bar.dart';
import 'package:kalivra/view/widgets/product/product_gallery_card.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key, required this.product});

  final ProductModel product;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  // int _selectedColorIndex = 0;
  // int _selectedSizeIndex = 0;

  // void _addToWishlist(BuildContext context, ProductModel product,AppLocalizations l10n) async {
  //     final productId = int.tryParse(product.id);
  //     if (productId == null || productId == 0) {
  //       if (context.mounted) {
  //         ApiErrorHandler.showSnackBar(context, null, fallbackMessage: AppLocalizations.of(context)!.invalidProductId);
  //       }
  //       return;
  //     }
  //     try {
  //       await context.read<WishlistCubit>().add(productId);
  //       if (context.mounted) {
  //         CustomSnackBar.show(context, 'تمت إضافة "${product.name}" إلى المفضلة');
  //       }
  //     } catch (e) {
  //       if (context.mounted) {
  //         ApiErrorHandler.showSnackBar(context, e, fallbackMessage: AppLocalizations.of(context)!.addToWishlistFailed);
  //       }
  //     }
  //   }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    // final colorOptions = product.selectableColors;
    // final sizeLabels = product.selectableSizes;
    // final colorIndex = colorOptions.isEmpty
    //     ? 0
    //     : _selectedColorIndex.clamp(0, colorOptions.length - 1);
    // final sizeIndex = sizeLabels.isEmpty
    //     ? 0
    //     : _selectedSizeIndex.clamp(0, sizeLabels.length - 1);

    return Scaffold(
      appBar: DrawerScreenAppBar(title: l10n.productDetails),
      body: ListView(
        padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              if (product.images.isNotEmpty)
                ProductGalleryCard(imageUrls: product.images)
              else
                Container(
                  width: double.infinity,
                  height: 220.h,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSecondaryFixed,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Image.network(
                    product.baseImage?.largeImageUrl ?? '',
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
            ],
          ),
          SizedBox(height: 20.h),
          Text(
            product.name,
            style: theme.textTheme.headlineSmall
          ),
          SizedBox(height: 12.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // if (hasSale) ...[
              //   Text(
              //     '${product.price} ${product.currencyOptions?.symbol}',
              //     style: theme.textTheme.bodyMedium
              //   ),
              //   SizedBox(width: 12.w),
              // ],
              Text(
                product.prices.regular.formattedPrice.toString(),
                style: theme.textTheme.headlineSmall
              ),
            ],
          ),
          // if (product.hasSelectableColors) ...[
          //   ProductColorSelectorCard(
          //     colors: colorOptions,
          //     selectedIndex: colorIndex,
          //     onSelected: (index) =>
          //         setState(() => _selectedColorIndex = index),
          //   ),
          //   SizedBox(height: 16.h),
          // ],
          // if (product.hasSelectableSizes) ...[
          //   ProductSizeSelectorCard(
          //     sizes: sizeLabels,
          //     selectedIndex: sizeIndex,
          //     onSelected: (index) => setState(() => _selectedSizeIndex = index),
          //   ),
          //   SizedBox(height: 16.h),
          // ],
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
                  _DetailRow(
                    icon: Icons.category_outlined,
                    label: l10n.unit,
                    value: product.name,
                    isDark: isDark,
                  ),
                  SizedBox(height: 12.h),
                  _DetailRow(
                    icon: Icons.inventory_2_outlined,
                    label: l10n.maxOrderLimit,
                    value: '${product.name} ${product.name}',
                    isDark: isDark,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16.h),
          OutlinedButton.icon(
            onPressed: () {},
            icon: Icon(Icons.favorite_border_rounded, size: 22.r),
            label: Text(
              l10n.addToWishlist,
              style: theme.textTheme.titleSmall?.copyWith(
                color: isDark ? AppColors.goldLight : AppColors.burgundy,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 14.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.r),
              ),
              side: BorderSide(
                color: isDark ? AppColors.goldLight : AppColors.burgundy,
              ),
            ),
          ),
          SizedBox(height: 24.h),
          FilledButton.icon(
            onPressed: () {
              context.read<CartCubit>().addItem(product);
            },
            icon: Icon(Icons.add_shopping_cart_rounded, size: 24.r),
            label: Text(
              l10n.addToCart,
              style: theme.textTheme.titleMedium?.copyWith(
                color: AppColors.offWhite,
                fontWeight: FontWeight.w700,
              ),
            ),
            style: FilledButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.r),
              ),
              elevation: 0,
            ),
          ),
        ],
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
  });

  final IconData icon;
  final String label;
  final String value;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
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
              ),
            ],
          ),
        ),
      ],
    );
  }
}
