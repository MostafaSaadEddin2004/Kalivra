import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/controller/blocs/cubit/search_cubit/search_cubit.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/view/widgets/cards/search_result_card.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        if (state is SearchLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is SearchFailed) {
          return _MessageView(message: state.message);
        }

        if (state is SearchLoaded) {
          final items = _SearchItem.fromState(context, state);
          if (items.isEmpty) {
            return _MessageView(
              message: AppLocalizations.of(context)!.searchNoResults,
            );
          }

          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 16.h),
                sliver: SliverList.separated(
                  itemCount: items.length,
                  separatorBuilder: (context, index) => SizedBox(height: 8.h),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return SearchResultCard(
                      label: item.label,
                      resultType: item.type,
                      onTap: item.onTap,
                    );
                  },
                ),
              ),
            ],
          );
        }

        return const _SuggestionsView();
      },
    );
  }
}

class _SuggestionsView extends StatelessWidget {
  const _SuggestionsView();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 12.h),
            child: Text(
              'اقتراحات سريعة',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12.h,
              crossAxisSpacing: 12.w,
              childAspectRatio: 1.2,
            ),
            delegate: SliverChildListDelegate([
              const SearchResultCard(label: 'دهانات'),
              const SearchResultCard(label: 'سيراميك'),
              const SearchResultCard(label: 'أدوات صحية'),
              const SearchResultCard(label: 'حديد'),
              const SearchResultCard(label: 'كهربائيات'),
              const SearchResultCard(label: 'ديكور'),
            ]),
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: 24.h)),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Text(
              'آخر البحث',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 16.h),
            child: Text(
              'لم تبحث عن شيء بعد. اكتب في شريط البحث أعلاه.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
      ],
    );
  }
}

class _SearchItem {
  const _SearchItem({
    required this.label,
    required this.type,
    required this.onTap,
  });

  final String label;
  final String type;
  final VoidCallback onTap;

  static List<_SearchItem> fromState(BuildContext context, SearchLoaded state) {
    final l10n = AppLocalizations.of(context)!;

    return [
      ...state.result.products.map(
        (product) => _SearchItem(
          label: product.name,
          type: l10n.searchResultProduct,
          onTap: () => context.push(AppRoutes.productDetails, extra: product),
        ),
      ),
      ...state.result.brands.map(
        (brand) => _SearchItem(
          label: brand.name,
          type: l10n.searchResultBrand,
          onTap: () => context.push(AppRoutes.brandDetails, extra: brand),
        ),
      ),
      ...state.result.categories.map(
        (category) => _SearchItem(
          label: category.name,
          type: l10n.searchResultCategory,
          onTap: () => context.go(
            '${AppRoutes.home}?categoryId=${category.id}',
            extra: category,
          ),
        ),
      ),
    ];
  }
}

class _MessageView extends StatelessWidget {
  const _MessageView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
