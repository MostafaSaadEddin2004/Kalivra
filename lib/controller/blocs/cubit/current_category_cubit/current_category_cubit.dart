import 'package:bloc/bloc.dart';
import 'package:kalivra/controller/blocs/cubit/categories_cubit/categories_cubit.dart';
import 'package:meta/meta.dart';

part 'current_category_state.dart';

class CurrentCategoryCubit extends Cubit<CurrentCategoryState> {
  CurrentCategoryCubit()
      : super(CurrentCategoryFetched(
          currentIndex: 0,
          categoryId: -1,
          isAll: true,
        ));

  void selectAll() {
    emit(CurrentCategoryFetched(
      currentIndex: 0,
      categoryId: -1,
      isAll: true,
    ));
    CategoriesCubit.currentSelectedCategory = -1;
  }

  void changeCurrentCategory(int index, int categoryId) {
    emit(CurrentCategoryFetched(
      currentIndex: index,
      categoryId: categoryId,
      isAll: false,
    ));
    CategoriesCubit.currentSelectedCategory = categoryId;
  }
}