import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/controller/blocs/cubit/brand_cubit/brand_cubit.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/model/brand/brand_model.dart';
import 'package:kalivra/view/widgets/buttons/show_all_button.dart';
import 'package:kalivra/view/widgets/cards/brand_card.dart';
import 'package:kalivra/view/widgets/empty_state_view.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BrandsSection extends StatefulWidget {
  const BrandsSection({super.key});

  @override
  State<BrandsSection> createState() => _BrandsSectionState();
}

class _BrandsSectionState extends State<BrandsSection> {
  late final BrandCubit _brandCubit;

  @override
  void initState() {
    super.initState();
    _brandCubit = BrandCubit()..fetchAllBrands();
  }

  @override
  void dispose() {
    _brandCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.brandsSection, style: textTheme.titleMedium),
              ShowAllButton(
                onShowAllTap: () => context.push(AppRoutes.allBrands),
                l10n: l10n,
                textTheme: textTheme,
                colorScheme: colorScheme,
              ),
            ],
          ),
        ),
        BlocBuilder<BrandCubit, BrandState>(
          bloc: _brandCubit,
          builder: (context, state) {
            switch (state) {
              case BrandFailure():
                return SizedBox(
                  height: 260.h,
                  child: EmptyStateView(
                    icon: Icons.storefront_outlined,
                    title: l10n.unexpectedError,
                    description: state.message,
                    actionLabel: l10n.retry,
                    onAction: _brandCubit.fetchAllBrands,
                  ),
                );
              case BrandsFetched():
                final brands = state.brands;
                return SizedBox(
                  height: 120.h,
                  child: brands.isNotEmpty
                      ? ListView.separated(
                          separatorBuilder: (context, index) =>
                              SizedBox(width: 12.w),
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          clipBehavior: Clip.none,
                          itemCount: brands.length,
                          itemBuilder: (context, index) {
                            return BrandCard(brand: brands[index]);
                          },
                        )
                      : SizedBox.shrink(),
                );
              default:
                return SizedBox(
                  height: 120.h,
                  child: Skeletonizer(
                    child: ListView.separated(
                      separatorBuilder: (context, index) =>
                          SizedBox(width: 12.w),
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      clipBehavior: Clip.none,
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return BrandCard(
                          brand: BrandModel(id: 1, name: 'name'),
                        );
                      },
                    ),
                  ),
                );
            }
          },
        ),
      ],
    );
  }
}
