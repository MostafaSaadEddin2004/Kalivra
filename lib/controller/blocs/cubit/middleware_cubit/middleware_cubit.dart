import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/controller/blocs/cubit/auth_cubit/auth_cubit.dart';
import 'package:kalivra/controller/prefs/local_store.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/view/screens/auth/intro_screen.dart';
import 'package:kalivra/view/splash_screen.dart';
import 'package:kalivra/view/widgets/confirm_dialog.dart';
import 'package:kalivra/view/widgets/profile_page/profile_page_item.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/view/widgets/login_dialog.dart';

part 'middleware_state.dart';

class MiddlewareCubit extends Cubit<MiddlewareState> {
  MiddlewareCubit() : super(MiddlewareFetched(screen: SplashScreen()));

  Future<void> fetchScreen(BuildContext context) async {
    final intro = await LocalStore.getIntroPass();
    if (intro != null) {
      emit(MiddlewareFetched(screen: IntroScreen()));
      context.goNamed(AppRoutes.home);
    } else {
      emit(MiddlewareFetched(screen: IntroScreen()));
      context.goNamed(AppRoutes.intro);
    }
  }

  Future<void> checkIfLoggedIn({
    required BuildContext context,
    required String? screenName,
  }) async {
    final token = await LocalStore.getToken();
    if (token != null && token.isNotEmpty) {
      if (screenName != null) {
        context.pushNamed(screenName);
      }
    } else {
      showDialog(context: context, builder: (context) => GoToLoginDialog());
    }
  }

  Future<void> getLoinOrLogoutButton(BuildContext context) async {
    final token = await LocalStore.getToken();
    if (token != null && token.isNotEmpty) {
      emit(
        LogOutButton(
          button: ProfilePageItem(
            icon: Icons.logout_rounded,
            label: AppLocalizations.of(context)!.signOut,
            onTap: () => showDialog(
              context: context,
              builder: (context) {
                return BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    switch (state) {
                      case AuthLoading():
                        return ConfirmDialog(
                          isLoading: true ,
                      title: AppLocalizations.of(context)!.signOut,
                      message: AppLocalizations.of(
                        context,
                      )!.signOutConfirmation,
                      onConfirm: () {
                        context.read<AuthCubit>().logout(context: context);
                      },
                    );
                      default:return ConfirmDialog(
                        isLoading: false,
                      title: AppLocalizations.of(context)!.signOut,
                      message: AppLocalizations.of(
                        context,
                      )!.signOutConfirmation,
                      onConfirm: () {
                        context.read<AuthCubit>().logout(context: context);
                      },
                    );
                    }
                    
                  },
                );
              },
            ),
          ),
        ),
      );
    } else {
      emit(
        LoginButton(
          button: ProfilePageItem(
            icon: Icons.login_rounded,
            label: AppLocalizations.of(context)!.signIn,
            onTap: () => context.go(AppRoutes.login),
          ),
        ),
      );
    }
  }
}
