import 'package:kalivra/models/cart_item_model.dart';

/// Cart state: items, optional flags and messages for UI (SnackBars).
class CartState {
  const CartState({
    this.items = const [],
    this.loginRequiredForAdd = false,
    this.addSuccessMessage,
    this.addSuccessProductName,
  });

  final List<CartItem> items;
  final bool loginRequiredForAdd;
  /// Set by cubit when add-to-cart succeeds; listener shows SnackBar then clears.
  final String? addSuccessMessage;
  /// Product name for localized add-to-cart success message.
  final String? addSuccessProductName;

  CartState copyWith({
    List<CartItem>? items,
    bool? loginRequiredForAdd,
    String? addSuccessMessage,
    String? addSuccessProductName,
  }) =>
      CartState(
        items: items ?? this.items,
        loginRequiredForAdd: loginRequiredForAdd ?? this.loginRequiredForAdd,
        addSuccessMessage: addSuccessMessage ?? this.addSuccessMessage,
        addSuccessProductName: addSuccessProductName ?? this.addSuccessProductName,
      );
}
