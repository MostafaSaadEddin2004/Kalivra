import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kalivra/controller/blocs/cubit/cart_cubit/cart_state.dart';
import 'package:kalivra/controller/prefs/local_store.dart';
import 'package:kalivra/model/cart/cart_api_model.dart';
import 'package:kalivra/model/cart/cart_item_model.dart';
import 'package:kalivra/model/product/product_model.dart';
import 'package:kalivra/model/services/api/cart_api_service.dart';
import 'package:kalivra/model/services/api/product_api_service.dart';
import 'package:kalivra/view/widgets/login_dialog.dart';

export 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartInitial());

  final CartApiService _cartService = CartApiService();
  final ProductApiService _productService = ProductApiService();
  final Map<int, ProductModel> _productCache = {};

  CartApiModel? _cart;
  CartOperation _operation = CartOperation.none;
  int? _activeItemId;

  static const double deliveryCost = 15.0;

  CartApiModel? get cart => _cart;

  List<CartItemApiModel> get apiItems => _cart?.items ?? const [];

  List<CartItem> get items => _mapCartItems(_cart);

  double get subtotal => _cart?.subTotal ?? 0;

  double get total => _cart?.grandTotal ?? subtotal;

  int get itemCount => _cart?.itemQuantity ?? 0;

  CartOperation get operation => _operation;

  int? get activeItemId => _activeItemId;

  bool get isClearingCart => _operation == CartOperation.clearingCart;

  bool isRemovingItem(int itemId) =>
      _operation == CartOperation.removingItem && _activeItemId == itemId;

  bool isUpdatingItem(int itemId) =>
      (_operation == CartOperation.updatingQuantity ||
          _operation == CartOperation.updatingDetails) &&
      _activeItemId == itemId;

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

  Future<void> getCart() async {
    final token = await LocalStore.getToken();
    if (token == null || token.isEmpty) {
      _cart = null;
      emit(const CartLoginRequired());
      return;
    }

    if (_cart == null) {
      emit(const CartLoading());
    } else {
      _emitLoaded(operation: CartOperation.refreshing);
    }

    try {
      _cart = await _cartService.getCart();
      _emitLoaded();
    } catch (e) {
      emit(CartFailure(message: e.toString(), cart: _cart));
    }
  }

  Future<ProductModel?> loadCartItemProduct(CartItemApiModel item) async {
    final productId = item.productId;
    if (productId == null || productId <= 0) return null;
    return await loadProduct(productId);
  }

  Future<ProductModel> loadProduct(int productId) async {
    final cached = _productCache[productId];
    if (cached != null) return cached;

    final product = await _productService.getProductById(productId);
    _productCache[productId] = product;
    return product;
  }

  Future<bool> addItem(
    String productId, {
    int quantity = 1,
    String color = '',
    String size = '',
  }) async {
    if (quantity < 1) return false;

    final token = await LocalStore.getToken();
    if (token == null || token.isEmpty) {
      emit(const CartLoginRequired());
      GoToLoginDialog();
      return false;
    }

    emit(const CartLoading());
    try {
      final cart = await _cartService.addToCart(
        productId: int.parse(productId),
        quantity: quantity,
        color: color,
        size: size,
      );
      _cart = cart ?? await _cartService.getCart();
      emit(AddToCartSuccessed(message: 'added', cart: _cart!));
      _emitLoaded();
      return true;
    } catch (e) {
      emit(CartFailure(message: e.toString(), cart: _cart));
      return false;
    }
  }

  Future<bool> removeCartItem(int cartItemId) async {
    if (isRemovingItem(cartItemId)) return false;
    _emitLoaded(
      operation: CartOperation.removingItem,
      activeItemId: cartItemId,
    );

    try {
      await _cartService.removeCartItem(cartItemId);
      _cart = await _cartService.getCart();
      emit(RemoveFromCartSuccessed(message: 'removed', cart: _cart!));
      _emitLoaded();
      return true;
    } catch (e) {
      emit(
        CartFailure(
          message: e.toString(),
          cart: _cart,
          operation: CartOperation.removingItem,
          activeItemId: cartItemId,
        ),
      );
      _emitLoaded();
      return false;
    }
  }

  Future<bool> clearCart() async {
    if ((_cart?.items.isEmpty ?? true) || isClearingCart) return false;
    _emitLoaded(operation: CartOperation.clearingCart);

    try {
      await _cartService.clearCart();
      _cart = const CartApiModel();
      emit(const DeleteCartSuccessed(message: 'cleared'));
      _emitLoaded();
      return true;
    } catch (e) {
      emit(
        CartFailure(
          message: e.toString(),
          cart: _cart,
          operation: CartOperation.clearingCart,
        ),
      );
      _emitLoaded();
      return false;
    }
  }

  Future<bool> updateItemQuantity(int itemId, int quantity) async {
    if (quantity < 1 || isUpdatingItem(itemId)) return false;
    _emitLoaded(
      operation: CartOperation.updatingQuantity,
      activeItemId: itemId,
    );

    try {
      await _cartService.updateItemQuantity(itemId, quantity);
      _cart = await _cartService.getCart();
      emit(UpdateItemQuantitySuccessed(message: 'updated', cart: _cart!));
      _emitLoaded();
      return true;
    } catch (e) {
      emit(
        CartFailure(
          message: e.toString(),
          cart: _cart,
          operation: CartOperation.updatingQuantity,
          activeItemId: itemId,
        ),
      );
      _emitLoaded();
      return false;
    }
  }

  Future<bool> updateItemDetials(
    int itemId,
    int quantity,
    String colorId,
    String sizeId,
  ) async {
    if (quantity < 1 || isUpdatingItem(itemId)) return false;
    _emitLoaded(operation: CartOperation.updatingDetails, activeItemId: itemId);

    try {
      await _cartService.updateItemDetials(itemId, quantity, colorId, sizeId);
      _cart = await _cartService.getCart();
      emit(UpdateItemDetialsSuccessed(message: 'updated', cart: _cart!));
      _emitLoaded();
      return true;
    } catch (e) {
      emit(
        CartFailure(
          message: e.toString(),
          cart: _cart,
          operation: CartOperation.updatingDetails,
          activeItemId: itemId,
        ),
      );
      _emitLoaded();
      return false;
    }
  }

  Future<bool> updateItemDetails(
    int itemId,
    int quantity,
    String colorId,
    String sizeId,
  ) {
    return updateItemDetials(itemId, quantity, colorId, sizeId);
  }

  Future<void> changeQuantity(String productId, int quantity) async {
    if (quantity < 1) return;
    final itemId = int.tryParse(productId);
    if (itemId == null) return;
    await updateItemQuantity(itemId, quantity);
  }

  void _emitLoaded({
    CartOperation operation = CartOperation.none,
    int? activeItemId,
  }) {
    _operation = operation;
    _activeItemId = activeItemId;
    emit(
      CartLoaded(
        cart: _cart ?? const CartApiModel(),
        operation: operation,
        activeItemId: activeItemId,
      ),
    );
  }
}
