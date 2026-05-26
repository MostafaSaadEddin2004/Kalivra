import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/controller/blocs/cubit/categories_cubit/categories_cubit.dart';
import 'package:kalivra/controller/blocs/cubit/current_category_cubit/current_category_cubit.dart';
import 'package:kalivra/model/category/category_api_model.dart';
import 'package:kalivra/view/widgets/category/category_button.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CategoryTabBar extends StatelessWidget {
  const CategoryTabBar({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CurrentCategoryCubit(),
      child: BlocBuilder<CategoriesCubit, CategoriesState>(
        bloc: CategoriesCubit()..loadCategories(),
        builder: (context, state) {
          switch (state) {
            case CategoriesLoaded():
              return SizedBox(
                height: 48.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  itemCount: state.categories.length,
                  separatorBuilder: (_, _) => SizedBox(width: 10.w),
                  itemBuilder: (context, index) {
                    return BlocBuilder<
                      CurrentCategoryCubit,
                      CurrentCategoryState
                    >(
                      builder: (context, indexState) {
                        if (indexState is CurrentCategoryFetched) {
                          return CategoryButton(
                            category: state.categories[index],
                            currentIndex: indexState.currentIndex,
                            index: index,
                            onTap: () => context
                                .read<CurrentCategoryCubit>()
                                .changeCurrentCategory(
                                  index,
                                  state.categories[index].id,
                                ),
                          );
                        }
                        return SizedBox();
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
                        category: CategoryApiModel(id: 1, name: 'name'),
                        currentIndex: 0,
                        index: 0,
                        onTap: () {},
                      ),
                    );
                  },
                ),
              );
          }
        },
      ),
    );
  }
}
