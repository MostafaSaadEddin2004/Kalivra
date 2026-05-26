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

  Future<ProductModel> getProductById(int productId) async {
    final res = await _client.get('products/$productId');
    final data = res.data['data'];
    return ProductModel.fromJson(data);
  }

  Future<List<ProductModel>> getProductByCategoryId(int categoryId) async {
    final res = await _client.get('products/category/$categoryId');
    final data = res.data['data'];
    return (data as List).map((e) => ProductModel.fromJson(e)).toList();
  }
}
