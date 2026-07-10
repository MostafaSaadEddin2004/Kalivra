import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kalivra/controller/blocs/cubit/cart_cubit/cart_state.dart';
import 'package:kalivra/controller/prefs/local_store.dart';
import 'package:kalivra/model/cart/cart_api_model.dart';
import 'package:kalivra/model/cart/cart_item_model.dart';
import 'package:kalivra/model/product/product_model.dart';
import 'package:kalivra/model/services/api/cart_api_service.dart';

export 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());

  final CartApiService _cartService = CartApiService();

  CartApiModel? _cart;

  static const double deliveryCost = 15.0;

  CartApiModel? get cart => _cart;

  List<CartItem> get items => _mapCartItems(_cart);

  double get subtotal => _cart?.subTotal ?? 0;

  double get total => _cart?.grandTotal ?? subtotal;

  int get itemCount => _cart?.itemQuantity ?? 0;

  List<CartItem> _mapCartItems(CartApiModel? cart) {
    final apiItems = cart?.items;
    if (apiItems == null || apiItems.isEmpty) return const [];

    final mapped = <CartItem>[];
    for (final apiItem in apiItems) {
      final productJson = apiItem.product;
      if (productJson == null) continue;
      try {
        mapped.add(
          CartItem(
            product: ProductModel.fromJson(productJson),
            quantity: apiItem.quantity ?? 1,
            cartItemId: apiItem.id,
          ),
        );
      } catch (_) {}
    }
    return mapped;
  }

  Future<void> _emitLoaded(CartApiModel? cart) async {
    _cart = cart;
    if (cart == null || (cart.items?.isEmpty ?? true)) {
      emit(CartLoaded(cart: cart ?? const CartApiModel()));
      return;
    }
    emit(CartLoaded(cart: cart));
  }

  Future<void> getCart() async {
    emit(CartLoading());
    try {
      final token = await LocalStore.getToken();
      if (token == null || token.isEmpty) {
        _cart = null;
        emit(CartLoginRequired());
        return;
      }
      final cart = await _cartService.getCart();
      await _emitLoaded(cart);
    } catch (e) {
      emit(CartFailure(message: e.toString()));
    }
  }

  Future<void> addItem(String productId, {int quantity = 1}) async {
    if (quantity < 1) return;

    final token = await LocalStore.getToken();
    if (token == null || token.isEmpty) {
      emit(CartLoginRequired());
      return;
    }

    emit(CartLoading());
    try {
      final cart = await _cartService.addToCart(
        productId: int.parse(productId),
        quantity: quantity.clamp(1, 5),
      );
      await _emitLoaded(cart);
      if (cart != null) {
        emit(AddToCartSuccessed(message: 'added', cart: cart));
      }
    } catch (e) {
      emit(CartFailure(message: e.toString()));
    }
  }

  Future<void> removeCartItem(int cartItemId) async {
    emit(CartLoading());
    try {
      await _cartService.removeCartItem(cartItemId);
      final cart = await _cartService.getCart();
      await _emitLoaded(cart);
      if (cart != null) {
        emit(RemoveFromCartSuccessed(message: 'removed', cart: cart));
      }
    } catch (e) {
      emit(CartFailure(message: e.toString()));
    }
  }

  Future<void> removeSelectedItems(List<int> cartItemIds) async {
    if (cartItemIds.isEmpty) {
      emit(DeleteCartSuccessed(message: 'cleared'));
      _cart = null;
      emit(CartLoaded(cart: const CartApiModel()));
      return;
    }

    emit(CartLoading());
    try {
      await _cartService.removeSelectedItems(cartItemIds);
      final cart = await _cartService.getCart();
      await _emitLoaded(cart);
      emit(DeleteCartSuccessed(message: 'cleared'));
    } catch (e) {
      emit(CartFailure(message: e.toString()));
    }
  }

  Future<void> removeItem(String productId) async {
    final id = int.parse(productId);
    final index = items.indexWhere((e) => e.product.id == id);
    if (index < 0) return;

    final cartItemId = items[index].cartItemId;
    if (cartItemId != null) {
      await removeCartItem(cartItemId);
    }
  }

  Future<void> updateQuantity(String productId, int quantity) async {
    if (quantity < 1) {
      await removeItem(productId);
    }
  }

  Future<void> clear() async {
    final ids = items.map((e) => e.cartItemId).whereType<int>().toList();
    await removeSelectedItems(ids);
  }

  void clearLoginRequired() {
    if (_cart != null) {
      emit(CartLoaded(cart: _cart!));
    } else {
      emit(CartInitial());
    }
  }
}
