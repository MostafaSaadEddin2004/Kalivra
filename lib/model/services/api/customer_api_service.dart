import 'package:dio/dio.dart';
import 'package:kalivra/controller/prefs/local_store.dart';
import 'package:kalivra/core/network/dio_client.dart';
import 'package:kalivra/model/customer/customer_api_model.dart';

class CustomerApiService {
  CustomerApiService();
  final DioClient _client = DioClient();

  Future<CustomerApiModel> getProfile() async {
    final res = await _client.get('customer');
    final data = res['data'];
      return CustomerApiModel.fromJson(data);
  }

  Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final res = await _client.post(
        'customer/login',
        data: {'email': email, 'password': password},
      );
      final token = res['data']['token'];
      if (token != null || token.isNotEmpty) {
        await LocalStore.setToken(token);
      }
      return res;
    } on DioException catch (e) {
      throw Exception(e);
    }
  }

  Future<Map<String, dynamic>?> register(
    String name,
    String email,
    String phone,
    String password,
    String passwordConfirmation,
  ) async {
    final Map<String, dynamic> body = {
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'password_confirmation': passwordConfirmation,
    };

    try {
      final res = await _client.post('customer/register', data: body);
      final token = res['data']['token'];
      if (token != null || token.isNotEmpty) {
        await LocalStore.setToken(token);
      }
      return res;
    } on DioException catch (e) {
      throw Exception(e);
    }
  }

Future<void> logout() async {
    try {
      await _client.post('customer/logout');
      await LocalStore.removeToken();
    } on DioException catch (e) {
      throw Exception(e);
    }
  }

Future<void> updateProfile(
    String name,
    String phone,
    String address,
    String city,
    String country,
  ) async {
    final Map<String, dynamic> body = {
      'name': name,
      'phone': phone,
      'address': address,
      'city': city,
      'country': country,
    };
    try {
      await _client.put('customer', data: body);
    } on DioException catch (e) {
      throw Exception(e);
    }
  }
}
