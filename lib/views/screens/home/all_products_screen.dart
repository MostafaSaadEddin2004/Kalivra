import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/controllers/blocs/cubit/cart_cubit/cart_cubit.dart';
import 'package:kalivra/controllers/blocs/cubit/products_cubit/products_cubit.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/core/network/api_error_handler.dart';
import 'package:kalivra/models/product_model.dart';
import 'package:kalivra/views/widgets/cards/product_card.dart';
import 'package:kalivra/views/widgets/drawer/drawer_screen_app_bar.dart';
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

    return Scaffold(
      appBar: const DrawerScreenAppBar(title: 'المنتجات'),
      body: BlocConsumer<ProductsCubit, ProductsState>(
        listener: (context, state) {
          if (state.hasError) {
            ApiErrorHandler.showSnackBar(context, state.error!,
                fallbackMessage: 'فشل تحميل المنتجات');
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
                            name: 'منتج',
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
                'لا توجد منتجات',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            );
          }

          void addToCart(ProductModel product) {
            context.read<CartCubit>().addItem(product);
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
                        onAddToCart: () => addToCart(product),
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
