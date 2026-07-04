import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/controller/blocs/cubit/categories_cubit/categories_cubit.dart';
import 'package:kalivra/controller/blocs/cubit/current_category_cubit/current_category_cubit.dart';
import 'package:kalivra/controller/blocs/cubit/products_cubit/products_cubit.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/model/category/category_api_model.dart';
import 'package:kalivra/model/product/product_model.dart';
import 'package:kalivra/view/widgets/cards/product_card.dart';
import 'package:kalivra/view/widgets/category/category_button.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CurrentCategoryCubit>(
          create: (_) => CurrentCategoryCubit(),
        ),
        BlocProvider<CategoriesCubit>(
          create: (_) => CategoriesCubit()..loadCategories(),
        ),
        BlocProvider<ProductsCubit>(
          create: (_) => ProductsCubit()..loadProducts(),
        ),
      ],
      child: const _CategoriesPageBody(),
    );
  }
}

class _CategoriesPageBody extends StatelessWidget {
  const _CategoriesPageBody();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final isDark = theme.brightness == Brightness.dark;

    return BlocListener<CurrentCategoryCubit, CurrentCategoryState>(
      listener: (context, state) {
        if (state is CurrentCategoryFetched) {
          final productsCubit = context.read<ProductsCubit>();

          if (state.isAll) {
            productsCubit.loadProducts();
          } else {
            productsCubit.loadProductByCategoryId(state.categoryId);
          }
        }
      },
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: SizedBox(height: 8.h)),

          SliverToBoxAdapter(
            child: BlocBuilder<CategoriesCubit, CategoriesState>(
              builder: (context, state) {
                switch (state) {
                  case CategoriesLoaded():
                    final allCategory = CategoryApiModel(
                      id: -1,
                      name: l10n.allCategories,
                    );

                    final categories = <CategoryApiModel>[
                      allCategory,
                      ...state.categories,
                    ];

                    return SizedBox(
                      height: 48.h,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        itemCount: categories.length,
                        separatorBuilder: (_, _) => SizedBox(width: 10.w),
                        itemBuilder: (context, index) {
                          return BlocBuilder<CurrentCategoryCubit,
                              CurrentCategoryState>(
                            builder: (context, currentCategoryState) {
                              int currentIndex = 0;

                              if (currentCategoryState
                                  is CurrentCategoryFetched) {
                                currentIndex =
                                    currentCategoryState.currentIndex;
                              }

                              return CategoryButton(
                                category: categories[index],
                                currentIndex: currentIndex,
                                index: index,
                                onTap: () {
                                  if (index == 0) {
                                    context
                                        .read<CurrentCategoryCubit>()
                                        .selectAll();
                                  } else {
                                    context
                                        .read<CurrentCategoryCubit>()
                                        .changeCurrentCategory(
                                          index,
                                          categories[index].id,
                                        );
                                  }
                                },
                              );
                            },
                          );
                        },
                      ),
                    );

                  case CategoriesFailed():
                    return Center(child: Text(state.message));

                  default:
                    return SizedBox(
                      height: 48.h,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        itemCount: 4,
                        separatorBuilder: (_, _) => SizedBox(width: 10.w),
                        itemBuilder: (context, index) {
                          return Skeletonizer(
                            child: CategoryButton(
                              category: CategoryApiModel(
                                id: index,
                                name: 'Category',
                              ),
                              currentIndex: 0,
                              index: index,
                              onTap: () {},
                            ),
                          );
                        },
                      ),
                    );
                }
              },
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: 16.h)),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: BlocBuilder<ProductsCubit, ProductsState>(
                builder: (context, state) {
                  final count = state is ProductsLoaded
                      ? state.products.length
                      : 0;

                  return Row(
                    children: [
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
                          count.toString(),
                          style: textTheme.labelMedium?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        l10n.product,
                        style: textTheme.titleMedium,
                      ),
                    ],
                  );
                },
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
                              l10n.noProductsInCategory,
                              style: theme.textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12.h,
                        crossAxisSpacing: 12.w,
                        childAspectRatio: 0.72,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return ProductCard(
                            product: state.products[index],
                          );
                        },
                        childCount: state.products.length,
                      ),
                    ),
                  );

                case ProductsFailed():
                  return SliverToBoxAdapter(
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
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return Skeletonizer(
                            child: ProductCard(
                              product: ProductModel(
                                id: 0,
                                sku: '',
                                name: '',
                                urlKey: '',
                                images: const [],
                                isNew: true,
                                prices: ProductPrices(
                                  regular: PriceDetail(price: ''),
                                ),
                                isFeatured: true,
                                onSale: true,
                                isSaleable: true,
                                isWishlist: true,
                                ratings: ProductRatings(
                                  average: '',
                                  total: 0,
                                ),
                                reviews: ProductReviews(total: 0),
                              ),
                            ),
                          );
                        },
                        childCount: 4,
                      ),
                    ),
                  );
              }
            },
          ),

          SliverToBoxAdapter(child: SizedBox(height: 72.h)),
        ],
      ),
    );
  }
}