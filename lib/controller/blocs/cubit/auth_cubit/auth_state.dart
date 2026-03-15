import 'package:kalivra/model/customer/customer_api_model.dart';

abstract class AuthState {}

final class AuthLoading extends AuthState {}

final class AuthSuccessed extends AuthState {
  final String message;

  AuthSuccessed({required this.message});
}

final class AuthFetchedData extends AuthState {
  final CustomerApiModel customer;

  AuthFetchedData({required this.customer});
}
final class AuthFailed extends AuthState {
  final String message;

  AuthFailed({required this.message});
}

final class UnAuthinticated extends AuthState {
  final String message;

  UnAuthinticated({required this.message});
}