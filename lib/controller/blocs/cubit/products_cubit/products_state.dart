import 'package:kalivra/model/product/product_model.dart';

abstract class ProductsState {}

final class ProductsLoading extends ProductsState {}

final class ProductsLoaded extends ProductsState {
  final List<ProductModel> products;

  ProductsLoaded({required this.products});
}
final class OneProductLoaded extends ProductsState {
  final ProductModel product;

  OneProductLoaded({required this.product});
}

final class ProductsFailed extends ProductsState {
  final String message;

  ProductsFailed({required this.message});
}
