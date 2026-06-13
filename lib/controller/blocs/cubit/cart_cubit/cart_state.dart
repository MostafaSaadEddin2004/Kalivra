import 'package:kalivra/model/cart/cart_api_model.dart';

abstract class CartState {}

final class CartInitial extends CartState {}

final class CartLoading extends CartState {}

final class CartLoaded extends CartState {
  final CartApiModel cart;

  CartLoaded({required this.cart});
}

final class CartLoginRequired extends CartState {}

final class AddToCartSuccessed extends CartState {
  final String message;
  final CartApiModel cart;

  AddToCartSuccessed({required this.message, required this.cart});
}

final class RemoveFromCartSuccessed extends CartState {
  final String message;
  final CartApiModel cart;

  RemoveFromCartSuccessed({required this.message, required this.cart});
}

final class DeleteCartSuccessed extends CartState {
  final String message;

  DeleteCartSuccessed({required this.message});
}

final class CartFailure extends CartState {
  final String message;

  CartFailure({required this.message});
}
