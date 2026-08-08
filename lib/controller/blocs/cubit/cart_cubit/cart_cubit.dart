import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kalivra/controller/blocs/cubit/cart_cubit/cart_state.dart';
import 'package:kalivra/controller/prefs/local_store.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/model/cart/cart_api_model.dart';
import 'package:kalivra/model/cart/cart_item_model.dart';
import 'package:kalivra/model/product/product_model.dart';
import 'package:kalivra/model/services/api/cart_api_service.dart';
import 'package:kalivra/model/services/api/product_api_service.dart';
import 'package:kalivra/view/widgets/custom_snack_bar.dart';
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

  bool get isAddingItem => _operation == CartOperation.addingItem;

  bool get isApplyingCoupon => _operation == CartOperation.applyingCoupon;

  bool get isRemovingCoupon => _operation == CartOperation.removingCoupon;

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
    BuildContext context,
    String productId, {
    int quantity = 1,
    String color = '',
    String size = '',
    String productName = '',
  }) async {
    if (quantity < 1) return false;

    final token = await LocalStore.getToken();
    if (token == null || token.isEmpty) {
      emit(const CartLoginRequired());
      GoToLoginDialog();
      return false;
    }

    final l10n = AppLocalizations.of(context)!;
    _emitLoading(operation: CartOperation.addingItem);
    try {
      await _cartService.addToCart(
        productId: int.parse(productId),
        quantity: quantity,
        color: color,
        size: size,
      );
      _cart = await _cartService.getCart();
      final message = l10n.addToCartSuccess(productName);
      emit(AddToCartSuccessed(message: message, cart: _cart!));
      _emitLoaded();
      CustomSnackBar.show(context, message);
      return true;
    } catch (e) {
      final message = e.toString();
      emit(
        CartFailure(
          message: message,
          cart: _cart,
          operation: CartOperation.addingItem,
        ),
      );
      if (_cart != null) _emitLoaded();
      CustomSnackBar.show(context, message);
      return false;
    }
  }

  Future<bool> removeCartItem(BuildContext context, int cartItemId) async {
    if (isRemovingItem(cartItemId)) return false;
    final l10n = AppLocalizations.of(context)!;
    _emitLoaded(
      operation: CartOperation.removingItem,
      activeItemId: cartItemId,
    );

    try {
      await _cartService.removeCartItem(cartItemId);
      _cart = await _cartService.getCart();
      final message = l10n.itemDeletedSuccessfully;
      emit(RemoveFromCartSuccessed(message: message, cart: _cart!));
      _emitLoaded();
      CustomSnackBar.show(context, message);
      return true;
    } catch (e) {
      final message = e.toString();
      emit(
        CartFailure(
          message: message,
          cart: _cart,
          operation: CartOperation.removingItem,
          activeItemId: cartItemId,
        ),
      );
      _emitLoaded();
      CustomSnackBar.show(context, message);
      return false;
    }
  }

  Future<bool> clearCart(BuildContext context) async {
    if ((_cart?.items.isEmpty ?? true) || isClearingCart) return false;
    final l10n = AppLocalizations.of(context)!;
    _emitLoaded(operation: CartOperation.clearingCart);

    try {
      await _cartService.clearCart();
      _cart = await _cartService.getCart();
      final message = l10n.cartClearedSuccessfully;
      emit(DeleteCartSuccessed(message: message));
      _emitLoaded();
      CustomSnackBar.show(context, message);
      return true;
    } catch (e) {
      final message = e.toString();
      emit(
        CartFailure(
          message: message,
          cart: _cart,
          operation: CartOperation.clearingCart,
        ),
      );
      _emitLoaded();
      CustomSnackBar.show(context, message);
      return false;
    }
  }

  Future<bool> updateItemQuantity(
    BuildContext context,
    int itemId,
    int quantity,
  ) async {
    if (quantity < 1 || isUpdatingItem(itemId)) return false;
    final l10n = AppLocalizations.of(context)!;
    _emitLoaded(
      operation: CartOperation.updatingQuantity,
      activeItemId: itemId,
    );

    try {
      await _updateCartItemDetials(itemId, quantity);
      _cart = await _cartService.getCart();
      final message = l10n.itemUpdatedSuccessfully;
      emit(UpdateItemQuantitySuccessed(message: message, cart: _cart!));
      _emitLoaded();
      CustomSnackBar.show(context, message);
      return true;
    } catch (e) {
      final message = e.toString();
      emit(
        CartFailure(
          message: message,
          cart: _cart,
          operation: CartOperation.updatingQuantity,
          activeItemId: itemId,
        ),
      );
      _emitLoaded();
      CustomSnackBar.show(context, message);
      return false;
    }
  }

  Future<bool> updateItemDetials(
    BuildContext context,
    int itemId,
    int quantity,
    String colorId,
    String sizeId,
  ) async {
    if (quantity < 1 || isUpdatingItem(itemId)) return false;
    final l10n = AppLocalizations.of(context)!;
    _emitLoaded(operation: CartOperation.updatingDetails, activeItemId: itemId);

    try {
      await _cartService.updateItemDetials(itemId, quantity, colorId, sizeId);
      _cart = await _cartService.getCart();
      final message = l10n.itemUpdatedSuccessfully;
      emit(UpdateItemDetialsSuccessed(message: message, cart: _cart!));
      _emitLoaded();
      CustomSnackBar.show(context, message);
      return true;
    } catch (e) {
      final message = e.toString();
      emit(
        CartFailure(
          message: message,
          cart: _cart,
          operation: CartOperation.updatingDetails,
          activeItemId: itemId,
        ),
      );
      _emitLoaded();
      CustomSnackBar.show(context, message);
      return false;
    }
  }

  Future<void> changeQuantity(
    BuildContext context,
    String productId,
    int quantity,
  ) async {
    if (quantity < 1) return;
    final itemId = int.tryParse(productId);
    if (itemId == null) return;
    await updateItemQuantity(context, itemId, quantity);
  }

  Future<void> _updateCartItemDetials(int itemId, int quantity) async {
    final item = _cartItemById(itemId);
    await _cartService.updateItemDetials(
      itemId,
      quantity,
      _optionId(item?.colorOption),
      _optionId(item?.sizeOption),
    );
  }

  CartItemApiModel? _cartItemById(int itemId) {
    final items = _cart?.items ?? const <CartItemApiModel>[];
    for (final item in items) {
      if (item.id == itemId) return item;
    }
    return null;
  }

  String _optionId(CartItemOptionApiModel? option) {
    return option?.optionId?.toString() ?? '';
  }

  void _emitLoading({
    CartOperation operation = CartOperation.none,
    int? activeItemId,
  }) {
    if (_cart == null) {
      _operation = operation;
      _activeItemId = activeItemId;
      emit(const CartLoading());
      return;
    }
    _emitLoaded(operation: operation, activeItemId: activeItemId);
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

  Future<void> sendCoupon(BuildContext context, String code) async {
    final l10n = AppLocalizations.of(context)!;
    _emitLoading(operation: CartOperation.applyingCoupon);
    try {
      await _cartService.postCoupon(code: code);
      _cart = await _cartService.getCart();
      final message = l10n.couponAppliedSuccessfully;
      emit(CouponSent(message: message));
      _emitLoaded();
      CustomSnackBar.show(context, message);
    } catch (e) {
      final message = e.toString();
      emit(
        CartFailure(
          message: message,
          cart: _cart,
          operation: CartOperation.applyingCoupon,
        ),
      );
      if (_cart != null) _emitLoaded();
      CustomSnackBar.show(context, message);
    }
  }

  Future<void> removeCoupon(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    _emitLoading(operation: CartOperation.removingCoupon);
    try {
      await _cartService.removeCoupon();
      _cart = await _cartService.getCart();
      final message = l10n.couponRemovedSuccessfully;
      emit(CouponRemoved(message: message));
      _emitLoaded();
      CustomSnackBar.show(context, message);
    } catch (e) {
      final message = e.toString();
      emit(
        CartFailure(
          message: message,
          cart: _cart,
          operation: CartOperation.removingCoupon,
        ),
      );
      if (_cart != null) _emitLoaded();
      CustomSnackBar.show(context, message);
    }
  }
}
