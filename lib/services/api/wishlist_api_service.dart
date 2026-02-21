import 'package:kalivra/core/network/dio_client.dart';
import 'package:kalivra/models/api/wishlist_api_model.dart';

class WishlistApiService {
  WishlistApiService(this._client);
  final DioClient _client;

  Future<List<WishlistApiModel>> getWishlist() async {
    final res = await _client.get<Map<String, dynamic>>('wishlist');
    final data = res['data'];
    if (data is List) {
      return data
          .map((e) => WishlistApiModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  Future<void> addToWishlist(int productId) async {
    await _client.post<Map<String, dynamic>>(
      'wishlist',
      data: {'product_id': productId},
    );
  }

  Future<void> removeFromWishlist(int itemId) async {
    await _client.delete<Map<String, dynamic>>('wishlist/$itemId');
  }
}
