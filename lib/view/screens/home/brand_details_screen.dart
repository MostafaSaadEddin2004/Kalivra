import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/controller/blocs/cubit/brand_cubit/brand_cubit.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/core/html_utils.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/model/brand/brand_model.dart';
import 'package:kalivra/model/product/product_model.dart';
import 'package:kalivra/view/widgets/cards/custom_network_image.dart';
import 'package:kalivra/view/widgets/cards/product_card.dart';
import 'package:kalivra/view/widgets/profile_page/screen_app_bar.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BrandDetailsScreen extends StatelessWidget {
  const BrandDetailsScreen({super.key, required this.brand});

  final BrandModel brand;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isDark = theme.brightness == Brightness.dark;
    final primary = theme.colorScheme.primary;
    final surfaceColor = isDark
        ? AppColors.burgundy.withValues(alpha: 0.15)
        : AppColors.burgundy.withValues(alpha: 0.06);

    return BlocProvider(
      create: (_) => BrandCubit()..fetchProductsByBrandId(brand.id),
      child: Scaffold(
        appBar: ScreenAppBar(title: brand.name),
        body: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
              sliver: SliverToBoxAdapter(
                child: _BrandDetailsContent(
                  brand: brand,
                  primary: primary,
                  surfaceColor: surfaceColor,
                  isDark: isDark,
                ),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 20.h)),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              sliver: SliverToBoxAdapter(
                child: Text(
                  l10n.products,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            BlocBuilder<BrandCubit, BrandState>(
              builder: (context, state) {
                switch (state) {
                  case BrandProductsLoading():
                    return _ProductsGridSliver(
                      products: _placeholderProducts(),
                      isLoading: true,
                    );
                  case BrandProductFetched():
                    final products = state.brandProducts;
                    if (products.isEmpty) {
                      return _MessageSliver(message: l10n.noProductsForBrand);
                    }
                    return _ProductsGridSliver(products: products);
                  case BrandProductsFailure():
                    return _MessageSliver(message: state.message);
                  default:
                    return const SliverToBoxAdapter(child: SizedBox.shrink());
                }
              },
            ),
            SliverToBoxAdapter(child: SizedBox(height: 32.h)),
          ],
        ),
      ),
    );
  }

  List<ProductModel> _placeholderProducts() {
    return List.generate(
      4,
      (_) => ProductModel(
        id: 0,
        sku: 'sku',
        name: 'name',
        urlKey: 'urlKey',
        images: const [],
        isNew: false,
        isFeatured: false,
        onSale: false,
        isSaleable: false,
        isWishlist: false,
        prices: ProductPrices(regular: PriceDetail(price: '')),
        ratings: ProductRatings(average: '', total: 1),
        reviews: ProductReviews(total: 1),
      ),
    );
  }
}

class _BrandDetailsContent extends StatelessWidget {
  const _BrandDetailsContent({
    required this.brand,
    required this.primary,
    required this.surfaceColor,
    required this.isDark,
  });

  final BrandModel brand;
  final Color primary;
  final Color surfaceColor;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final description = htmlToPlainText(brand.description);
    final contactEntries = <_BrandInfoEntry>[
      if (_hasItems(brand.phoneNumbers))
        _BrandInfoEntry(
          icon: Icons.phone_outlined,
          label: 'Phone numbers',
          value: brand.phoneNumbers.join('\n'),
        ),
      if (_hasText(brand.email))
        _BrandInfoEntry(
          icon: Icons.email_outlined,
          label: 'Email',
          value: brand.email!.trim(),
        ),
      if (_hasText(brand.workingHours))
        _BrandInfoEntry(
          icon: Icons.schedule_outlined,
          label: 'Working hours',
          value: brand.workingHours!.trim(),
        ),
    ];
    final locationEntries = <_BrandInfoEntry>[
      if (_hasText(brand.country))
        _BrandInfoEntry(
          icon: Icons.public_outlined,
          label: 'Country',
          value: brand.country!.trim(),
        ),
      if (_hasText(brand.city))
        _BrandInfoEntry(
          icon: Icons.location_city_outlined,
          label: 'City',
          value: brand.city!.trim(),
        ),
      if (_hasText(brand.address))
        _BrandInfoEntry(
          icon: Icons.place_outlined,
          label: 'Address',
          value: brand.address!.trim(),
        ),
    ];
    final onlineEntries = <_BrandInfoEntry>[
      if (_hasText(brand.website))
        _BrandInfoEntry(
          icon: Icons.language_outlined,
          label: 'Website',
          value: brand.website!.trim(),
        ),
      for (final link in brand.socialLinks)
        if (_hasText(link.url))
          _BrandInfoEntry(
            icon: Icons.alternate_email_rounded,
            label: _hasText(link.platform) ? link.platform!.trim() : 'Social',
            value: link.url.trim(),
          ),
    ];
    final detailEntries = <_BrandInfoEntry>[
      if (brand.isActive != null)
        _BrandInfoEntry(
          icon: brand.isActive!
              ? Icons.check_circle_outline_rounded
              : Icons.pause_circle_outline_rounded,
          label: 'Status',
          value: brand.isActive! ? 'Active' : 'Inactive',
        ),
      if (brand.sortOrder != null)
        _BrandInfoEntry(
          icon: Icons.sort_rounded,
          label: 'Sort order',
          value: brand.sortOrder.toString(),
        ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _BrandHeaderCard(
          brand: brand,
          primary: primary,
          surfaceColor: surfaceColor,
          isDark: isDark,
        ),
        if (description.isNotEmpty) ...[
          SizedBox(height: 16.h),
          _BrandSectionCard(
            isDark: isDark,
            title: 'About',
            icon: Icons.notes_rounded,
            child: Padding(
              padding: EdgeInsets.all(14.w),
              child: Text(
                description,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: isDark ? AppColors.offWhite : AppColors.black,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
        if (contactEntries.isNotEmpty) ...[
          SizedBox(height: 16.h),
          _BrandInfoSection(
            title: 'Contact',
            icon: Icons.contact_phone_outlined,
            entries: contactEntries,
            isDark: isDark,
          ),
        ],
        if (locationEntries.isNotEmpty) ...[
          SizedBox(height: 16.h),
          _BrandInfoSection(
            title: 'Location',
            icon: Icons.map_outlined,
            entries: locationEntries,
            isDark: isDark,
          ),
        ],
        if (onlineEntries.isNotEmpty) ...[
          SizedBox(height: 16.h),
          _BrandInfoSection(
            title: 'Online presence',
            icon: Icons.hub_outlined,
            entries: onlineEntries,
            isDark: isDark,
          ),
        ],
        if (detailEntries.isNotEmpty) ...[
          SizedBox(height: 16.h),
          _BrandInfoSection(
            title: 'Brand details',
            icon: Icons.info_outline_rounded,
            entries: detailEntries,
            isDark: isDark,
          ),
        ],
        if (brand.gallery.isNotEmpty) ...[
          SizedBox(height: 16.h),
          _BrandGalleryCard(brand: brand, isDark: isDark),
        ],
      ],
    );
  }

  bool _hasText(String? value) => value != null && value.trim().isNotEmpty;

  bool _hasItems(List<String> values) =>
      values.any((value) => value.trim().isNotEmpty);
}

class _BrandHeaderCard extends StatelessWidget {
  const _BrandHeaderCard({
    required this.brand,
    required this.primary,
    required this.surfaceColor,
    required this.isDark,
  });

  final BrandModel brand;
  final Color primary;
  final Color surfaceColor;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasLogo = _hasText(brand.logo);
    final hasBanner = _hasText(brand.banner);

    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          if (hasBanner)
            SizedBox(
              height: 150.h,
              width: double.infinity,
              child: CustomNetworkImage(
                imageUrl: brand.banner,
                defaultIcon: Icons.store_rounded,
              ),
            ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              20.w,
              hasBanner ? 0 : 20.h,
              20.w,
              20.h,
            ),
            child: Column(
              children: [
                Transform.translate(
                  offset: hasBanner ? Offset(0, -30.h) : Offset.zero,
                  child: Container(
                    height: 84.r,
                    width: 84.r,
                    padding: hasLogo ? EdgeInsets.zero : EdgeInsets.all(18.r),
                    decoration: BoxDecoration(
                      color: hasLogo
                          ? Colors.white
                          : primary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: primary.withValues(alpha: hasLogo ? 0.12 : 0),
                      ),
                      boxShadow: hasBanner
                          ? [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.12),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : null,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14.r),
                      child: hasLogo
                          ? CustomNetworkImage(
                              imageUrl: brand.logo,
                              defaultIcon: Icons.store_rounded,
                            )
                          : Icon(
                              Icons.store_rounded,
                              size: 44.r,
                              color: primary.withValues(alpha: 0.8),
                            ),
                    ),
                  ),
                ),
                SizedBox(height: hasBanner ? 0 : 16.h),
                Text(
                  brand.name,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: isDark ? AppColors.offWhite : AppColors.black,
                    fontWeight: FontWeight.w800,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _hasText(String? value) => value != null && value.trim().isNotEmpty;
}

class _BrandSectionCard extends StatelessWidget {
  const _BrandSectionCard({
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
    final background = isDark
        ? AppColors.burgundy.withValues(alpha: 0.12)
        : Colors.white;
    final innerBackground = isDark
        ? AppColors.burgundy.withValues(alpha: 0.18)
        : AppColors.burgundy.withValues(alpha: 0.05);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
      decoration: BoxDecoration(
        color: background,
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
                style: theme.textTheme.titleMedium?.copyWith(
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
              color: innerBackground,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}

class _BrandInfoSection extends StatelessWidget {
  const _BrandInfoSection({
    required this.title,
    required this.icon,
    required this.entries,
    required this.isDark,
  });

  final String title;
  final IconData icon;
  final List<_BrandInfoEntry> entries;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return _BrandSectionCard(
      isDark: isDark,
      title: title,
      icon: icon,
      child: Column(
        children: [
          for (var i = 0; i < entries.length; i++)
            _BrandInfoTile(
              entry: entries[i],
              isDark: isDark,
              showDivider: i < entries.length - 1,
            ),
        ],
      ),
    );
  }
}

class _BrandInfoTile extends StatelessWidget {
  const _BrandInfoTile({
    required this.entry,
    required this.isDark,
    required this.showDivider,
  });

  final _BrandInfoEntry entry;
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
                width: 42.r,
                height: 42.r,
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
                child: Icon(entry.icon, size: 21.r, color: accent),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.label,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isDark ? AppColors.taupe : AppColors.burgundy,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      entry.value,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: isDark ? AppColors.offWhite : AppColors.black,
                        fontWeight: FontWeight.w700,
                        height: 1.35,
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
            indent: 70.w,
            endIndent: 14.w,
            color: accent.withValues(alpha: 0.12),
          ),
      ],
    );
  }
}

class _BrandGalleryCard extends StatelessWidget {
  const _BrandGalleryCard({required this.brand, required this.isDark});

  final BrandModel brand;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return _BrandSectionCard(
      isDark: isDark,
      title: 'Gallery',
      icon: Icons.photo_library_outlined,
      child: SizedBox(
        height: 116.h,
        child: ListView.separated(
          padding: EdgeInsets.all(12.w),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: SizedBox(
                width: 128.w,
                height: 92.h,
                child: CustomNetworkImage(
                  imageUrl: brand.gallery[index],
                  defaultIcon: Icons.image_outlined,
                ),
              ),
            );
          },
          separatorBuilder: (_, _) => SizedBox(width: 10.w),
          itemCount: brand.gallery.length,
        ),
      ),
    );
  }
}

class _BrandInfoEntry {
  const _BrandInfoEntry({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;
}

class _ProductsGridSliver extends StatelessWidget {
  const _ProductsGridSliver({required this.products, this.isLoading = false});

  final List<ProductModel> products;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16.h,
          crossAxisSpacing: 16.w,
          childAspectRatio: 0.68,
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          final card = ProductCard(product: products[index]);
          return isLoading ? Skeletonizer(child: card) : card;
        }, childCount: products.length),
      ),
    );
  }
}

class _MessageSliver extends StatelessWidget {
  const _MessageSliver({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ),
    );
  }
}
