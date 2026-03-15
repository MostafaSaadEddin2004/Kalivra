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

  Future<void> updateProfile(
    String name,
    String phone,
    String address,
    String city,
    String country,
  ) {
    emit(AuthLoading());
    try {
      final data = _customerApiService.updateProfile(
        name,
        phone,
        address,
        city,
        country,
      );
      emit(AuthSuccessed(message: 'تم تحديث البيانات بنجاح'));
      return data;
    } catch (e) {
      emit(AuthFailed(message: e.toString()));
      throw Exception(e);
    }
  }
}
