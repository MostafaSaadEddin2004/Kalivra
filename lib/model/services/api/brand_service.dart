import 'package:kalivra/core/network/dio_client.dart';
import 'package:kalivra/model/brand/brand_model.dart';
import 'package:kalivra/model/product/product_model.dart';

class BrandApiService {
  BrandApiService();
  final DioClient _client = DioClient();

  Future<List<BrandModel>> getAllBrands() async {
    final res = await _client.get('brands');
    final data = (res.data['data'] as List<dynamic>)
        .map((e) => BrandModel.fromJson(e))
        .toList();
    return data;
  }

  Future<BrandModel> getBrandById(int productId) async {
    final res = await _client.get('brands/$productId');
    final data = res.data['data'];
    return BrandModel.fromJson(data);
  }

  Future<List<ProductModel>> getProductsByBrandId(int categoryId) async {
    final res = await _client.get('products/brand/$categoryId');
    final data = (res.data['data'] as List<dynamic>)
        .map((e) => ProductModel.fromJson(e))
        .toList();
    return data;
  }
}
