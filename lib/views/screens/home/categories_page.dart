import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/controllers/blocs/cubit/cart_cubit.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/data/categories_data.dart';
import 'package:kalivra/models/product_model.dart';
import 'package:kalivra/views/widgets/category/category_tab_bar.dart';
import 'package:kalivra/views/widgets/cards/product_card.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  static const String _allCategoryId = 'all';
  late String _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _selectedCategoryId = _allCategoryId;
  }

  List<ProductModel> get _filteredProducts =>
      CategoriesData.productsForCategory(_selectedCategoryId);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: SizedBox(height: 8.h)),
        SliverToBoxAdapter(
          child: CategoryTabBar(
            categories: CategoriesData.categories,
            selectedId: _selectedCategoryId,
            onSelected: (id) => setState(() => _selectedCategoryId = id),
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: 16.h)),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                Text(
                  _selectedCategoryId == _allCategoryId
                      ? 'جميع المنتجات'
                      : CategoriesData.categories
                            .firstWhere(
                              (c) => c.id == _selectedCategoryId,
                              orElse: () => CategoriesData.categories.first,
                            )
                            .name,
                  style: textTheme.titleMedium
                ),
                SizedBox(width: 8.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: colorScheme.onSecondaryFixed,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    '${_filteredProducts.length}',
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
        _filteredProducts.isEmpty
            ? SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.category_outlined,
                        size: 64.r,
                        color: colorScheme.outline.withValues(alpha: 0.6),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'لا توجد منتجات في هذا التصنيف',
                        style: textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
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
                    final product = _filteredProducts[index];
                    return ProductCard(
                      product: product,
                      onTap: () => context.push(AppRoutes.productDetails, extra: product),
                      onAddToCart: () {
                        context.read<CartCubit>().addItem(product);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('تمت إضافة "${product.name}" إلى السلة'),
                            behavior: SnackBarBehavior.floating,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                    );
                  }, childCount: _filteredProducts.length),
                ),
              ),
        SliverToBoxAdapter(child: SizedBox(height: 24.h)),
      ],
    );
  }
}
