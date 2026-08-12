import 'package:kalivra/core/network/dio_client.dart';
import 'package:kalivra/model/cart/cart_api_model.dart';

class CartApiService {
  CartApiService();

  final DioClient _client = DioClient();

  Future<CartApiModel> getCart() async {
    final res = await _client.get('checkout/cart');
    final data = CartApiResponseModel.fromJson(
      Map<String, dynamic>.from(res.data as Map),
    );
    return data.cart ?? const CartApiModel();
  }

  Future<CartApiModel?> addToCart({
    required int productId,
    required int quantity,
    String color = '',
    String size = '',
    bool isBuyNow = false,
  }) async {
    final res = await _client.post(
      'checkout/cart',
      data: {
        'product_id': productId,
        'quantity': quantity,
        'color': color,
        'size': size,
      },
    );
    return CartApiResponseModel.fromJson(
      Map<String, dynamic>.from(res.data as Map),
    ).cart;
  }

  Future<void> updateItemQuantity(int itemId, int quantity) async {
    await _client.put(
      'checkout/cart',
      data: {
        "qty": {'$itemId': quantity},
      },
    );
  }

  Future<void> updateItemDetials(
    int itemId,
    int quantity,
    String colorId,
    String sizeId,
  ) async {
    await _client.patch(
      'checkout/cart/items',
      data: {
        "cart_item_id": itemId,
        "quantity": quantity,
        "color": colorId,
        "size": sizeId,
      },
    );
  }

  Future<void> removeCartItem(int cartItemId) async {
    await _client.delete(
      'checkout/cart',
      data: {'cart_item_id': cartItemId.toString()},
    );
  }

  Future<void> clearCart() async {
    await _client.delete('checkout/cart/all');
  }

  Future<void> postCoupon({required String code}) async {
    await _client.post('checkout/cart/coupon', data: {'code': code});
  }

  Future<void> removeCoupon() async {
    await _client.delete('checkout/cart/coupon');
  }
}
