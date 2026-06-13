import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/controller/blocs/cubit/cubit/brand_cubit.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/model/brand/brand_model.dart';
import 'package:kalivra/view/widgets/buttons/show_all_button.dart';
import 'package:kalivra/view/widgets/cards/brand_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BrandsSection extends StatelessWidget {
  const BrandsSection({super.key});

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
        SizedBox(height: 12.h),
        SizedBox(
          height: 120.h,
          child: BlocBuilder<BrandCubit, BrandState>(
            bloc: BrandCubit()..fetchAllBrands(),
            builder: (context, state) {
              switch (state) {
                case BrandFailure():
                  return Center(child: Text(state.message));
                case BrandsFetched():
                  return ListView.separated(
                    separatorBuilder: (context, index) => SizedBox(width: 12.w),
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    clipBehavior: Clip.none,
                    itemCount: state.brands.length,
                    itemBuilder: (context, index) {
                      return BrandCard(brand: state.brands[index]);
                    },
                  );
                default:
                  return Skeletonizer(
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
                  );
              }
            },
          ),
        ),
      ],
    );
  }
}
