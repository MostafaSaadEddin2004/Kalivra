import 'package:kalivra/core/network/dio_client.dart';

class CheckoutApiService {
  CheckoutApiService();
  final DioClient _client = DioClient();

  Future<Map<String, dynamic>?> checkout(Map<String, dynamic> body) async {
    final res = await _client.post<Map<String, dynamic>>('checkout', data: body);
    return res;
  }
}
