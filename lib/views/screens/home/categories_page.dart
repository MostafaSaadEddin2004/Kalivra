import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/controllers/blocs/cubit/cart_cubit/cart_cubit.dart';
import 'package:kalivra/controllers/blocs/cubit/products_cubit/products_cubit.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/core/network/api_error_handler.dart';
import 'package:kalivra/models/category_model.dart';
import 'package:kalivra/models/product_model.dart';
import 'package:kalivra/views/widgets/cards/product_card.dart';
import 'package:kalivra/views/widgets/category/category_tab_bar.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  static const String _allCategoryId = 'all';
  static const CategoryModel _allCategory = CategoryModel(
    id: _allCategoryId,
    name: 'الكل',
    icon: Icons.apps_rounded,
  );

  late String _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _selectedCategoryId = _allCategoryId;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDark = theme.brightness == Brightness.dark;

    return BlocConsumer<ProductsCubit, ProductsState>(
      listener: (context, state) {
        if (state.hasError) {
          ApiErrorHandler.showSnackBar(
            context,
            state.error!,
            fallbackMessage: 'فشل تحميل التصنيفات أو المنتجات',
          );
        }
      },
      builder: (context, state) {
        final categories = [_allCategory, ...state.categories];
        final allProducts = state.products;
        final filteredProducts = _selectedCategoryId == _allCategoryId
            ? allProducts
            : allProducts
                  .where((p) => p.categoryId == _selectedCategoryId)
                  .toList();
        final isLoading = state.isLoading;
        final categoryName = _selectedCategoryId == _allCategoryId
            ? 'جميع المنتجات'
            : categories
                  .firstWhere(
                    (c) => c.id == _selectedCategoryId,
                    orElse: () => _allCategory,
                  )
                  .name;

        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: SizedBox(height: 8.h)),
            SliverToBoxAdapter(
              child: isLoading && state.categories.isEmpty
                  ? Skeletonizer(
                      enabled: true,
                      child: CategoryTabBar(
                        categories: [_allCategory],
                        selectedId: _selectedCategoryId,
                        onSelected: (_) {},
                      ),
                    )
                  : CategoryTabBar(
                      categories: categories,
                      selectedId: _selectedCategoryId,
                      onSelected: (id) =>
                          setState(() => _selectedCategoryId = id),
                    ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 16.h)),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  children: [
                    Text(categoryName, style: textTheme.titleMedium),
                    SizedBox(width: 8.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.onSecondaryFixed,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        '${filteredProducts.length}',
                        style: textTheme.labelMedium?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 12.h)),
            isLoading && allProducts.isEmpty
                ? SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12.h,
                        crossAxisSpacing: 12.w,
                        childAspectRatio: 0.72,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => Skeletonizer(
                          enabled: true,
                          child: ProductCard(
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
                        ),
                        childCount: 6,
                      ),
                    ),
                  )
                : filteredProducts.isEmpty
                ? SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.category_outlined,
                            size: 64.r,
                            color: isDark
                                ? AppColors.taupe
                                : AppColors.burgundy.withValues(alpha: 0.6),
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'لا توجد منتجات في هذا التصنيف',
                            style:theme.textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ),
                  )
                : SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12.h,
                        crossAxisSpacing: 12.w,
                        childAspectRatio: 0.72,
                      ),
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final product = filteredProducts[index];
                        return ProductCard(
                          product: product,
                          onTap: () => context.push(
                            AppRoutes.productDetails,
                            extra: product,
                          ),
                          onAddToCart: () {
                            context.read<CartCubit>().addItem(product);
                          },
                        );
                      }, childCount: filteredProducts.length),
                    ),
                  ),
            SliverToBoxAdapter(child: SizedBox(height: 24.h)),
          ],
        );
      },
    );
  }
}
