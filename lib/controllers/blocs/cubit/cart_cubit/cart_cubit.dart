import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kalivra/controllers/blocs/cubit/auth_cubit/auth_cubit.dart';
import 'package:kalivra/controllers/blocs/cubit/cart_cubit/cart_state.dart';
import 'package:kalivra/models/cart_item_model.dart';
import 'package:kalivra/models/product_model.dart';

export 'cart_state.dart';

/// Manages cart state. Add-to-cart requires login; check is done in cubit.
class CartCubit extends Cubit<CartState> {
  CartCubit(this._authCubit) : super(const CartState());

  final AuthCubit _authCubit;

  /// Fixed delivery cost. Can be made configurable (e.g. from API) later.
  static const double deliveryCost = 15.0;

  bool get _isLoggedIn =>
      _authCubit.state.token != null && _authCubit.state.token!.isNotEmpty;

  void addItem(ProductModel product, {int quantity = 1}) {
    if (quantity < 1) return;
    if (!_isLoggedIn) {
      emit(state.copyWith(loginRequiredForAdd: true));
      return;
    }
    final maxQty = product.quantity;
    final list = List<CartItem>.from(state.items);
    final index = list.indexWhere((e) => e.product.id == product.id);
    if (index >= 0) {
      final newQty = (list[index].quantity + quantity).clamp(1, maxQty);
      list[index] = list[index].copyWith(quantity: newQty);
    } else {
      list.add(CartItem(product: product, quantity: quantity.clamp(1, maxQty)));
    }
    emit(state.copyWith(
      items: list,
      loginRequiredForAdd: false,
      addSuccessMessage: 'تمت إضافة "${product.name}" إلى السلة',
    ));
  }

  void removeItem(String productId) {
    emit(state.copyWith(
      items: state.items.where((e) => e.product.id != productId).toList(),
    ));
  }

  void updateQuantity(String productId, int quantity) {
    if (quantity < 1) {
      removeItem(productId);
      return;
    }
    final list = state.items.map((e) {
      if (e.product.id == productId) {
        final capped = quantity.clamp(1, e.product.quantity);
        return e.copyWith(quantity: capped);
      }
      return e;
    }).toList();
    emit(state.copyWith(items: list));
  }

  void clear() => emit(const CartState());

  void clearLoginRequired() => emit(state.copyWith(loginRequiredForAdd: false));

  void clearAddSuccessMessage() =>
      emit(CartState(items: state.items, loginRequiredForAdd: state.loginRequiredForAdd));

  double get subtotal =>
      state.items.fold(0.0, (sum, e) => sum + e.lineTotal);

  double get total => subtotal + deliveryCost;

  int get itemCount => state.items.fold(0, (sum, e) => sum + e.quantity);
}
