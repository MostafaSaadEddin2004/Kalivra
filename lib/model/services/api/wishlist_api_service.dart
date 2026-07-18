import 'package:kalivra/core/network/dio_client.dart';
import 'package:kalivra/model/wishlist/wishlist_api_model.dart';

class WishlistApiService {
  WishlistApiService();
  final DioClient _client = DioClient();

  Future<List<WishlistApiModel>> getWishlist() async {
    final res = await _client.get('customer/wishlist');
    final data = res.data['data'] as List? ?? [];
    return data
        .map((e) => WishlistApiModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> addToWishlist({required int productId}) async {
    await _client.post('customer/wishlist', data: {'product_id': productId});
  }

  Future<void> removeFromWishlist({required int itemId}) async {
    await _client.delete('customer/wishlist/$itemId');
  }

  Future<void> clearWishlist() async {
    await _client.delete('customer/wishlist/all');
  }
}
