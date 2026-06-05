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

  Future<Response> login({
    required String phone,
    required String password,
    String? referralCode,
  }) async {
    final res = await _client.post(
      'customer/login',
      data: {
        'whatsapp_number': phone,
        'password': password,
        'referral_code_input': referralCode ?? '',
      },
    );

    if (res.statusCode! >= 200 || res.statusCode! < 300) {
      final token = res.data['data']['token'];
      await LocalStore.setToken(token);
      return res;
    }else if (res.statusCode == 403 &&
        res.data['message'].toLowerCase().contains('Please check your credentials and try again')) {
      throw 'INVALID_CREDENTIALS';
    } else if (res.statusCode! == 403 &&
        res.data['message'].toLowerCase().contains(
          'Verify your email account first',
        )) {
      throw 'EMAIL_NOT_VERIFIED';
    }
    throw res.data['message'].isNotEmpty
        ? res.data['message']
        : 'حدث خطأ غير متوقع';
  }

  Future<Map<String, dynamic>?> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
    required String passwordConfirmation,
    String? referralCode,
  }) async {
    final Map<String, dynamic> body = {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'whatsapp_number': phone,
      'password': password,
      'password_confirmation': passwordConfirmation,
      'referral_code_input': referralCode ?? '',
    };

    final res = await _client.post('customer/register', data: body);
    if (res.statusCode! >= 200 && res.statusCode! < 300) {
      final token = res.data['token'];
      debugPrint("Here is the token: $token");
      await LocalStore.setToken(token);
      return res.data;
    } else if (res.statusCode! == 422 &&
        res.data['message'].toLowerCase().contains(
          'The email has already been taken',
        )) {
      throw 'EMAIL_EXISTS';
    } else if (res.statusCode! == 422 &&
        res.data['message'].toLowerCase().contains(
          'The phone has already been taken',
        )) {
      throw 'NUMBER_EXISTS';
    }

    throw res.data['message'].isNotEmpty
        ? res.data['message']
        : 'حدث خطأ غير متوقع';
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
