import 'package:kalivra/core/network/dio_client.dart';
import 'package:kalivra/model/wishlist/wishlist_api_model.dart';

class WishlistApiService {
  WishlistApiService();
  final DioClient _client = DioClient();

  Future<List<WishlistApiModel>> getWishlist() async {
    final res = await _client.get('wishlist');
    final data = res.data['data'];
    if (data is List) {
      return data
          .map((e) => WishlistApiModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  Future<void> addToWishlist(int productId) async {
    await _client.post(
      'wishlist',
      data: {'product_id': productId},
    );
  }

  Future<void> removeFromWishlist(int itemId) async {
    await _client.delete('wishlist/$itemId');
  }
}
