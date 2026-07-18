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
    required int cartItemId,
    required int quantity,
    String color = '',
    String size = '',
    bool isBuyNow = false,
  }) async {
    final res = await _client.post(
      'checkout/cart',
      data: {
        'cart_item_id': cartItemId,
        'quantity': quantity,
        'color': color,
        'size': size,
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
    await _client.delete('checkout/cart/all');
  }
}
