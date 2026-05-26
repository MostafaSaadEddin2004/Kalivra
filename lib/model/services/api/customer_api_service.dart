import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:kalivra/controller/prefs/local_store.dart';
import 'package:kalivra/core/network/dio_client.dart';
import 'package:kalivra/model/customer/customer_api_model.dart';

class CustomerApiService {
  CustomerApiService();
  final DioClient _client = DioClient();

  static const int maxProfileImageBytes = 5 * 1024 * 1024;

  static String basename(String path) {
    final normalized = path.replaceAll('\\', '/');
    final i = normalized.lastIndexOf('/');
    return i >= 0 ? normalized.substring(i + 1) : path;
  }

  Future<CustomerApiModel> getProfile() async {
    final res = await _client.get('customer');
    final data = res.data['data'];
    return CustomerApiModel.fromJson(data);
  }

  Future<Response> login(String email, String password) async {
    final res = await _client.post(
      'customer/login',
      data: {'email_or_phone': email, 'password': password},
    );
    final token = res.data['data']['token'];
    if (token != null || token.isNotEmpty) {
      await LocalStore.setToken(token);
    }
    if (res.statusCode! >= 200 || res.statusCode! < 300) {
            return res;
    }
    if(res.statusCode! >=400 || res.statusCode! <500){
      final errorMessage = res.data['message'];
      throw Exception(errorMessage);
    }else{
      debugPrint(res.data);
      return res.data;
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
      final token = res.data['data']['token'];
      if (token != null || token.isNotEmpty) {
        await LocalStore.setToken(token);
      }
      return res.data;
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

  Future<bool> updateProfile({
    required String name,
    required String email,
    required String phone,
    required String address,
    required String city,
    required String country,
    String? postalCode,
    String? firstName,
    String? lastName,
    String? gender,
    String? dateOfBirth,
    File? avatarFile,
  }) async {
    if (avatarFile != null) {
      final length = await avatarFile.length();
      if (length > maxProfileImageBytes) {
        throw Exception(
          'Profile image must be ${maxProfileImageBytes ~/ (1024 * 1024)} MB or smaller.',
        );
      }
    }

    final Map<String, dynamic> fields = {
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'city': city,
      'country': country,
      if (postalCode != null && postalCode.trim().isNotEmpty)
        'postal_code': postalCode.trim(),
      if (firstName != null && firstName.trim().isNotEmpty)
        'first_name': firstName.trim(),
      if (lastName != null && lastName.trim().isNotEmpty)
        'last_name': lastName.trim(),
      if (gender != null && gender.trim().isNotEmpty) 'gender': gender.trim(),
      if (dateOfBirth != null && dateOfBirth.trim().isNotEmpty)
        'date_of_birth': dateOfBirth.trim(),
    };

    try {
      if (avatarFile != null) {
        final formData = FormData.fromMap({
          ...fields,
          'avatar': await MultipartFile.fromFile(
            avatarFile.path,
            filename: basename(avatarFile.path),
          ),
        });
        await _client.put('customer', data: formData);
      } else {
        await _client.put('customer', data: fields);
      }
      return true;
    } on DioException catch (e) {
      return false;
    }
  }
}
