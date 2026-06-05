import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/controller/blocs/cubit/auth_cubit/auth_state.dart';
import 'package:kalivra/controller/prefs/local_store.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/model/services/api/customer_api_service.dart';
import 'package:kalivra/view/screens/drawer_screens/change_password_screen.dart';
import 'package:kalivra/view/widgets/custom_snack_bar.dart';

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

  Future<void> login({
    required BuildContext context,
    required String phone,
    required String password,
    String? referralCode,
  }) async {
    emit(AuthLoading());
    try {
      await _customerApiService.login(phone: phone, password: password);
      emit(AuthSuccessed(message: 'تم تسجيل الدخول بنجاح'));
    } catch (e) {
      emit(AuthFailed(message: ''));
      CustomSnackBar.show(context, '');
      if (e == 'INVALID_CREDENTIALS') {
        emit(
          AuthFailed(message: 'البريد الإلكتروني أو كلمة المرور غير صحيحة.'),
        );
        CustomSnackBar.show(
          context,
          'البريد الإلكتروني أو كلمة المرور غير صحيحة.',
        );
      } else if (e == 'EMAIL_NOT_VERIFIED') {
        context.goNamed(
          '',
          extra: {
            {'email': phone},
          },
        );
        emit(AuthFailed(message: ''));
      } else {
        emit(AuthFailed(message: e.toString()));
        CustomSnackBar.show(context, e.toString());
      }
    }
  }

  Future<void> register({
    required BuildContext context,
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
    required String passwordConfirmation,
    String? referralCode,
  }) async {
    emit(AuthLoading());
    try {
      final data = await _customerApiService.register(
        firstName: firstName,
        lastName: lastName,
        email: email,
        phone: phone,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );
      final token = data?['token']?.toString() ?? await LocalStore.getToken();
      if (!context.mounted) return;
      context.go(
        AppRoutes.completeProfile,
        extra: OtpOnboardingArgs(
          mode: OtpScreenMode.signUp,
          phone: phone,
          email: email,
          token: token,
          name: '$firstName $lastName'.trim(),
          password: password,
          referralCode: referralCode,
        ),
      );
      emit(AuthSuccessed(message: 'تم تسجيل الدخول بنجاح'));
    } catch (e) {
      if (e == 'EMAIL_EXISTS') {
        emit(AuthFailed(message: 'البريد الإلكتروني مستخدم بالفعل.'));
        CustomSnackBar.show(context, 'البريد الإلكتروني مستخدم بالفعل.');
      }
      if (e == 'NUMBER_EXISTS') {
        emit(AuthFailed(message: 'رقم الهاتف مستخدم بالفعل.'));
        CustomSnackBar.show(context, 'رقم الهاتف مستخدم بالفعل.');
      } else {
        emit(AuthFailed(message: e.toString()));
        CustomSnackBar.show(context, e.toString());
      }
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
