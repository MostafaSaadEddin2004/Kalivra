import 'package:kalivra/core/network/dio_client.dart';
import 'package:kalivra/models/api/category_api_model.dart';

class CategoryApiService {
  CategoryApiService(this._client);
  final DioClient _client;

  Future<List<CategoryApiModel>> getCategories() async {
    final res = await _client.get<Map<String, dynamic>>('categories');
    final data = res['data'];
    if (data is List) {
      return data
          .map((e) => CategoryApiModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }
}
