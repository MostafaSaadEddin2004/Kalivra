import 'package:kalivra/core/network/dio_client.dart';
import 'package:kalivra/models/api/product_api_model.dart';

class ProductApiService {
  ProductApiService(this._client);
  final DioClient _client;

  Future<List<ProductApiModel>> getProducts({
    int? page,
    int? perPage,
    int? categoryId,
  }) async {
    final q = <String, dynamic>{};
    if (page != null) q['page'] = page;
    if (perPage != null) q['per_page'] = perPage;
    if (categoryId != null) q['category_id'] = categoryId;
    final res = await _client.get<Map<String, dynamic>>(
      'products',
      queryParameters: q.isNotEmpty ? q : null,
    );
    final data = res['data'];
    if (data is List) {
      return data
          .map((e) => ProductApiModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  Future<ProductApiModel?> getProductById(int id) async {
    final res = await _client.get<Map<String, dynamic>>('products/$id');
    final data = res['data'];
    if (data is Map<String, dynamic>) {
      return ProductApiModel.fromJson(data);
    }
    return null;
  }
}
