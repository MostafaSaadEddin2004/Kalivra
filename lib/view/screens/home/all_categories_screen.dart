import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/controller/blocs/cubit/categories_cubit/categories_cubit.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/model/category/category_api_model.dart';
import 'package:kalivra/view/widgets/app_refresh_indicator.dart';
import 'package:kalivra/view/widgets/cards/custom_network_image.dart';
import 'package:kalivra/view/widgets/empty_state_view.dart';
import 'package:kalivra/view/widgets/profile_page/screen_app_bar.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AllCategoriesScreen extends StatelessWidget {
  const AllCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => CategoriesCubit()..loadCategories(),
      child: Scaffold(
        appBar: ScreenAppBar(title: l10n.navCategories),
        body: Builder(
          builder: (context) {
            return AppRefreshIndicator(
              onRefresh: () => context.read<CategoriesCubit>().loadCategories(),
              child: const _AllCategoriesBody(),
            );
          },
        ),
      ),
    );
  }
}

class _AllCategoriesBody extends StatelessWidget {
  const _AllCategoriesBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoriesCubit, CategoriesState>(
      builder: (context, state) {
        switch (state) {
          case CategoriesLoaded():
            final categories = _flattenCategories(state.categories);
            if (categories.isEmpty) {
              return RefreshableStateBox(
                child: EmptyStateView(
                  icon: Icons.category_outlined,
                  title: AppLocalizations.of(context)!.navCategories,
                  description: AppLocalizations.of(
                    context,
                  )!.noCategoriesAvailable,
                ),
              );
            }

            return CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 28.h),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 14.h,
                      crossAxisSpacing: 12.w,
                      childAspectRatio: 0.78,
                    ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final category = categories[index];
                      return _CategoryGridCard(
                        category: category,
                        onTap: () => context.push(
                          AppRoutes.categoryProducts,
                          extra: category,
                        ),
                      );
                    }, childCount: categories.length),
                  ),
                ),
              ],
            );

          case CategoriesFailed():
            return RefreshableStateBox(
              child: EmptyStateView(
                icon: Icons.category_outlined,
                title: AppLocalizations.of(context)!.unexpectedError,
                description: state.message,
                actionLabel: AppLocalizations.of(context)!.retry,
                onAction: () =>
                    context.read<CategoriesCubit>().loadCategories(),
              ),
            );

          default:
            return CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 28.h),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 14.h,
                      crossAxisSpacing: 12.w,
                      childAspectRatio: 0.78,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => Skeletonizer(
                        child: _CategoryGridCard(
                          category: CategoryApiModel(
                            id: index,
                            name: 'Category',
                          ),
                          onTap: () {},
                        ),
                      ),
                      childCount: 12,
                    ),
                  ),
                ),
              ],
            );
        }
      },
    );
  }
}

class _CategoryGridCard extends StatelessWidget {
  const _CategoryGridCard({required this.category, required this.onTap});

  final CategoryApiModel category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(8.r),
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(shape: BoxShape.circle),
                child: ClipOval(
                  child: CustomNetworkImage(
                    imageUrl: _categoryImageUrl(category),
                    defaultIcon: Icons.category_rounded,
                    defaultIconColor: theme.colorScheme.onPrimaryFixedVariant,
                  ),
                ),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              category.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w700,
                height: 1.15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<CategoryApiModel> _flattenCategories(List<CategoryApiModel> categories) {
  final result = <CategoryApiModel>[];
  final seenIds = <int>{};

  void visit(CategoryApiModel category) {
    if (seenIds.add(category.id)) {
      result.add(category);
    }

    for (final child in category.children ?? const <CategoryApiModel>[]) {
      visit(child);
    }
  }

  for (final category in categories) {
    visit(category);
  }

  return result;
}

String? _categoryImageUrl(CategoryApiModel category) {
  return category.imageUrl ??
      category.logo?.preferredUrl ??
      category.banner?.preferredUrl;
}
