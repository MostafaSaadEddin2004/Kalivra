import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kalivra/controller/blocs/cubit/auth_cubit/auth_state.dart';
import 'package:kalivra/controller/prefs/local_store.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/model/services/api/customer_api_service.dart';

export 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthLoading());

  final CustomerApiService _customerApiService = CustomerApiService();

  Future<void> checkAuthStatus(BuildContext context) async {
    final token = await LocalStore.getToken();
    if (token == null || token.isEmpty) {
      emit(
        UnAuthinticated(
          message: AppLocalizations.of(context)!.loginToViewProfile,
        ),
      );
    }
  }

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      await _customerApiService.login(email, password);
      emit(AuthSuccessed(message: 'تم تسجيل الدخول بنجاح'));
    } catch (e) {
      emit(AuthFailed(message: e.toString()));
    }
  }

  Future<void> register(
    String name,
    String email,
    String phone,
    String password,
    String passwordConfirmation,
  ) async {
    emit(AuthLoading());
    try {
      await _customerApiService.register(
        name,
        email,
        phone,
        password,
        passwordConfirmation,
      );
      emit(AuthSuccessed(message: 'تم تسجيل الدخول بنجاح'));
    } catch (e) {
      emit(AuthFailed(message: e.toString()));
    }
  }

  Future<void> loadProfile() async {
    emit(AuthLoading());
    try {
      final customerInfo = await _customerApiService.getProfile();
      emit(AuthFetchedData(customer: customerInfo));
    } catch (e) {
      emit(AuthFailed(message: e.toString()));
    }
  }

  Future<void> logout() async {
    emit(AuthLoading());
    try {
      await _customerApiService.logout();
      emit(AuthSuccessed(message: 'تم تسجيل الخروج بنجاح'));
    } catch (e) {
      emit(AuthFailed(message: e.toString()));
    }
  }

  Future<void> updateProfile({
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
    emit(AuthLoading());
    try {
      await _customerApiService.updateProfile(
        name: name,
        email: email,
        phone: phone,
        address: address,
        city: city,
        country: country,
        postalCode: postalCode,
        firstName: firstName,
        lastName: lastName,
        gender: gender,
        dateOfBirth: dateOfBirth,
        avatarFile: avatarFile,
      );
      emit(AuthSuccessed(message: 'تم تحديث البيانات بنجاح'));
      await loadProfile();
    } catch (e) {
      emit(AuthFailed(message: e.toString()));
      throw Exception(e);
    }
  }
}
