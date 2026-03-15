import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/controller/blocs/cubit/cart_cubit/cart_cubit.dart';
import 'package:kalivra/controller/blocs/cubit/products_cubit/products_cubit.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/core/network/api_error_handler.dart';
import 'package:kalivra/model/product/product_model.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/view/widgets/cards/product_card.dart';
import 'package:kalivra/view/widgets/drawer/drawer_screen_app_bar.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AllProductsScreen extends StatefulWidget {
  const AllProductsScreen({super.key});

  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
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
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: DrawerScreenAppBar(title: l10n.products),
      body: BlocConsumer<ProductsCubit, ProductsState>(
        listener: (context, state) {
          if (state.hasError) {
            ApiErrorHandler.showSnackBar(context, state.error!,
                fallbackMessage: l10n.loadProductsFailed);
          }
        },
        builder: (context, state) {
          final products = state.products;
          final isLoading = state.isLoading && products.isEmpty;

          if (isLoading) {
            return Skeletonizer(
              enabled: true,
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 24.h),
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
          if (products.isEmpty) {
            return Center(
              child: Text(
                l10n.noProducts,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            );
          }
          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 24.h),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16.h,
                    crossAxisSpacing: 16.w,
                    childAspectRatio: 0.68,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final product = products[index];
                      return ProductCard(
                        product: product,
                        onTap: () =>
                            context.push(AppRoutes.productDetails, extra: product),
                        onAddToCart: () => context.read<CartCubit>().addItem(product),
                      );
                    },
                    childCount: products.length,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}