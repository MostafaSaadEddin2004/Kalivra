import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/controller/blocs/cubit/categories_cubit/categories_cubit.dart';
import 'package:kalivra/controller/blocs/cubit/products_cubit/products_cubit.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/model/product/product_model.dart';
import 'package:kalivra/view/widgets/cards/product_card.dart';
import 'package:kalivra/view/widgets/category/category_tab_bar.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  String categoryName = '';
  int productsCount = 0;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDark = theme.brightness == Brightness.dark;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: SizedBox(height: 8.h)),
        SliverToBoxAdapter(child: CategoryTabBar()),
        SliverToBoxAdapter(child: SizedBox(height: 16.h)),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                BlocConsumer<CategoriesCubit, CategoriesState>(
                  bloc: CategoriesCubit()..loadCategories(),
                  listener: (context, state) {
                    switch (state) {
                      case CategoriesLoading():
                        categoryName = '';
                      case CategoriesLoaded():
                        categoryName = state.categories
                            .firstWhere(
                              (category) =>
                                  category.id ==
                                  CategoriesCubit.currentCategoryId,
                            )
                            .name;
                        final p = state.categories.singleWhere(
                          (category) =>
                              category.id == CategoriesCubit.currentCategoryId,
                        );
                        productsCount = p.productCount ?? 0;
                      default:
                        categoryName = '';
                    }
                  },
                  builder: (_, _) {
                    return Text(categoryName, style: textTheme.titleMedium);
                  },
                ),
                SizedBox(width: 8.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: colorScheme.onSecondaryFixed,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    productsCount.toString(),
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
        BlocBuilder<ProductsCubit, ProductsState>(
          builder: (context, state) {
            switch (state) {
              case ProductsLoaded():
                if (state.products.isEmpty) {
                  return SliverFillRemaining(
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
                            style: theme.textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12.h,
                      crossAxisSpacing: 12.w,
                      childAspectRatio: 0.72,
                    ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return ProductCard(product: state.products[index]);
                    }, childCount: state.products.length),
                  ),
                );
              case ProductsFailed():
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Text(state.message),
                  ),
                );
              default:
                return SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12.h,
                      crossAxisSpacing: 12.w,
                      childAspectRatio: 0.72,
                    ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return ProductCard(
                        product: ProductModel(
                          id: 0,
                          sku: 'sku',
                          type: 'type',
                          name: 'name',
                        ),
                      );
                    }, childCount: 4),
                  ),
                );
            }
          },
        ),
      ],
    );
  }
}
