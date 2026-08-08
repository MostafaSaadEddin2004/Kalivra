import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/controller/blocs/cubit/auth_cubit/auth_state.dart';
import 'package:kalivra/controller/prefs/local_store.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/core/network/api_exception.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/model/services/api/customer_api_service.dart';
import 'package:kalivra/view/screens/auth/auth_otp_screen.dart';
import 'package:kalivra/view/screens/profile_screens/change_password_screen.dart';
import 'package:kalivra/view/widgets/custom_snack_bar.dart';

export 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthLoading());

  final CustomerApiService _customerApiService = CustomerApiService();

  Future<void> login({
    required BuildContext context,
    required String phone,
    required String password,
  }) async {
    emit(AuthLoading());
    final l10n = AppLocalizations.of(context)!;
    try {
      
      await _customerApiService.login(
        phone: phone,
        password: password,
      );
      if (!context.mounted) return;
      emit(AuthSuccessed(message: l10n.loginSuccess));
      context.go(AppRoutes.home);
    } catch (e) {
      final apiError = e is ApiException ? e : null;
      final errorCode = apiError?.code ?? e.toString();
      final errorMessage = apiError?.message ?? e.toString();

      if (errorCode == 'ACCOUNT_NOT_VERIFIED') {
        final token =
            apiError?.data?['token']?.toString() ?? await LocalStore.getToken();
        context.goNamed(
          AppRoutesName.authOtp,
          extra: AuthOtpArgs(
            email: phone,
            phone: phone,
            token: token,
            purpose: 'login',
          ),
        );
        emit(AuthFailed(message: errorMessage));
        return;
      }

      if (!context.mounted) return;
      if (errorCode == 'INVALID_CREDENTIALS') {
        emit(AuthFailed(message: errorMessage));
        CustomSnackBar.show(context, errorMessage);
        return;
      } else if (errorCode == 'EMAIL_NOT_VERIFIED') {
        final token = await LocalStore.getToken();
        if (!context.mounted) return;
        context.goNamed(
          AppRoutesName.authOtp,
          extra: AuthOtpArgs(
            email: phone,
            phone: phone,
            token: token,
            purpose: 'login',
          ),
        );
        emit(AuthFailed(message: 'Email is not verfied.'));
        return;
      } else if (errorCode == 'INCORRECT_PASSWORD') {
        emit(AuthFailed(message: errorMessage));
        CustomSnackBar.show(context, errorMessage);
        return;
      } else if (errorCode == 'ACCOUNT_NOT_FOUND') {
        emit(AuthFailed(message: errorMessage));
        CustomSnackBar.show(context, errorMessage);
        return;
      }
      emit(AuthFailed(message: errorMessage));
      CustomSnackBar.show(context, errorMessage);
    }
  }

  Future<void> resendOtp({
    required BuildContext context,
    required String whatsappNumber,
    String? email,
    String? token,
    String purpose = 'login',
  }) async {
    try {
      final storedToken = token ?? await LocalStore.getToken();
      await _customerApiService.resendOtp(
        whatsappNumber: whatsappNumber,
        email: email,
        token: storedToken,
        purpose: purpose,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> verifyOtp({
    required BuildContext context,
    required String otp,
    required String whatsappNumber,
    String purpose = 'login',
    String? name,
    String? password,
    String? referralCode,
  }) async {
    emit(AuthLoading());
    final l10n = AppLocalizations.of(context)!;
    try {
      await _customerApiService.verifyOtp(
        otp: otp,
        whatsappNumber: whatsappNumber,
      );
      if (!context.mounted) return;
      emit(VerifySuccessed(message: l10n.authOtpVerifySuccess));
      if (purpose == 'register') {
        context.go(
          AppRoutes.completeProfile,
          extra: OtpOnboardingArgs(
            mode: OtpScreenMode.signUp,
            whatsappNumber: whatsappNumber,
            name: name,
            password: password,
            referralCode: referralCode,
          ),
        );
        return;
      }
      context.go(AppRoutes.home);
    } catch (e) {
      final message = e is ApiException ? e.message : e.toString();
      emit(AuthFailed(message: message));
      if (context.mounted) {
        CustomSnackBar.show(context, message);
      }
    }
  }

  Future<void> register({
    required BuildContext context,
    required String firstName,
    required String lastName,
    required String email,
    required String whatsappNumber,
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
        whatsappNumber: whatsappNumber,
        password: password,
        passwordConfirmation: passwordConfirmation,
        referralCode: referralCode,
      );
      final token = data?['token']?.toString() ?? await LocalStore.getToken();
      emit(AuthSuccessed(message: 'تم تسجيل الدخول بنجاح'));
      context.go(
        AppRoutesName.authOtp,
        extra: AuthOtpArgs(
          email: email,
          phone: whatsappNumber,
          token: token,
          name: '$firstName $lastName'.trim(),
          password: password,
          referralCode: referralCode,
          purpose: 'register',
        ),
      );
    } catch (e) {
      final apiError = e is ApiException ? e : null;
      final errorCode = apiError?.code ?? e.toString();
      final errorMessage = apiError?.message ?? e.toString();
      if (errorCode == 'EMAIL_EXISTS') {
        emit(AuthFailed(message: errorMessage));
      } else if (errorCode == 'NUMBER_EXISTS') {
        emit(AuthFailed(message: errorMessage));
      } else {
        emit(AuthFailed(message: errorMessage));
      }
      if (context.mounted) {
        CustomSnackBar.show(context, errorMessage);
      }
    }
  }

  Future<void> sendWhatsappOtp({
    required BuildContext context,
    required String whatsappNumber,
  }) async {
    emit(AuthLoading());
    try {
      await _customerApiService.sendWhatsappOtp(whatsappNumber: whatsappNumber);
      if (!context.mounted) return;
      emit(AuthSuccessed(message: 'OTP sent successfully'));
    } catch (e) {
      if (!context.mounted) return;
      emit(AuthFailed(message: e.toString()));
      CustomSnackBar.show(context, e.toString());
      rethrow;
    }
  }

  Future<void> verifyWhatsappOtp({
    required BuildContext context,
    required String whatsappNumber,
    required String otp,
  }) async {
    emit(AuthLoading());
    try {
      await _customerApiService.verifyWhatsappOtp(
        whatsappNumber: whatsappNumber,
        otp: otp,
      );
      if (!context.mounted) return;
      emit(VerifySuccessed(message: 'OTP verified successfully'));
    } catch (e) {
      if (!context.mounted) return;
      emit(AuthFailed(message: e.toString()));
      CustomSnackBar.show(context, e.toString());
      rethrow;
    }
  }

  Future<void> changeWhatsappNumber({
    required BuildContext context,
    required String whatsappNumber,
  }) async {
    emit(AuthLoading());
    try {
      await _customerApiService.changeWhatsappNumber(
        whatsappNumber: whatsappNumber,
      );
      if (!context.mounted) return;
      emit(AuthSuccessed(message: 'WhatsApp number changed successfully'));
    } catch (e) {
      if (!context.mounted) return;
      emit(AuthFailed(message: e.toString()));
      CustomSnackBar.show(context, e.toString());
      rethrow;
    }
  }

  Future<void> sendPasswordOtp({
    required BuildContext context,
    required String whatsappNumber,
  }) async {
    emit(AuthLoading());
    try {
      await _customerApiService.sendPasswordOtp(whatsappNumber: whatsappNumber);
      if (!context.mounted) return;
      emit(AuthSuccessed(message: 'OTP sent successfully'));
    } catch (e) {
      if (!context.mounted) return;
      emit(AuthFailed(message: e.toString()));
      CustomSnackBar.show(context, e.toString());
      rethrow;
    }
  }

  Future<void> verifyPasswordOtp({
    required BuildContext context,
    required String whatsappNumber,
    required String otp,
  }) async {
    emit(AuthLoading());
    try {
      await _customerApiService.verifyPasswordOtp(
        whatsappNumber: whatsappNumber,
        otp: otp,
      );
      if (!context.mounted) return;
      emit(VerifySuccessed(message: 'OTP verified successfully'));
    } catch (e) {
      if (!context.mounted) return;
      emit(AuthFailed(message: e.toString()));
      CustomSnackBar.show(context, e.toString());
      rethrow;
    }
  }

  Future<void> changePasswordByWhatsapp({
    required BuildContext context,
    required String whatsappNumber,
    required String password,
    required String passwordConfirmation,
  }) async {
    emit(AuthLoading());
    try {
      await _customerApiService.changePasswordByWhatsapp(
        whatsappNumber: whatsappNumber,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );
      if (!context.mounted) return;
      emit(AuthSuccessed(message: 'Password updated successfully'));
    } catch (e) {
      if (!context.mounted) return;
      emit(AuthFailed(message: e.toString()));
      CustomSnackBar.show(context, e.toString());
      rethrow;
    }
  }

  Future<void> loadProfile(BuildContext context) async {
    final token = await LocalStore.getToken();
    if (token == null || token.isEmpty) {
      emit(
        UnAuthinticated(
          message: AppLocalizations.of(context)!.loginToViewProfile,
        ),
      );
    } else {
      emit(AuthLoading());
      try {
        final customerInfo = await _customerApiService.getProfile();
        emit(AuthFetchedData(customer: customerInfo));
      } catch (e) {
        emit(AuthFailed(message: e.toString()));
      }
    }
  }

  Future<void> logout({required BuildContext context}) async {
    emit(AuthLoading());
    try {
      await _customerApiService.logout();
      emit(AuthSuccessed(message: 'تم تسجيل الخروج بنجاح'));

      context.go(AppRoutes.login);
    } catch (e) {
      emit(AuthFailed(message: e.toString()));
    }
  }

  Future<void> updateProfile({
    required String firstName,
    required String lastName,
    required BuildContext context,
    String? middleName,
    String? fatherName,
    String? gender,
    String? dateOfBirth,
    String? email,
    String? countryCode,
    String? phone,
    String? whatsappNumber,
    String? officialGovernorate,
    String? officialCity,
    String? officialTown,
    String? officialMunicipalityVillage,
    String? officialStreet,
    String? officialBuilding,
    String? permanentAddress,
    Map<String, dynamic>? addresses,
    File? imageFile,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    emit(AuthLoading());
    try {
      await _customerApiService.updateProfile(
        phone: phone,
        countryCode: countryCode,
        whatsappNumber: whatsappNumber,
        email: email,
        firstName: firstName,
        middleName: middleName,
        lastName: lastName,
        fatherName: fatherName,
        gender: gender,
        dateOfBirth: dateOfBirth,
        officialGovernorate: officialGovernorate,
        officialCity: officialCity,
        officialTown: officialTown,
        officialMunicipalityVillage: officialMunicipalityVillage,
        officialStreet: officialStreet,
        officialBuilding: officialBuilding,
        permanentAddress: permanentAddress,
        addresses: addresses,
        imageFile: imageFile,
      );
      emit(AuthSuccessed(message: l10n.profileSaved));
      CustomSnackBar.show(context, l10n.profileSaved);
      context.pop();
      await loadProfile(context);
    } catch (e) {
      emit(AuthFailed(message: e.toString()));
       CustomSnackBar.show(context, e.toString());
      throw Exception(e);
    }
  }
}
