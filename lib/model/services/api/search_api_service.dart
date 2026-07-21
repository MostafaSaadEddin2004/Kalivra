import 'package:kalivra/core/network/dio_client.dart';
import 'package:kalivra/model/search/search_history_model.dart';
import 'package:kalivra/model/search/search_result_model.dart';

class SearchApiService {
  SearchApiService();

  final DioClient _client = DioClient();

  Future<SearchResultModel> search(String query) async {
    final res = await _client.get('search', queryParameters: {'q': query});
    final data = res.data['data'];
    return SearchResultModel.fromJson(data);
  }

  Future<void> postSearchHistory(String query) async {
    await _client.post('customer/search-history', data: {'query': query});
  }

  Future<List<SearchHistoryModel>> getSearchHistory() async {
    final res = await _client.get('customer/search-history');
    final data = res.data['data'];
    if (data is! List) return const [];
    return data
        .whereType<Map>()
        .map(
          (item) =>
              SearchHistoryModel.fromJson(Map<String, dynamic>.from(item)),
        )
        .where((item) => item.query.trim().isNotEmpty)
        .toList();
  }
}
