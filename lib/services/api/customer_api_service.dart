import 'package:kalivra/core/network/dio_client.dart';
import 'package:kalivra/models/api/customer_api_model.dart';

class CustomerApiService {
  CustomerApiService(this._client);
  final DioClient _client;

  Future<CustomerApiModel?> getProfile() async {
    final res = await _client.get<Map<String, dynamic>>('customer');
    final data = res['data'];
    if (data is Map<String, dynamic>) {
      return CustomerApiModel.fromJson(data);
    }
    return null;
  }

  Future<Map<String, dynamic>?> login(String email, String password) async {
    final res = await _client.post<Map<String, dynamic>>(
      'customer/login',
      data: {'email': email, 'password': password},
    );
    return res;
  }

  Future<Map<String, dynamic>?> register(Map<String, dynamic> body) async {
    final res = await _client.post<Map<String, dynamic>>(
      'customer/register',
      data: body,
    );
    return res;
  }
}
