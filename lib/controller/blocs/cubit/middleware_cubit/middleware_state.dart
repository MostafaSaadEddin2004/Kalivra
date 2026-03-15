part of 'middleware_cubit.dart';

@immutable
sealed class MiddlewareState {}

final class MiddlewareFetched extends MiddlewareState {
  final Widget screen;

  MiddlewareFetched({required this.screen});
}

final class LogOutButton extends MiddlewareState {
  final Widget button;

  LogOutButton({required this.button});
}

final class LoginButton extends MiddlewareState {
  final Widget button;

  LoginButton({required this.button});
}
