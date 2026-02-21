import 'package:kalivra/core/network/dio_client.dart';
import 'package:kalivra/models/api/country_api_model.dart';

class CountryApiService {
  CountryApiService(this._client);
  final DioClient _client;

  Future<List<CountryApiModel>> getCountries() async {
    final res = await _client.get<Map<String, dynamic>>('countries');
    final data = res['data'];
    if (data is List) {
      return data
          .map((e) => CountryApiModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }
}
