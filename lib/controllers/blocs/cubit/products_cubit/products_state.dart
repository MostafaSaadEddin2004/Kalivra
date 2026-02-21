import 'package:kalivra/models/category_model.dart';
import 'package:kalivra/models/product_model.dart';

abstract class ProductsState {
  const ProductsState();
  List<CategoryModel> get categories => [];
  List<ProductModel> get products => [];
  dynamic get error => null;
  bool get isLoading => false;
  bool get hasError => error != null;

  static const ProductsState initial = _ProductsInitial();
  static const ProductsState loading = _ProductsLoading();
  static const ProductsState categoriesLoading = _ProductsCategoriesLoading();
  static ProductsState categoriesLoaded(List<CategoryModel> c) => _ProductsCategoriesLoaded(c);
  static ProductsState categoriesFailed(dynamic e, [StackTrace? st]) => _ProductsCategoriesFailed(e, st);
  static const ProductsState productsLoading = _ProductsProductsLoading();
  static ProductsState productsLoaded(List<ProductModel> p) => _ProductsProductsLoaded(p);
  static ProductsState productsFailed(dynamic e, [StackTrace? st]) => _ProductsProductsFailed(e, st);
  static ProductsState loaded({required List<CategoryModel> categories, required List<ProductModel> products}) =>
      _ProductsLoaded(categories: categories, products: products);
  static ProductsState failed(dynamic e, [StackTrace? st]) => _ProductsFailed(e, st);
}

final class _ProductsInitial extends ProductsState {
  const _ProductsInitial();
}

final class _ProductsLoading extends ProductsState {
  const _ProductsLoading();
  @override
  bool get isLoading => true;
}

final class _ProductsCategoriesLoading extends ProductsState {
  const _ProductsCategoriesLoading();
  @override
  bool get isLoading => true;
}

final class _ProductsCategoriesLoaded extends ProductsState {
  _ProductsCategoriesLoaded(this.categories);
  @override
  final List<CategoryModel> categories;
}

final class _ProductsCategoriesFailed extends ProductsState {
  _ProductsCategoriesFailed(this.error, [this.stackTrace]);
  @override
  final dynamic error;
  final StackTrace? stackTrace;
}

final class _ProductsProductsLoading extends ProductsState {
  const _ProductsProductsLoading();
  @override
  bool get isLoading => true;
}

final class _ProductsProductsLoaded extends ProductsState {
  _ProductsProductsLoaded(this.products);
  @override
  final List<ProductModel> products;
}

final class _ProductsProductsFailed extends ProductsState {
  _ProductsProductsFailed(this.error, [this.stackTrace]);
  @override
  final dynamic error;
  final StackTrace? stackTrace;
}

final class _ProductsLoaded extends ProductsState {
  _ProductsLoaded({required this.categories, required this.products});
  @override
  final List<CategoryModel> categories;
  @override
  final List<ProductModel> products;
}

final class _ProductsFailed extends ProductsState {
  _ProductsFailed(this.error, [this.stackTrace]);
  @override
  final dynamic error;
  final StackTrace? stackTrace;
}
