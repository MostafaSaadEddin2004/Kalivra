import 'package:kalivra/model/product/product_model.dart';

class CartItem {
  const CartItem({required this.product, this.quantity = 1, this.cartItemId})
    : assert(quantity > 0);

  final ProductModel product;
  final int quantity;
  final int? cartItemId;

  double get unitPrice => double.tryParse(product.prices.regular.price) ?? 0;

  double get lineTotal => unitPrice * quantity;
}
