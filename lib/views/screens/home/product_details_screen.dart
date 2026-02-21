import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/controllers/blocs/cubit/cart_cubit/cart_cubit.dart';
import 'package:kalivra/controllers/blocs/cubit/wishlist_cubit/wishlist_cubit.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/core/network/api_error_handler.dart';
import 'package:kalivra/models/product_model.dart';
import 'package:kalivra/views/widgets/custom_snack_bar.dart';
import 'package:kalivra/views/widgets/drawer/drawer_screen_app_bar.dart';
import 'package:kalivra/views/widgets/product/product_gallery_card.dart';
import 'package:kalivra/views/widgets/product/product_options_cards.dart';

/// Full product details with add to cart.
class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key, required this.product});

  final ProductModel product;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _selectedColorIndex = 0;
  int _selectedSizeIndex = 0;

  Future<void> _addToWishlist(BuildContext context, ProductModel product) async {
    final productId = int.tryParse(product.id);
    if (productId == null || productId == 0) {
      if (context.mounted) {
        ApiErrorHandler.showSnackBar(context, null, fallbackMessage: 'معرّف المنتج غير صالح');
      }
      return;
    }
    try {
      await context.read<WishlistCubit>().add(productId);
      if (context.mounted) {
        CustomSnackBar.show(context, 'تمت إضافة "${product.name}" إلى المفضلة');
      }
    } catch (e) {
      if (context.mounted) {
        ApiErrorHandler.showSnackBar(context, e, fallbackMessage: 'فشل إضافة المنتج إلى المفضلة');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primary = theme.colorScheme.primary;
    final surfaceColor = isDark
        ? AppColors.burgundy.withValues(alpha: 0.15)
        : AppColors.burgundy.withValues(alpha: 0.06);
    final displayPrice = product.salePrice ?? product.price;
    final hasSale = product.salePrice != null;
    final salePercent = hasSale
        ? ((product.price - product.salePrice!) / product.price * 100).round()
        : 0;
    final imageUrls = product.effectiveImageUrls;
    final hasGallery = imageUrls.isNotEmpty;
    final hasColors = product.colors != null && product.colors!.isNotEmpty;
    final hasSizes = product.sizes != null && product.sizes!.isNotEmpty;

    return Scaffold(
      appBar: const DrawerScreenAppBar(title: 'تفاصيل المنتج'),
      body: ListView(
        padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              if (hasGallery)
                ProductGalleryCard(imageUrls: imageUrls)
              else
                Container(
                  width: double.infinity,
                  height: 220.h,
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.inventory_2_outlined,
                      size: 80.r,
                      color: primary.withValues(alpha: 0.7),
                    ),
                  ),
                ),
              if (hasSale)
                Positioned(
                  top: 12.h,
                  right: 12.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: AppColors.goldDark,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Text(
                      '-$salePercent%',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: AppColors.offWhite,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 20.h),
          Text(
            product.name,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: isDark ? AppColors.offWhite : AppColors.black,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (hasSale) ...[
                Text(
                  '${product.price.toStringAsFixed(0)} ل.س',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    decoration: TextDecoration.lineThrough,
                    color: isDark ? AppColors.taupe : AppColors.lightGray,
                  ),
                ),
                SizedBox(width: 12.w),
              ],
              Text(
                '${displayPrice.toStringAsFixed(0)} ل.س',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: isDark ? AppColors.goldLight : AppColors.burgundy,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          if (hasColors) ...[
            ProductColorSelectorCard(
              colors: product.colors!,
              selectedIndex: _selectedColorIndex,
              onSelected: (index) => setState(() => _selectedColorIndex = index),
            ),
            SizedBox(height: 16.h),
          ],
          if (hasSizes) ...[
            ProductSizeSelectorCard(
              sizes: product.sizes!,
              selectedIndex: _selectedSizeIndex,
              onSelected: (index) => setState(() => _selectedSizeIndex = index),
            ),
            SizedBox(height: 16.h),
          ],
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
                    label: 'الوحدة',
                    value: product.unit,
                    isDark: isDark,
                  ),
                  SizedBox(height: 12.h),
                  _DetailRow(
                    icon: Icons.inventory_2_outlined,
                    label: 'الحد الأقصى للطلب',
                    value: '${product.quantity} ${product.unit}',
                    isDark: isDark,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16.h),
          OutlinedButton.icon(
            onPressed: () => _addToWishlist(context, product),
            icon: Icon(Icons.favorite_border_rounded, size: 22.r),
            label: Text(
              'إضافة إلى المفضلة',
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
              'إضافة إلى السلة',
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
