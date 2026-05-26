import 'package:kalivra/core/network/dio_client.dart';
import 'package:kalivra/model/cart/cart_api_model.dart';

class CartApiService {
  CartApiService(this._client);
  final DioClient _client;

  Future<CartApiModel?> getCart() async {
    final res = await _client.get('cart');
    final data = res.data['data'];
    if (data is Map<String, dynamic>) {
      return CartApiModel.fromJson(data);
    }
    return null;
  }

  Future<Map<String, dynamic>?> addItem({
    required int productId,
    required int quantity,
    Map<String, dynamic>? options,
  }) async {
    final res = await _client.post(
      'cart/items',
      data: {'product_id': productId, 'quantity': quantity, 'options': options},
    );
    return res.data;
  }

Future<void> updateItem(int itemId, int quantity) async {
    await _client.put(
      'cart/items/$itemId',
      data: {'quantity': quantity},
    );
  }

Future<void> removeItem(int itemId) async {
    await _client.delete('cart/items/$itemId');
  }
}
