import 'package:kalivra/model/cart/cart_api_model.dart';

enum CartOperation {
  none,
  refreshing,
  updatingQuantity,
  updatingDetails,
  removingItem,
  clearingCart,
}

abstract class CartState {
  const CartState();
}

final class CartInitial extends CartState {
  const CartInitial();
}

final class CartLoading extends CartState {
  const CartLoading();
}

final class CartLoaded extends CartState {
  const CartLoaded({
    required this.cart,
    this.operation = CartOperation.none,
    this.activeItemId,
  });

  final CartApiModel cart;
  final CartOperation operation;
  final int? activeItemId;
}

final class CartLoginRequired extends CartState {
  const CartLoginRequired();
}

final class AddToCartSuccessed extends CartState {
  const AddToCartSuccessed({required this.message, required this.cart});

  final String message;
  final CartApiModel cart;
}

final class UpdateItemQuantitySuccessed extends CartState {
  const UpdateItemQuantitySuccessed({
    required this.message,
    required this.cart,
  });

  final String message;
  final CartApiModel cart;
}

final class RemoveFromCartSuccessed extends CartState {
  const RemoveFromCartSuccessed({required this.message, required this.cart});

  final String message;
  final CartApiModel cart;
}

final class UpdateItemDetialsSuccessed extends CartState {
  const UpdateItemDetialsSuccessed({required this.message, required this.cart});

  final String message;
  final CartApiModel cart;
}

final class DeleteCartSuccessed extends CartState {
  const DeleteCartSuccessed({required this.message});

  final String message;
}

final class CartFailure extends CartState {
  const CartFailure({
    required this.message,
    this.cart,
    this.operation = CartOperation.none,
    this.activeItemId,
  });

  final String message;
  final CartApiModel? cart;
  final CartOperation operation;
  final int? activeItemId;
}
