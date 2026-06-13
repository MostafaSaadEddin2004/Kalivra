import 'package:kalivra/core/network/dio_client.dart';
import 'package:kalivra/model/cart/cart_api_model.dart';

class CartApiService {
  CartApiService();

  final DioClient _client = DioClient();

  Future<CartApiModel?> getCart() async {
    final res = await _client.get('checkout/cart');
    final data = res.data['data'];
    if (data is Map<String, dynamic>) {
      return CartApiModel.fromJson(data);
    }
    return null;
  }

  Future<CartApiModel?> addToCart({
    required int productId,
    required int quantity,
    bool isBuyNow = false,
  }) async {
    final res = await _client.post(
      'checkout/cart',
      data: {
        'product_id': productId.toString(),
        'is_buy_now': isBuyNow ? '1' : '0',
        'quantity': quantity.toString(),
      },
    );
    final data = res.data['data'];
    if (data is Map<String, dynamic>) {
      return CartApiModel.fromJson(data);
    }
    return null;
  }

  Future<void> removeCartItem(int cartItemId) async {
    await _client.delete(
      'checkout/cart',
      data: {'cart_item_id': cartItemId.toString()},
    );
  }

  Future<void> removeSelectedItems(List<int> cartItemIds) async {
    if (cartItemIds.isEmpty) return;
    await _client.delete(
      'checkout/cart/selected',
      data: {'ids': cartItemIds},
    );
  }
}
