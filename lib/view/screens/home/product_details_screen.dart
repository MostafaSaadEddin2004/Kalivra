import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/controller/blocs/cubit/cart_cubit/cart_cubit.dart';
import 'package:kalivra/controller/blocs/cubit/products_cubit/products_cubit.dart';
import 'package:kalivra/controller/blocs/cubit/wishlist_cubit/wishlist_cubit.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/core/html_utils.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/model/product/product_model.dart';
import 'package:kalivra/view/widgets/app_text_field.dart';
import 'package:kalivra/view/widgets/cards/custom_network_image.dart';
import 'package:kalivra/view/widgets/custom_snack_bar.dart';
import 'package:kalivra/view/widgets/profile_page/screen_app_bar.dart';
import 'package:kalivra/view/widgets/product/product_gallery_card.dart';
import 'package:kalivra/view/widgets/product/wishlist_icon.dart';
import 'package:kalivra/view/widgets/rating_stars.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key, required this.product});

  final ProductModel product;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final _reviewTitleController = TextEditingController();
  final _reviewCommentController = TextEditingController();
  BuildContext? _ratingDialogContext;
  late bool _isWishlist;
  bool _wishlistLoading = false;
  int _selectedRating = 0;

  @override
  void initState() {
    super.initState();
    _isWishlist = widget.product.isWishlist;
    context.read<ProductsCubit>().loadProductById(widget.product.id);
    context.read<WishlistCubit>().ensureWishlistLoaded();
  }

  @override
  void dispose() {
    _reviewTitleController.dispose();
    _reviewCommentController.dispose();
    super.dispose();
  }

  List<ProductImage> _galleryImages(ProductModel product) {
    if (product.images.isNotEmpty) return product.images;
    if (product.baseImage != null) return [product.baseImage!];
    return [];
  }

  void _submitProductReview(ProductModel product) {
    final l10n = AppLocalizations.of(context)!;
    final title = _reviewTitleController.text.trim();
    final comment = _reviewCommentController.text.trim();

    if (_selectedRating == 0) {
      CustomSnackBar.show(context, l10n.selectRating);
      return;
    }

    if (title.isEmpty || comment.isEmpty) {
      CustomSnackBar.show(context, l10n.required);
      return;
    }

    context.read<ProductsCubit>().postProductReview(
      productId: product.id,
      comment: comment,
      rating: _selectedRating,
    );
  }

  Future<void> _showRatingDialog(ProductModel fallbackProduct) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        _ratingDialogContext = dialogContext;
        return BlocBuilder<ProductsCubit, ProductsState>(
          bloc: context.read<ProductsCubit>(),
          builder: (context, state) {
            final variantState = state is ProductVariantSelected ? state : null;
            final product = variantState?.product ?? fallbackProduct;
            final isReviewSubmitting =
                variantState?.reviewStatus == ProductReviewStatus.submitting;
            final isDark = Theme.of(context).brightness == Brightness.dark;
            final theme = Theme.of(context);

            return StatefulBuilder(
              builder: (context, dialogSetState) {
                return Dialog(
                  insetPadding: EdgeInsets.symmetric(
                    horizontal: 18.w,
                    vertical: 24.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22.r),
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.sizeOf(context).height * 0.86,
                    ),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 16.h),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 28.r,
                                    height: 28.r,
                                    decoration: BoxDecoration(
                                      color:
                                          (isDark
                                                  ? AppColors.goldLight
                                                  : AppColors.burgundy)
                                              .withValues(alpha: 0.12),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.star_border_outlined,
                                      color: isDark
                                          ? AppColors.goldLight
                                          : AppColors.burgundy,
                                      size: 16.r,
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  Text(
                                    AppLocalizations.of(context)!.submitRating,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.w800),
                                  ),
                                ],
                              ),
                              IconButton(
                                onPressed: () => context.pop(),
                                icon: Icon(
                                  Icons.close_rounded,
                                  size: 24.r,
                                  color: theme.colorScheme.onTertiary,
                                ),
                              ),
                            ],
                          ),
                          ProductRatingCard(
                            product: product,
                            isDark: isDark,
                            selectedRating: _selectedRating,
                            titleController: _reviewTitleController,
                            commentController: _reviewCommentController,
                            isSubmitting: isReviewSubmitting,
                            onRatingChanged: (rating) {
                              setState(() => _selectedRating = rating);
                              dialogSetState(() {});
                            },
                            onSubmit: () => _submitProductReview(product),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
    _ratingDialogContext = null;
  }

  bool _isProductInWishlistState(ProductModel product, WishlistState state) {
    return state is WishlistLoaded &&
        state.wishlist.any((item) => item.product.id == product.id);
  }

  bool _effectiveWishlist(ProductModel product, WishlistState state) {
    return _isWishlist || _isProductInWishlistState(product, state);
  }

  Future<void> _toggleWishlist(ProductModel product) async {
    if (_wishlistLoading) return;

    final l10n = AppLocalizations.of(context)!;
    final wishlistCubit = context.read<WishlistCubit>();
    final wasInWishlist = _effectiveWishlist(product, wishlistCubit.state);

    setState(() => _wishlistLoading = true);
    try {
      final changed = wasInWishlist
          ? await wishlistCubit.removeProductFromWishlist(productId: product.id)
          : await wishlistCubit.addToWishlist(
              productId: product.id,
              productName: product.name,
              context: context,
            );
      if (!mounted) return;
      setState(() {
        _isWishlist = changed ? !wasInWishlist : wasInWishlist;
        _wishlistLoading = false;
      });
      if (!changed) return;
      CustomSnackBar.show(
        context,
        wasInWishlist
            ? l10n.removeFromWishlistSuccess(widget.product.name)
            : l10n.addToWishlistSuccess(widget.product.name),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _wishlistLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final wishlistState = context.watch<WishlistCubit>().state;

    return Scaffold(
      appBar: ScreenAppBar(title: l10n.productDetails),
      body: BlocConsumer<ProductsCubit, ProductsState>(
        listenWhen: (previous, current) {
          if (current is! ProductVariantSelected) return false;
          if (previous is! ProductVariantSelected) return true;
          return previous.reviewStatus != current.reviewStatus;
        },
        listener: (context, state) {
          if (state is! ProductVariantSelected) return;

          if (state.reviewStatus == ProductReviewStatus.submitted) {
            _reviewTitleController.clear();
            _reviewCommentController.clear();
            final dialogContext = _ratingDialogContext;
            if (dialogContext != null && Navigator.of(dialogContext).canPop()) {
              Navigator.of(dialogContext).pop();
              _ratingDialogContext = null;
            }
            setState(() => _selectedRating = 0);
            CustomSnackBar.show(context, l10n.thanksForRating);
          } else if (state.reviewStatus == ProductReviewStatus.loginRequired) {
            CustomSnackBar.show(context, l10n.loginRequiredForRating);
          } else if (state.reviewStatus == ProductReviewStatus.failure) {
            CustomSnackBar.show(
              context,
              state.reviewError ?? l10n.unexpectedError,
            );
          }
        },
        builder: (context, state) {
          final variantState = state is ProductVariantSelected ? state : null;
          final product = variantState?.product ?? widget.product;
          final isWishlist = _effectiveWishlist(product, wishlistState);
          final viewData = ProductViewData.fromProduct(product, l10n);

          return ListView(
            padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
            children: [
              GallerySection(
                galleryImages: _galleryImages(product),
                isDark: isDark,
                isWishlist: isWishlist,
                wishlistLoading: _wishlistLoading,
                onToggleWishlist: () => _toggleWishlist(product),
              ),
              SizedBox(height: 20.h),
              ProductHeaderSection(
                product: product,
                viewData: viewData,
                isDark: isDark,
                onRatePressed: () => _showRatingDialog(product),
              ),
              if (product.brand != null) ...[
                SizedBox(height: 16.h),
                ProductBrandSummaryCard(product: product, isDark: isDark),
              ],

              if (variantState != null &&
                  (variantState.product.variants?.variantsBySize ?? [])
                      .isNotEmpty) ...[
                SizedBox(height: 16.h),
                ProductVariantsSection(
                  variantState: variantState,
                  isDark: isDark,
                  onSizeSelected: (size) =>
                      context.read<ProductsCubit>().selectSize(size),
                  onColorSelected: (color) =>
                      context.read<ProductsCubit>().selectColor(color),
                ),
              ],

              if (viewData.descriptionText.isNotEmpty) ...[
                SizedBox(height: 16.h),
                ProductSectionCard(
                  isDark: isDark,
                  title: l10n.productDescription,
                  icon: Icons.description_outlined,
                  child: Text(
                    viewData.descriptionText,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: isDark ? AppColors.offWhite : AppColors.black,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
              if (viewData.infoEntries.isNotEmpty) ...[
                SizedBox(height: 16.h),
                ProductInfoCard(
                  isDark: isDark,
                  sectionTitle: l10n.productInfo,
                  entries: viewData.infoEntries,
                ),
              ],
              SizedBox(height: 24.h),
              FilledButton.icon(
                onPressed: product.isSaleable
                    ? () => context.read<CartCubit>().addItem(
                        (variantState?.selectedColor?.variantId ?? product.id)
                            .toString(),
                        color: variantState?.selectedColor?.colorName ?? '',
                        size: variantState?.selectedSize?.sizeName ?? '',
                      )
                    : null,
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
          );
        },
      ),
    );
  }
}

class ProductRateButton extends StatelessWidget {
  const ProductRateButton({
    super.key,
    required this.product,
    required this.onPressed,
  });

  final ProductModel product;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return FilledButton.icon(
      onPressed: onPressed,
      icon: Icon(Icons.star_rate_outlined, size: 18.r),
      label: Text(l10n.submitRating),
      style: FilledButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        elevation: 0,
      ),
    );
  }
}

class ProductRatingCard extends StatelessWidget {
  const ProductRatingCard({
    super.key,
    required this.product,
    required this.isDark,
    required this.selectedRating,
    required this.titleController,
    required this.commentController,
    required this.isSubmitting,
    required this.onRatingChanged,
    required this.onSubmit,
  });

  final ProductModel product;
  final bool isDark;
  final int selectedRating;
  final TextEditingController titleController;
  final TextEditingController commentController;
  final bool isSubmitting;
  final ValueChanged<int> onRatingChanged;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final accent = isDark ? AppColors.goldLight : AppColors.burgundy;
    final hasRating = product.ratings.total > 0;
    final average = double.tryParse(product.ratings.average) ?? 0;
    final averageLabel = product.ratings.average.trim().isEmpty
        ? average.toStringAsFixed(1)
        : product.ratings.average.trim();
    final averageStars = average.round().clamp(0, 5).toInt();

    return Padding(
      padding: EdgeInsets.all(14.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasRating) ...[
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.black.withValues(alpha: 0.25)
                    : Colors.white,
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(color: accent.withValues(alpha: 0.12)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 54.r,
                    height: 54.r,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      averageLabel,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: accent,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RatingStars(
                          rating: averageStars,
                          enabled: false,
                          size: 22.r,
                          spacing: 0,
                          mainAxisAlignment: MainAxisAlignment.start,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          l10n.productRatingSummary(
                            averageLabel,
                            product.ratings.total,
                          ),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: isDark
                                ? AppColors.taupe
                                : AppColors.burgundy,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 18.h),
          ],
          Center(
            child: RatingStars(
              rating: selectedRating,
              enabled: !isSubmitting,
              onRatingChanged: onRatingChanged,
            ),
          ),
          SizedBox(height: 12.h),
          AppTextField(
            controller: commentController,
            label: l10n.ratingComment,
            hint: l10n.ratingCommentHint,
            enabled: !isSubmitting,
            maxLines: 4,
            textInputAction: TextInputAction.newline,
          ),
          SizedBox(height: 18.h),
          FilledButton(
            onPressed: isSubmitting ? null : onSubmit,
            style: FilledButton.styleFrom(
              minimumSize: Size(double.infinity, 50.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.r),
              ),
              elevation: 0,
            ),
            child: isSubmitting
                ? SpinKitFadingCircle(size: 20.r, color: AppColors.offWhite)
                : Text(l10n.submit),
          ),
        ],
      ),
    );
  }
}

class ProductVariantsSection extends StatelessWidget {
  const ProductVariantsSection({
    super.key,
    required this.variantState,
    required this.isDark,
    required this.onSizeSelected,
    required this.onColorSelected,
  });

  final ProductVariantSelected variantState;
  final bool isDark;
  final ValueChanged<VariantBySize> onSizeSelected;
  final ValueChanged<ColorVariant> onColorSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = isDark ? AppColors.goldLight : AppColors.burgundy;
    final sizes = variantState.product.variants!.variantsBySize;
    final selectedSize = variantState.selectedSize;
    final selectedColor = variantState.selectedColor;
    final availableColors = variantState.availableColors;

    return ProductSectionCardShell(
      isDark: isDark,
      title: 'المقاس واللون',
      icon: Icons.style_outlined,
      child: Padding(
        padding: EdgeInsets.all(14.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Size label ──────────────────────────────────────────────
            Text(
              'المقاس',
              style: theme.textTheme.bodySmall?.copyWith(
                color: isDark ? AppColors.taupe : AppColors.burgundy,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 10.h),

            // ── Size chips ──────────────────────────────────────────────
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: sizes.map((size) {
                final isSelected = selectedSize?.sizeId == size.sizeId;
                return GestureDetector(
                  onTap: () => onSizeSelected(size),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? accent
                          : accent.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: isSelected
                            ? accent
                            : accent.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      size.sizeName,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isSelected
                            ? Colors.white
                            : (isDark ? AppColors.offWhite : AppColors.black),
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            // ── Color label + chips ─────────────────────────────────────
            if (availableColors.isNotEmpty) ...[
              SizedBox(height: 16.h),
              Text(
                selectedColor != null
                    ? 'اللون: ${selectedColor.colorName}'
                    : 'اللون',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isDark ? AppColors.taupe : AppColors.burgundy,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 10.h),
              Wrap(
                spacing: 10.w,
                runSpacing: 10.h,
                children: availableColors.map((color) {
                  final isSelected =
                      selectedColor?.colorId == color.colorId &&
                      selectedColor?.parentSizeId == color.parentSizeId;
                  final hasHex = color.hex != null && color.hex!.isNotEmpty;
                  final bgColor = hasHex
                      ? Color(
                          int.parse('0xFF${color.hex!.replaceAll('#', '')}'),
                        )
                      : accent.withValues(alpha: 0.15);

                  return GestureDetector(
                    onTap: () => onColorSelected(color),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: hasHex ? 36.r : null,
                      height: hasHex ? 36.r : null,
                      padding: hasHex
                          ? EdgeInsets.zero
                          : EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 8.h,
                            ),
                      decoration: BoxDecoration(
                        color: bgColor,
                        shape: hasHex ? BoxShape.circle : BoxShape.rectangle,
                        borderRadius: hasHex
                            ? null
                            : BorderRadius.circular(10.r),
                        border: Border.all(
                          color: isSelected
                              ? accent
                              : accent.withValues(alpha: 0.3),
                          width: isSelected ? 2.5 : 1,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: accent.withValues(alpha: 0.35),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: hasHex
                          ? (isSelected
                                ? Icon(
                                    Icons.check,
                                    size: 18.r,
                                    color: Colors.white,
                                  )
                                : null)
                          : Text(
                              color.colorName,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: isDark
                                    ? AppColors.offWhite
                                    : AppColors.black,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                              ),
                            ),
                    ),
                  );
                }).toList(),
              ),
            ],

            if (selectedColor != null) ...[
              SizedBox(height: 12.h),
              Row(
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 14.r,
                    color: isDark ? AppColors.taupe : AppColors.burgundy,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    'المخزون: ${selectedColor.stockQty} قطعة',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark ? AppColors.taupe : AppColors.burgundy,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class ProductViewData {
  const ProductViewData({
    required this.descriptionText,
    required this.regularPrice,
    required this.salePrice,
    required this.hasSalePrice,
    required this.badges,
    required this.infoEntries,
  });

  final String descriptionText;
  final String? regularPrice;
  final String? salePrice;
  final bool hasSalePrice;
  final List<ProductBadgeData> badges;
  final List<ProductSpecEntry> infoEntries;

  static ProductViewData fromProduct(
    ProductModel product,
    AppLocalizations l10n,
  ) {
    final descriptionText = htmlToPlainText(product.description);
    final regularPrice = _displayPrice(
      product.prices.regular.formattedPrice,
      product.prices.regular.price,
    );
    final salePrice = _displayPrice(
      product.prices.final_?.formattedPrice,
      product.prices.final_?.price,
    );
    final hasSalePrice =
        product.onSale &&
        salePrice != null &&
        salePrice.isNotEmpty &&
        salePrice != regularPrice;

    final badges = <ProductBadgeData>[
      if (product.isNew)
        ProductBadgeData(
          label: l10n.productNew,
          icon: Icons.fiber_new_rounded,
          color: AppColors.goldDark,
        ),
      if (product.isFeatured)
        ProductBadgeData(
          label: l10n.productFeatured,
          icon: Icons.star_outline_rounded,
          color: AppColors.burgundy,
        ),
      if (product.onSale)
        ProductBadgeData(
          label: l10n.productOnSale,
          icon: Icons.local_offer_outlined,
          color: AppColors.red,
        ),
    ];

    final infoEntries = <ProductSpecEntry>[
      ProductSpecEntry(
        icon: product.isSaleable
            ? Icons.check_circle_outline_rounded
            : Icons.remove_shopping_cart_outlined,
        label: l10n.productAvailability,
        value: product.isSaleable
            ? l10n.productAvailable
            : l10n.productOutOfStock,
      ),
      if (_hasText(product.minPrice))
        ProductSpecEntry(
          icon: Icons.sell_outlined,
          label: l10n.productMinPriceLabel,
          value: product.minPrice!.trim(),
        ),
      if (product.variants?.stockQty != null)
        ProductSpecEntry(
          icon: Icons.inventory_2_outlined,
          label: 'Stock quantity',
          value: product.variants!.stockQty.toString(),
        ),
      if (_hasText(product.variants?.measurementType))
        ProductSpecEntry(
          icon: Icons.straighten_outlined,
          label: 'Measurement type',
          value: product.variants!.measurementType!.trim(),
        ),
      if ((product.variants?.measurementTypes ?? []).isNotEmpty)
        ProductSpecEntry(
          icon: Icons.format_list_bulleted_rounded,
          label: 'Measurement types',
          value: product.variants!.measurementTypes.join(', '),
        ),
      if (product.reviews.total > 0)
        ProductSpecEntry(
          icon: Icons.rate_review_outlined,
          label: l10n.productReviews,
          value: l10n.productReviewsCount(product.reviews.total),
        ),
      if (_hasText(product.urlKey))
        ProductSpecEntry(
          icon: Icons.link_outlined,
          label: l10n.productUrlKey,
          value: product.urlKey.trim(),
        ),
    ];

    return ProductViewData(
      descriptionText: descriptionText,
      regularPrice: regularPrice,
      salePrice: salePrice,
      hasSalePrice: hasSalePrice,
      badges: badges,
      infoEntries: infoEntries,
    );
  }

  static bool _hasText(String? value) =>
      value != null && value.trim().isNotEmpty;

  static String? _displayPrice(String? formatted, String? raw) {
    if (_hasText(formatted)) return formatted!.trim();
    if (_hasText(raw)) return raw!.trim();
    return null;
  }
}

class ProductBrandSummaryCard extends StatelessWidget {
  const ProductBrandSummaryCard({
    super.key,
    required this.product,
    required this.isDark,
  });

  final ProductModel product;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final brand = product.brand;
    if (brand == null) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final accent = isDark ? AppColors.goldLight : AppColors.burgundy;
    final hasBanner = ProductViewData._hasText(brand.banner);
    final hasLogo = ProductViewData._hasText(brand.logo);

    return ProductSectionCardShell(
      isDark: isDark,
      title: 'Brand',
      icon: Icons.storefront_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasBanner)
            SizedBox(
              height: 112.h,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(14.r)),
                child: CustomNetworkImage(
                  imageUrl: brand.banner,
                  defaultIcon: Icons.store_rounded,
                ),
              ),
            ),
          Padding(
            padding: EdgeInsets.all(14.w),
            child: Row(
              children: [
                Container(
                  width: 58.r,
                  height: 58.r,
                  decoration: BoxDecoration(
                    color: hasLogo
                        ? Colors.white
                        : accent.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: accent.withValues(alpha: 0.12)),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: hasLogo
                      ? CustomNetworkImage(
                          imageUrl: brand.logo,
                          defaultIcon: Icons.store_rounded,
                        )
                      : Icon(Icons.store_rounded, size: 30.r, color: accent),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        brand.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: isDark ? AppColors.offWhite : AppColors.black,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      if (brand.isActive != null) ...[
                        SizedBox(height: 4.h),
                        Text(
                          brand.isActive! ? 'Active brand' : 'Inactive brand',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isDark
                                ? AppColors.taupe
                                : AppColors.burgundy,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProductBadgeData {
  const ProductBadgeData({
    required this.label,
    required this.icon,
    required this.color,
  });

  final String label;
  final IconData icon;
  final Color color;
}

class ProductSpecEntry {
  const ProductSpecEntry({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;
}

class GallerySection extends StatelessWidget {
  const GallerySection({
    super.key,
    required this.galleryImages,
    required this.isDark,
    required this.isWishlist,
    required this.wishlistLoading,
    required this.onToggleWishlist,
  });

  final List<ProductImage> galleryImages;
  final bool isDark;
  final bool isWishlist;
  final bool wishlistLoading;
  final VoidCallback onToggleWishlist;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        if (galleryImages.isNotEmpty)
          ProductGalleryCard(imageUrls: galleryImages)
        else
          Container(
            width: double.infinity,
            height: 220.h,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSecondaryFixed,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(
              Icons.inventory_2_outlined,
              size: 64.r,
              color: theme.colorScheme.primary.withValues(alpha: 0.5),
            ),
          ),
        Positioned(
          top: 8.h,
          right: 8.w,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: wishlistLoading ? null : onToggleWishlist,
              borderRadius: BorderRadius.circular(20.r),
              child: Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 6,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: wishlistLoading
                    ? SizedBox(
                        width: 22.r,
                        height: 22.r,
                        child: SpinKitFadingCircle(
                          size: 20.r,
                          color: AppColors.offWhite,
                        ),
                      )
                    : WishlistIcon(isActive: isWishlist),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ProductHeaderSection extends StatelessWidget {
  const ProductHeaderSection({
    super.key,
    required this.product,
    required this.viewData,
    required this.isDark,
    required this.onRatePressed,
  });

  final ProductModel product;
  final ProductViewData viewData;
  final bool isDark;
  final VoidCallback onRatePressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final accent = isDark ? AppColors.goldLight : AppColors.burgundy;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.burgundy.withValues(alpha: 0.15)
            : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: accent.withValues(alpha: 0.12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (viewData.badges.isNotEmpty) ...[
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: viewData.badges
                  .map((badge) => ProductBadgeChip(badge: badge))
                  .toList(),
            ),
            SizedBox(height: 12.h),
          ],
          Text(
            product.name,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: isDark ? AppColors.offWhite : AppColors.black,
              fontWeight: FontWeight.w800,
              height: 1.25,
            ),
          ),
          if (ProductViewData._hasText(product.sku)) ...[
            SizedBox(height: 10.h),
            Row(
              children: [
                Icon(
                  Icons.qr_code_2_outlined,
                  size: 16.r,
                  color: isDark ? AppColors.taupe : AppColors.burgundy,
                ),
                SizedBox(width: 6.w),
                Text(
                  '${l10n.productSku}: ${product.sku.trim()}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isDark ? AppColors.taupe : AppColors.burgundy,
                  ),
                ),
              ],
            ),
          ],
          if (viewData.regularPrice != null || viewData.salePrice != null) ...[
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ProductPriceBlock(viewData: viewData, isDark: isDark),
                ProductRateButton(product: product, onPressed: onRatePressed),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class ProductBadgeChip extends StatelessWidget {
  const ProductBadgeChip({super.key, required this.badge});

  final ProductBadgeData badge;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: badge.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: badge.color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(badge.icon, size: 12.r, color: badge.color),
          SizedBox(width: 4.w),
          Text(
            badge.label,
            style: TextStyle(
              color: badge.color,
              fontSize: 8.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class ProductPriceBlock extends StatelessWidget {
  const ProductPriceBlock({
    super.key,
    required this.viewData,
    required this.isDark,
  });

  final ProductViewData viewData;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = isDark ? AppColors.goldLight : AppColors.burgundy;

    if (viewData.hasSalePrice) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            viewData.salePrice!,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: accent,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(width: 12.w),
          Text(
            viewData.regularPrice ?? '',
            style: theme.textTheme.titleMedium?.copyWith(
              decoration: TextDecoration.lineThrough,
              color: isDark
                  ? AppColors.taupe.withValues(alpha: 0.8)
                  : AppColors.lightGray,
            ),
          ),
        ],
      );
    }

    final price = viewData.regularPrice ?? viewData.salePrice;
    if (price == null) return const SizedBox.shrink();

    return Text(
      price,
      style: theme.textTheme.headlineSmall?.copyWith(
        color: accent,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class ProductSectionCard extends StatelessWidget {
  const ProductSectionCard({
    super.key,
    required this.isDark,
    required this.title,
    required this.icon,
    required this.child,
  });

  final bool isDark;
  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = isDark ? AppColors.goldLight : AppColors.burgundy;

    return ProductSectionCardShell(
      isDark: isDark,
      title: title,
      icon: icon,
      titleStyle: theme.textTheme.titleMedium?.copyWith(
        color: accent,
        fontWeight: FontWeight.w700,
      ),
      child: child,
    );
  }
}

class ProductInfoCard extends StatelessWidget {
  const ProductInfoCard({
    super.key,
    required this.isDark,
    required this.sectionTitle,
    required this.entries,
  });

  final bool isDark;
  final String sectionTitle;
  final List<ProductSpecEntry> entries;

  @override
  Widget build(BuildContext context) {
    return ProductSectionCardShell(
      isDark: isDark,
      title: sectionTitle,
      icon: Icons.info_outline_rounded,
      child: Column(
        children: [
          for (var i = 0; i < entries.length; i++)
            ProductSpecListTile(
              icon: entries[i].icon,
              label: entries[i].label,
              value: entries[i].value,
              isDark: isDark,
              showDivider: i < entries.length - 1,
            ),
        ],
      ),
    );
  }
}

class ProductSectionCardShell extends StatelessWidget {
  const ProductSectionCardShell({
    super.key,
    required this.isDark,
    required this.title,
    required this.icon,
    required this.child,
    this.titleStyle,
  });

  final bool isDark;
  final String title;
  final IconData icon;
  final Widget child;
  final TextStyle? titleStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = isDark ? AppColors.goldLight : AppColors.burgundy;
    final listBackground = isDark
        ? AppColors.burgundy.withValues(alpha: 0.18)
        : AppColors.burgundy.withValues(alpha: 0.05);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.burgundy.withValues(alpha: 0.12)
            : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: accent.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(icon, size: 20.r, color: accent),
              ),
              SizedBox(width: 10.w),
              Text(
                title,
                style:
                    titleStyle ??
                    theme.textTheme.titleMedium?.copyWith(
                      color: accent,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: listBackground,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}

class ProductSpecListTile extends StatelessWidget {
  const ProductSpecListTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.isDark,
    required this.showDivider,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool isDark;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = isDark ? AppColors.goldLight : AppColors.burgundy;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 44.r,
                height: 44.r,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.black.withValues(alpha: 0.35)
                      : Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(icon, size: 22.r, color: accent),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isDark ? AppColors.taupe : AppColors.burgundy,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      value,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: isDark ? AppColors.offWhite : AppColors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            indent: 72.w,
            endIndent: 14.w,
            color: accent.withValues(alpha: 0.12),
          ),
      ],
    );
  }
}
