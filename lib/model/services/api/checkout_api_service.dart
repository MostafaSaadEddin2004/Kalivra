import 'package:kalivra/core/network/dio_client.dart';

class CheckoutApiService {
  CheckoutApiService(this._client);
  final DioClient _client;

  /// Place order (payload depends on Bagisto: address, shipping, payment).
  Future<Map<String, dynamic>?> checkout(Map<String, dynamic> body) async {
    final res = await _client.post<Map<String, dynamic>>('checkout', data: body);
    return res;
  }
}
