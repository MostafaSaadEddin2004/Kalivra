import 'package:kalivra/core/network/dio_client.dart';
import 'package:kalivra/models/api/currency_api_model.dart';

class CurrencyApiService {
  CurrencyApiService(this._client);
  final DioClient _client;

  Future<List<CurrencyApiModel>> getCurrencies() async {
    final res = await _client.get<Map<String, dynamic>>('currencies');
    final data = res['data'];
    if (data is List) {
      return data
          .map((e) => CurrencyApiModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }
}
