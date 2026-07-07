import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/controller/blocs/cubit/brand_cubit/brand_cubit.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/model/brand/brand_model.dart';
import 'package:kalivra/view/widgets/cards/brand_card.dart';
import 'package:kalivra/view/widgets/profile_page/screen_app_bar.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AllBrandsScreen extends StatelessWidget {
  const AllBrandsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: ScreenAppBar(title: l10n.brandsSection),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<BrandCubit, BrandState>(
          bloc: BrandCubit()..fetchAllBrands(),
          builder: (context, state) {
            switch (state) {
              case BrandLoading():
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 8.h,
                    crossAxisSpacing: 8.w,
                    childAspectRatio: 90/100,
                  ),
                  itemBuilder: (context, index) {
                    return Skeletonizer(
                      child: BrandCard(brand: BrandModel(id: 0, name: 'name')),
                    );
                  },
                  itemCount: 4,
                );
              case BrandsFetched():
                final data = state.brands;
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 8.h,
                    crossAxisSpacing: 8.w,
                    childAspectRatio: 90/100,
                  ),
                  itemBuilder: (context, index) {
                    return BrandCard(brand: data[index]);
                  },
                  itemCount: data.length,
                );
              case BrandFailure():
                return Center(child: Text(state.message));
              default:
                return Center(child: Text('Nothing to display.'));
            }
          },
        ),
      ),
    );
  }
}
