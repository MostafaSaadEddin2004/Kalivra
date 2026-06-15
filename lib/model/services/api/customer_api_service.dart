import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:kalivra/controller/prefs/local_store.dart';
import 'package:kalivra/controller/prefs/pref_keys.dart';
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
    final res = await _client.get('customer/profile');
    final json = res.data['data'];
    debugPrint("Here is the json: $json");
    return CustomerApiModel.fromJson(json);
  }

  Future<void> login({required String phone, required String password}) async {
    final res = await _client.post(
      'customer/login',
      data: {'whatsapp_number': phone, 'password': password},
    );

    if (res.statusCode! >= 200 && res.statusCode! < 300) {
      final token = res.data[PrefKeys.tokenKey];
      await LocalStore.setToken(token);
      return res.data;
    }
    if (res.statusCode! == 422 && res.data['message'].contains('credential')) {
      throw 'INVALID_CREDENTIALS';
    }

    if (res.statusCode! == 403 && res.data['message'].contains('verified')) {
      throw 'EMAIL_NOT_VERIFIED';
    }

    if (res.statusCode! == 422 && res.data['message'].contains('incorrect')) {
      throw 'INCORRECT_PASSWORD';
    }

    if (res.statusCode! == 422 && res.data['message'].contains('registered')) {
      throw 'ACCOUNT_NOT_FOUND';
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
    final res = await _client.post('customer/logout');

    if (res.statusCode! >= 200 && res.statusCode! < 300) {
      await LocalStore.removeToken();
    } else if (res.statusCode! >= 400 && res.statusCode! < 500) {
      final message = res.data['message'];
      throw message;
    } else {
      throw res.data['message'].isNotEmpty
          ? res.data['message']
          : 'حدث خطأ غير متوقع';
    }
  }

  Future<void> verifyOtp({
    required String otp,
    required String whatsappNumber,
    String? email,
    required String token,
  }) async {
    try {
      final res = await _client.post(
        'customer/verify',
        data: {
          'email': email ?? '',
          'token': token,
          'otp': otp,
          'whatsapp_number': whatsappNumber,
        },
      );

      if (res.statusCode! >= 200 && res.statusCode! < 300) {
        final newToken = res.data['token'];
        await LocalStore.setToken(newToken);
      }
    } on DioException catch (e) {
      throw '';
    }
  }

  Future<void> resendOtp({
    required String whatsappNumber,
    String? email,
    String? token,
    String purpose = 'login',
  }) async {
    try {
      final res = await _client.post(
        'customer/resend-otp',
        data: {
          'whatsapp_number': whatsappNumber,
          'email': email ?? '',
          'token': token ?? '',
          'purpose': purpose,
        },
      );

      if (res.statusCode != null &&
          res.statusCode! >= 200 &&
          res.statusCode! < 300) {
        return;
      }

      final message = res.data is Map ? res.data['message'] : null;
      throw message?.toString().isNotEmpty == true
          ? message.toString()
          : 'حدث خطأ غير متوقع';
    } on DioException catch (e) {
      final message = e.response?.data is Map
          ? e.response?.data['message']?.toString()
          : null;
      throw message?.isNotEmpty == true ? message! : 'حدث خطأ غير متوقع';
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
    String? fatherName,
    String? motherName,
    String? nationalId,
    String? whatsappNumber,
    String? gender,
    String? dateOfBirth,
    int? permanentCapitalId,
    int? permanentCityId,
    int? permanentTownId,
    int? permanentVillageId,
    String? officialGovernorate,
    String? officialCity,
    String? officialTown,
    String? officialMunicipalityVillage,
    String? officialStreet,
    String? officialBuilding,
    String? permanentAddress,
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
      if (fatherName != null && fatherName.trim().isNotEmpty)
        'father_name': fatherName.trim(),
      if (motherName != null && motherName.trim().isNotEmpty)
        'mother_name': motherName.trim(),
      if (nationalId != null && nationalId.trim().isNotEmpty)
        'national_id': nationalId.trim(),
      if (whatsappNumber != null && whatsappNumber.trim().isNotEmpty)
        'whatsapp_number': whatsappNumber.trim(),
      if (gender != null && gender.trim().isNotEmpty) 'gender': gender.trim(),
      if (dateOfBirth != null && dateOfBirth.trim().isNotEmpty)
        'date_of_birth': dateOfBirth.trim(),
      'permanent_capital_id': ?permanentCapitalId,
      'permanent_city_id': ?permanentCityId,
      'permanent_town_id': ?permanentTownId,
      'permanent_village_id': ?permanentVillageId,
      if (officialGovernorate != null && officialGovernorate.trim().isNotEmpty)
        'official_governorate': officialGovernorate.trim(),
      if (officialCity != null && officialCity.trim().isNotEmpty)
        'official_city': officialCity.trim(),
      if (officialTown != null && officialTown.trim().isNotEmpty)
        'official_town': officialTown.trim(),
      if (officialMunicipalityVillage != null &&
          officialMunicipalityVillage.trim().isNotEmpty)
        'official_municipality_village': officialMunicipalityVillage.trim(),
      if (officialStreet != null && officialStreet.trim().isNotEmpty)
        'official_street': officialStreet.trim(),
      if (officialBuilding != null && officialBuilding.trim().isNotEmpty)
        'official_building': officialBuilding.trim(),
      if (permanentAddress != null && permanentAddress.trim().isNotEmpty)
        'permanent_address': permanentAddress.trim(),
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
