import 'package:kalivra/model/product/product_model.dart';

/// A product in the cart with quantity.
class CartItem {
  const CartItem({
    required this.product,
    this.quantity = 1,
    this.cartItemId,
  }) : assert(quantity > 0);

  final ProductModel product;
  final int quantity;
  final int? cartItemId;

  double get unitPrice => double.parse(product.prices.regular.price);

  double get lineTotal => unitPrice * quantity;

  CartItem copyWith({int? quantity, int? cartItemId}) => CartItem(
        product: product,
        quantity: quantity ?? this.quantity,
        cartItemId: cartItemId ?? this.cartItemId,
      );
}
