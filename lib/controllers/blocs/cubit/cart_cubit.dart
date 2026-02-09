import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kalivra/models/cart_item_model.dart';
import 'package:kalivra/models/product_model.dart';

/// Manages cart state: add, remove, update quantity, clear.
/// Exposes subtotal, delivery cost, and total for the summary bar.
class CartCubit extends Cubit<List<CartItem>> {
  CartCubit() : super([]);

  /// Fixed delivery cost in SAR. Can be made configurable (e.g. from API) later.
  static const double deliveryCost = 15.0;

  void addItem(ProductModel product, {int quantity = 1}) {
    if (quantity < 1) return;
    final maxQty = product.quantity;
    final list = List<CartItem>.from(state);
    final index = list.indexWhere((e) => e.product.id == product.id);
    if (index >= 0) {
      final newQty = (list[index].quantity + quantity).clamp(1, maxQty);
      list[index] = list[index].copyWith(quantity: newQty);
    } else {
      list.add(CartItem(product: product, quantity: quantity.clamp(1, maxQty)));
    }
    emit(list);
  }

  void removeItem(String productId) {
    emit(state.where((e) => e.product.id != productId).toList());
  }

  void updateQuantity(String productId, int quantity) {
    if (quantity < 1) {
      removeItem(productId);
      return;
    }
    final list = state.map((e) {
      if (e.product.id == productId) {
        final capped = quantity.clamp(1, e.product.quantity);
        return e.copyWith(quantity: capped);
      }
      return e;
    }).toList();
    emit(list);
  }

  void clear() => emit([]);

  /// Subtotal (sum of all line totals) — full cost of products.
  double get subtotal => state.fold(0.0, (sum, e) => sum + e.lineTotal);

  /// Total = subtotal + delivery cost.
  double get total => subtotal + deliveryCost;

  int get itemCount => state.fold(0, (sum, e) => sum + e.quantity);
}
