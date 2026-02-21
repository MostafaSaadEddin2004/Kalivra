import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kalivra/controllers/blocs/cubit/auth_cubit/auth_state.dart';
import 'package:kalivra/controllers/prefs/pref_keys.dart';
import 'package:kalivra/services/api/customer_api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

export 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required this.customerApiService,
    SharedPreferences? prefs,
  })  : _prefs = prefs,
        super(AuthState.initial) {
    _loadToken();
  }

  final CustomerApiService customerApiService;
  SharedPreferences? _prefs;

  Future<void> _loadToken() async {
    final prefs = _prefs ?? await SharedPreferences.getInstance();
    _prefs = prefs;
    final token = prefs.getString(PrefKeys.accessTokenKey);
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
      final res = await customerApiService.login(email, password);
      final token = res?['token'] as String? ?? res?['access_token'] as String?;
      if (token != null && token.isNotEmpty) {
        final p = _prefs ?? await SharedPreferences.getInstance();
        _prefs = p;
        await p.setString(PrefKeys.accessTokenKey, token);
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
      final profile = await customerApiService.getProfile();
      if (profile != null) {
        emit(AuthState.authenticated(token: token, customer: profile));
      }
    } catch (_) {
      // keep current state
    }
  }

  Future<void> logout() async {
    await _prefs?.remove(PrefKeys.accessTokenKey);
    emit(AuthState.unauthenticated);
  }
}
