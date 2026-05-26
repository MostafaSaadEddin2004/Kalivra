part of 'current_category_cubit.dart';

@immutable
sealed class CurrentCategoryState {}

final class CurrentCategoryFetched extends CurrentCategoryState {
  final int currentIndex;
  final int categoryId;
  final bool isAll;

  CurrentCategoryFetched({
    required this.currentIndex,
    required this.categoryId,
    this.isAll = true, // default الكل
  });
}