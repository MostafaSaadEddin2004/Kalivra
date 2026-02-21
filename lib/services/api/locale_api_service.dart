import 'package:kalivra/core/network/dio_client.dart';
import 'package:kalivra/models/api/locale_api_model.dart';

class LocaleApiService {
  LocaleApiService(this._client);
  final DioClient _client;

  Future<List<LocaleApiModel>> getLocales() async {
    final res = await _client.get<Map<String, dynamic>>('locales');
    final data = res['data'];
    if (data is List) {
      return data
          .map((e) => LocaleApiModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }
}
