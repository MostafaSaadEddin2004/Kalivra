import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kalivra/controller/blocs/cubit/auth_cubit/auth_state.dart';
import 'package:kalivra/core/auth/token_service.dart';
import 'package:kalivra/core/app_locator.dart';
import 'package:kalivra/model/services/api/customer_api_service.dart';

export 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthState.initial);

  CustomerApiService get _customerApiService => AppLocator.customerApiService;

  /// Call after [TokenService.init] to restore auth state from stored token.
  Future<void> loadProfileIfToken() async {
    final token = await TokenService.getToken();
    if (token != null && token.isNotEmpty) {
      emit(AuthState.authenticated(token: token));
      loadProfile();
    } else {
      emit(AuthState.unauthenticated);
    }
  }

  Future<void> login(String email, String password) async {
    emit(AuthState.loading);
    try {
      final res = await _customerApiService.login(email, password);
      final token = res?['token'] as String? ?? res?['access_token'] as String?;
      if (token != null && token.isNotEmpty) {
        await TokenService.setToken(token);
        emit(AuthState.authenticated(token: token));
        loadProfile();
      } else {
        emit(AuthState.unauthenticated);
      }
    } catch (e, st) {
      emit(AuthState.failed(e, st));
    }
  }

  Future<void> loadProfile() async {
    final token = state.token;
    if (token == null) return;
    try {
      final profile = await _customerApiService.getProfile();
      if (profile != null) {
        emit(AuthState.authenticated(token: token, customer: profile));
      }
    } catch (_) {
      // keep current state
    }
  }

  Future<void> logout() async {
    await TokenService.clearToken();
    emit(AuthState.unauthenticated);
  }
}
