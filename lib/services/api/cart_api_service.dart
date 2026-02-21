import 'package:kalivra/core/network/dio_client.dart';
import 'package:kalivra/models/api/cart_api_model.dart';

class CartApiService {
  CartApiService(this._client);
  final DioClient _client;

  Future<CartApiModel?> getCart() async {
    final res = await _client.get<Map<String, dynamic>>('cart');
    final data = res['data'];
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
    final res = await _client.post<Map<String, dynamic>>(
      'cart/items',
      data: {'product_id': productId, 'quantity': quantity, 'options': options},
    );
    return res;
  }

  Future<void> updateItem(int itemId, int quantity) async {
    await _client.put<Map<String, dynamic>>(
      'cart/items/$itemId',
      data: {'quantity': quantity},
    );
  }

  Future<void> removeItem(int itemId) async {
    await _client.delete<Map<String, dynamic>>('cart/items/$itemId');
  }
}
