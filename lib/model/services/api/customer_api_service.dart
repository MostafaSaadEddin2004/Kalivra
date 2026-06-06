import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
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
    final raw = res.data['data'];
    if (raw is! Map) {
      throw StateError('Invalid customer profile response');
    }
    return CustomerApiModel.fromJson(Map<String, dynamic>.from(raw));
  }

  Future<Response> login({
    required String phone,
    required String password,
  }) async {
    try {
      final res = await _client.post(
        'customer/login',
        data: {
          'whatsapp_number': phone,
          'password': password,
        },
      );

      if (res.statusCode != null &&
          res.statusCode! >= 200 &&
          res.statusCode! < 300) {
        final token = _extractToken(res.data);
        if (token != null && token.isNotEmpty) {
          await LocalStore.setToken(token);
        }
        return res;
      }

      await _throwLoginFailure(res.statusCode, res.data);
    } on DioException catch (e) {
      await _throwLoginFailure(e.response?.statusCode, e.response?.data);
    }

    throw 'حدث خطأ غير متوقع';
  }

  static String? _extractToken(dynamic data) {
    if (data is! Map) return null;
    final map = Map<String, dynamic>.from(data);
    final direct = map['token'];
    if (direct != null && direct.toString().trim().isNotEmpty) {
      return direct.toString();
    }
    final nested = map['data'];
    if (nested is Map) {
      final token = Map<String, dynamic>.from(nested)['token'];
      if (token != null && token.toString().trim().isNotEmpty) {
        return token.toString();
      }
    }
    return null;
  }

  static String _messageFromBody(dynamic data) {
    if (data is Map) {
      final message = Map<String, dynamic>.from(data)['message'];
      if (message != null && message.toString().trim().isNotEmpty) {
        return message.toString();
      }
    }
    return '';
  }

  Future<void> _throwLoginFailure(int? statusCode, dynamic data) async {
    final message = _messageFromBody(data);
    final normalized = message.toLowerCase();

    if (statusCode == 403) {
      if (normalized.contains('verify your email') ||
          normalized.contains('email account first')) {
        final token = _extractToken(data);
        if (token != null && token.isNotEmpty) {
          await LocalStore.setToken(token);
        }
        throw 'EMAIL_NOT_VERIFIED';
      }
      if (normalized.contains('credentials') ||
          normalized.contains('check your')) {
        throw 'INVALID_CREDENTIALS';
      }
    }

    throw message.isNotEmpty ? message : 'حدث خطأ غير متوقع';
  }

  Future<Map<String, dynamic>?> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String whatsappNumber,
    required String password,
    required String passwordConfirmation,
    String? referralCode,
  }) async {
    final Map<String, dynamic> body = {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'whatsapp_number': whatsappNumber,
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
