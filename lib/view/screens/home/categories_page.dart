import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/controller/blocs/cubit/categories_cubit/categories_cubit.dart';
import 'package:kalivra/controller/blocs/cubit/current_category_cubit/current_category_cubit.dart';
import 'package:kalivra/controller/blocs/cubit/products_cubit/products_cubit.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/model/category/category_api_model.dart';
import 'package:kalivra/model/product/product_model.dart';
import 'package:kalivra/view/widgets/app_refresh_indicator.dart';
import 'package:kalivra/view/widgets/buttons/show_all_button.dart';
import 'package:kalivra/view/widgets/cards/product_card.dart';
import 'package:kalivra/view/widgets/category/category_button.dart';
import 'package:kalivra/view/widgets/empty_state_view.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key, this.initialCategory});

  final CategoryApiModel? initialCategory;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CurrentCategoryCubit>(
          create: (_) =>
              CurrentCategoryCubit(initialCategoryId: initialCategory?.id),
        ),
        BlocProvider<CategoriesCubit>(
          create: (_) => CategoriesCubit()..loadCategories(),
        ),
        BlocProvider<ProductsCubit>(
          create: (_) {
            final cubit = ProductsCubit();
            final categoryId = initialCategory?.id;
            if (categoryId == null) {
              cubit.loadProducts();
            } else {
              cubit.loadProductByCategoryId(categoryId);
            }
            return cubit;
          },
        ),
      ],
      child: _CategoriesPageBody(initialCategory: initialCategory),
    );
  }
}

class _CategoriesPageBody extends StatelessWidget {
  const _CategoriesPageBody({this.initialCategory});

  final CategoryApiModel? initialCategory;

  int? _selectedCategoryId(BuildContext context) {
    final currentState = context.read<CurrentCategoryCubit>().state;
    if (currentState is CurrentCategoryFetched) {
      return currentState.isAll || currentState.categoryId < 0
          ? null
          : currentState.categoryId;
    }
    return initialCategory?.id;
  }

  Future<void> _reload(BuildContext context) async {
    final categoryId = _selectedCategoryId(context);
    final productsCubit = context.read<ProductsCubit>();

    await Future.wait([
      context.read<CategoriesCubit>().loadCategories(),
      if (categoryId == null)
        productsCubit.loadProducts()
      else
        productsCubit.loadProductByCategoryId(categoryId),
    ]);
  }

  Future<void> _reloadProducts(BuildContext context) {
    final categoryId = _selectedCategoryId(context);
    if (categoryId == null) {
      return context.read<ProductsCubit>().loadProducts();
    }
    return context.read<ProductsCubit>().loadProductByCategoryId(categoryId);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return BlocListener<CurrentCategoryCubit, CurrentCategoryState>(
      listener: (context, state) {
        if (state is CurrentCategoryFetched) {
          final productsCubit = context.read<ProductsCubit>();

          if (state.isAll || state.categoryId < 0) {
            productsCubit.loadProducts();
          } else {
            productsCubit.loadProductByCategoryId(state.categoryId);
          }
        }
      },
      child: AppRefreshIndicator(
        onRefresh: () => _reload(context),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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

                      final loadedCategories = state.categories.where(
                        (category) => category.id != initialCategory?.id,
                      );

                      final categories = <CategoryApiModel>[
                        allCategory,
                        ?initialCategory,
                        ...loadedCategories,
                      ];

                      return Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  l10n.navCategories,
                                  style: textTheme.titleMedium,
                                ),
                                ShowAllButton(
                                  onShowAllTap: () =>
                                      context.push(AppRoutes.allCategories),
                                  l10n: l10n,
                                  textTheme: textTheme,
                                  colorScheme: colorScheme,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 110.h,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              itemCount: categories.length,
                              separatorBuilder: (_, _) => SizedBox(width: 10.w),
                              itemBuilder: (context, index) {
                                return BlocBuilder<
                                  CurrentCategoryCubit,
                                  CurrentCategoryState
                                >(
                                  builder: (context, currentCategoryState) {
                                    int currentIndex = 0;

                                    if (currentCategoryState
                                        is CurrentCategoryFetched) {
                                      currentIndex = currentCategoryState.isAll
                                          ? 0
                                          : categories.indexWhere(
                                              (category) =>
                                                  category.id ==
                                                  currentCategoryState
                                                      .categoryId,
                                            );

                                      if (currentIndex < 0) {
                                        currentIndex =
                                            currentCategoryState.currentIndex;
                                      }
                                    }

                                    return CategoryButton(
                                      category: categories[index],
                                      currentIndex: currentIndex,
                                      index: index,
                                      onTap: () {
                                        if (index == 0) {
                                          context
                                              .read<ProductsCubit>()
                                              .loadProducts();
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
                          ),
                        ],
                      );

                    case CategoriesFailed():
                      return SizedBox(
                        height: 260.h,
                        child: EmptyStateView(
                          icon: Icons.category_outlined,
                          title: l10n.unexpectedError,
                          description: state.message,
                          actionLabel: l10n.retry,
                          onAction: () =>
                              context.read<CategoriesCubit>().loadCategories(),
                        ),
                      );

                    default:
                      return SizedBox(
                        height: 110.h,
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
                        Text(l10n.product, style: textTheme.titleMedium),
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
                        child: EmptyStateView(
                          icon: Icons.category_outlined,
                          title: l10n.noProducts,
                          description: l10n.noProductsInCategory,
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
                        delegate: SliverChildBuilderDelegate((context, index) {
                          return ProductCard(product: state.products[index]);
                        }, childCount: state.products.length),
                      ),
                    );

                  case ProductsFailed():
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: EmptyStateView(
                        icon: Icons.inventory_2_outlined,
                        title: l10n.unexpectedError,
                        description: state.message,
                        actionLabel: l10n.retry,
                        onAction: () => _reloadProducts(context),
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
                                ratings: ProductRatings(average: '', total: 0),
                                reviews: ProductReviews(total: 0),
                              ),
                            ),
                          );
                        }, childCount: 4),
                      ),
                    );
                }
              },
            ),

            SliverToBoxAdapter(child: SizedBox(height: 72.h)),
          ],
        ),
      ),
    );
  }
}
