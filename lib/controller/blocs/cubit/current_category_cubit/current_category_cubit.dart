import 'package:bloc/bloc.dart';
import 'package:kalivra/controller/blocs/cubit/categories_cubit/categories_cubit.dart';
import 'package:meta/meta.dart';

part 'current_category_state.dart';

class CurrentCategoryCubit extends Cubit<CurrentCategoryState> {
  CurrentCategoryCubit({int? initialCategoryId})
    : super(
        CurrentCategoryFetched(
          currentIndex: 0,
          categoryId: initialCategoryId ?? -1,
          isAll: initialCategoryId == null,
        ),
      );

  void selectAll() {
    emit(CurrentCategoryFetched(currentIndex: 0, categoryId: -1, isAll: true));
    CategoriesCubit.currentSelectedCategory = -1;
  }

  void changeCurrentCategory(int index, int categoryId) {
    if (categoryId < 0) {
      selectAll();
      return;
    }

    emit(
      CurrentCategoryFetched(
        currentIndex: index,
        categoryId: categoryId,
        isAll: false,
      ),
    );
    CategoriesCubit.currentSelectedCategory = categoryId;
  }
}
