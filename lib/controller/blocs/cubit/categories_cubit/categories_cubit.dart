import 'package:bloc/bloc.dart';
import 'package:kalivra/model/category/category_api_model.dart';
import 'package:kalivra/model/services/api/category_api_service.dart';
import 'package:meta/meta.dart';

part 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  CategoriesCubit() : super(CategoriesLoading());

  final CategoryApiService _categoryService = CategoryApiService();
  static int currentSelectedCategory = 0;

  Future<void> loadCategories() async {
    emit(CategoriesLoading());
    try {
      final categories = await _categoryService.getCategories();
      emit(CategoriesLoaded(categories: categories));
    } catch (e) {
      emit(CategoriesFailed(message: e.toString()));
    }
  }
}
