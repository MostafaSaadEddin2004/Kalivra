import 'package:kalivra/models/product_model.dart';

/// A product in the cart with quantity.
class CartItem {
  const CartItem({
    required this.product,
    this.quantity = 1,
  }) : assert(quantity > 0);

  final ProductModel product;
  final int quantity;

  double get unitPrice => product.salePrice ?? product.price;

  double get lineTotal => unitPrice * quantity;

  CartItem copyWith({int? quantity}) =>
      CartItem(product: product, quantity: quantity ?? this.quantity);
}
