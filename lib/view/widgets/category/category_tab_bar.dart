import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/controller/blocs/cubit/categories_cubit/categories_cubit.dart';
import 'package:kalivra/model/category/category_api_model.dart';
import 'package:kalivra/view/widgets/category/category_button.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CategoryTabBar extends StatelessWidget {
  const CategoryTabBar({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoriesCubit, CategoriesState>(
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
                  final currentCategoryId = CategoriesCubit.currentCategoryId;
                  final category = state.categories[index];
                  return CategoryButton(
                    category: state.categories[index],
                    isSelected: currentCategoryId == category.id,
                    onTap: () => context.read<CategoriesCubit>().changeCategory(category.id),
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
                      isSelected: false,
                      onTap: () {},
                    ),
                  );
                },
              ),
            );
        }
      },
    );
  }
}
