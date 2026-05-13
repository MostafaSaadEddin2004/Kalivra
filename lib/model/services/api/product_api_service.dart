import 'package:kalivra/core/network/dio_client.dart';
import 'package:kalivra/model/product/product_model.dart';

class ProductApiService {
  ProductApiService();
  final DioClient _client = DioClient();

  Future<List<ProductModel>> getProducts({int? categoryId}) async {
    final q = <String, dynamic>{};
    if (categoryId != null) q['category_id'] = categoryId;
    final res = await _client.get<Map<String, dynamic>>(
      'products',
      queryParameters: q.isNotEmpty ? q : null,
    );
    final data = res['data'];
    if (data is List) {
      return data
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  Future<ProductModel> getProductById(int productId) async {
    final res = await _client.get<Map<String, dynamic>>('products/$productId');
    final data = res['data'];
    return ProductModel.fromJson(data);
  }
}
