import 'package:kalivra/models/cart_item_model.dart';

/// Cart state: items, optional flags and messages for UI (SnackBars).
class CartState {
  const CartState({
    this.items = const [],
    this.loginRequiredForAdd = false,
    this.addSuccessMessage,
  });

  final List<CartItem> items;
  final bool loginRequiredForAdd;
  /// Set by cubit when add-to-cart succeeds; listener shows SnackBar then clears.
  final String? addSuccessMessage;

  CartState copyWith({
    List<CartItem>? items,
    bool? loginRequiredForAdd,
    String? addSuccessMessage,
  }) =>
      CartState(
        items: items ?? this.items,
        loginRequiredForAdd: loginRequiredForAdd ?? this.loginRequiredForAdd,
        addSuccessMessage: addSuccessMessage ?? this.addSuccessMessage,
      );
}
