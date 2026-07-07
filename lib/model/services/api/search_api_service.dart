import 'package:kalivra/core/network/dio_client.dart';
import 'package:kalivra/model/search/search_result_model.dart';

class SearchApiService {
  SearchApiService();

  final DioClient _client = DioClient();

  Future<SearchResultModel> search(String query) async {
    final res = await _client.get('search', queryParameters: {'q': query});
    return SearchResultModel.fromJson(res.data as Map<String, dynamic>);
  }
}
