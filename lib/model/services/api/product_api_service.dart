import 'package:kalivra/core/network/dio_client.dart';
import 'package:kalivra/model/product/product_model.dart';

class ProductApiService {
  ProductApiService();
  final DioClient _client = DioClient();

  Future<List<ProductModel>> getProducts() async {
    final res = await _client.get('products');
    final data = (res.data['data'] as List<dynamic>)
        .map((e) => ProductModel.fromJson(e))
        .toList();
    return data;
  }

  Future<List<ProductModel>> getSaleProducts() async {
    final res = await _client.get('products/sale');
    final data = (res.data['data'] as List<dynamic>)
        .map((e) => ProductModel.fromJson(e))
        .toList();
    return data;
  }

  Future<ProductModel> getProductById(int productId) async {
    final res = await _client.get('products/$productId');
    final data = res.data['data'];
    return ProductModel.fromJson(data);
  }

  Future<void> postProductReview({
    required int productId,
    required String comment,
    required int rating,
  }) async {
    await _client.post(
      'product/$productId/review',
      data: { 'comment': comment, 'rating': rating},
    );
  }

  Future<List<ProductModel>> getProductsByCategoryId(int categoryId) async {
    final res = await _client.get('products/category/$categoryId');
    final data = res.data['data'];
    return (data as List).map((e) => ProductModel.fromJson(e)).toList();
  }
}
