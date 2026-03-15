import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/controller/blocs/cubit/cart_cubit/cart_cubit.dart';
import 'package:kalivra/controller/blocs/cubit/products_cubit/products_cubit.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/core/network/api_error_handler.dart';
import 'package:kalivra/model/product/product_model.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/view/widgets/cards/product_card.dart';
import 'package:kalivra/view/widgets/drawer/drawer_screen_app_bar.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AllSaleProductsScreen extends StatefulWidget {
  const AllSaleProductsScreen({super.key});

  @override
  State<AllSaleProductsScreen> createState() => _AllSaleProductsScreenState();
}

class _AllSaleProductsScreenState extends State<AllSaleProductsScreen> {
  @override
  void initState() {
    super.initState();
    if (context.read<ProductsCubit>().state.products.isEmpty) {
      context.read<ProductsCubit>().loadAll();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: DrawerScreenAppBar(title: l10n.offers),
      body: BlocConsumer<ProductsCubit, ProductsState>(
        listener: (context, state) {
          if (state.hasError) {
            ApiErrorHandler.showSnackBar(context, state.error!,
                fallbackMessage: l10n.loadOffersFailed);
          }
        },
        builder: (context, state) {
          final allProducts = state.products;
          final saleProducts =
              allProducts.where((p) => p.salePrice != null).toList();
          final isLoading = state.isLoading && allProducts.isEmpty;

          if (isLoading) {
            return Skeletonizer(
              enabled: true,
              child: CustomScrollView(
                slivers: [
                  _buildSaleBanner(context, theme, isDark),
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
                    sliver: SliverGrid(
                      gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16.h,
                        crossAxisSpacing: 16.w,
                        childAspectRatio: 0.68,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => ProductCard(
                          product: ProductModel(
                            id: '$index',
                            unit: '',
                            name: l10n.product,
                            categoryId: '1',
                            price: 0,
                            quantity: 1,
                          ),
                          onTap: () {},
                          onAddToCart: () {},
                        ),
                        childCount: 6,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          if (saleProducts.isEmpty) {
            return Column(
              children: [
                _buildSaleBanner(context, theme, isDark),
                Expanded(
                  child: Center(
                    child: Text(
                      l10n.noOffers,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurface
                            .withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          return CustomScrollView(
            slivers: [
              _buildSaleBanner(context, theme, isDark),
              SliverPadding(
                padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16.h,
                    crossAxisSpacing: 16.w,
                    childAspectRatio: 0.68,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final product = saleProducts[index];
                      return ProductCard(
                        product: product,
                        onTap: () => context.push(
                            AppRoutes.productDetails, extra: product),
                        onAddToCart: () => context.read<CartCubit>().addItem(product),
                      );
                    },
                    childCount: saleProducts.length,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSaleBanner(BuildContext context, ThemeData theme, bool isDark) {
    return SliverToBoxAdapter(
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [
                    AppColors.goldDark.withValues(alpha: 0.35),
                    AppColors.goldLight.withValues(alpha: 0.2),
                  ]
                : [
                    AppColors.goldDark.withValues(alpha: 0.15),
                    AppColors.goldLight.withValues(alpha: 0.12),
                  ],
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
          ),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Icon(
              Icons.local_offer_rounded,
              size: 22.r,
              color: isDark ? AppColors.goldLight : AppColors.goldDark,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                AppLocalizations.of(context)!.allSaleProducts,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: isDark ? AppColors.offWhite : AppColors.burgundy,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}