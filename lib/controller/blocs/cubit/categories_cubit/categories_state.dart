part of 'categories_cubit.dart';

@immutable
sealed class CategoriesState {}

final class CategoriesLoading extends CategoriesState {}
final class CategoriesLoaded extends CategoriesState {
  final List<CategoryApiModel> categories;

  CategoriesLoaded({required this.categories});
}
final class CategoriesFailed extends CategoriesState {
  final String message;

  CategoriesFailed({required this.message});
}
