import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/controllers/blocs/cubit/auth_cubit/auth_cubit.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/l10n/app_localizations.dart';

/// Middleware helpers: require login for cart, notifications, etc.
/// Browsing (products, categories, brands, search) is allowed without login.
class AuthGuard {
  AuthGuard._();

  /// True if the current user has a valid token.
  static bool isLoggedIn(BuildContext context) {
    final token = context.read<AuthCubit>().state.token;
    return token != null && token.isNotEmpty;
  }

  /// If not logged in: shows SnackBar and pushes login, returns false.
  /// If logged in: returns true. Use before adding to cart.
  static bool requireLoginForCart(BuildContext context) {
    if (isLoggedIn(context)) return true;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.loginRequiredForCart),
        behavior: SnackBarBehavior.floating,
      ),
    );
    context.push(AppRoutes.login);
    return false;
  }
}
