import 'package:kalivra/models/api/customer_api_model.dart';

abstract class AuthState {
  const AuthState();
  String? get token => null;
  CustomerApiModel? get customer => null;
  bool get isLoading => false;
  bool get hasError => false;
  Object? get error => null;

  static const AuthState initial = _AuthInitial();
  static const AuthState loading = _AuthLoading();
  static const AuthState unauthenticated = _AuthUnauthenticated();
  static AuthState authenticated({required String token, CustomerApiModel? customer}) =>
      _AuthAuthenticated(token: token, customer: customer);
  static AuthState failed(Object error, [StackTrace? st]) => _AuthFailed(error, st);
}

final class _AuthInitial extends AuthState {
  const _AuthInitial();
}

final class _AuthLoading extends AuthState {
  const _AuthLoading();
  @override
  bool get isLoading => true;
}

final class _AuthAuthenticated extends AuthState {
  _AuthAuthenticated({required this.token, this.customer});
  @override
  final String token;
  @override
  final CustomerApiModel? customer;
}

final class _AuthUnauthenticated extends AuthState {
  const _AuthUnauthenticated();
}

final class _AuthFailed extends AuthState {
  _AuthFailed(this._error, [this.stackTrace]);
  final Object _error;
  final StackTrace? stackTrace;
  @override
  bool get hasError => true;
  @override
  Object? get error => _error;
}
