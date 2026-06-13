import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/controller/blocs/cubit/auth_cubit/auth_cubit.dart';
import 'package:kalivra/controller/prefs/local_store.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/view/screens/auth/intro_screen.dart';
import 'package:kalivra/view/splash_screen.dart';
import 'package:kalivra/view/widgets/confirm_dialog.dart';
import 'package:kalivra/view/widgets/drawer/drawer_item.dart';
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
    bool isLoading = false;
    final token = await LocalStore.getToken();
    if (token != null && token.isNotEmpty) {
      emit(
        LogOutButton(
          button: BlocListener<AuthCubit, AuthState>(
            listener: (context, state) {
              switch (state) {
                case AuthLoading():
                  isLoading = true;
                default:
                  isLoading = false;
              }
            },
            child: DrawerItem(
              loading: isLoading == true
                  ? SpinKitFadingCircle(color: AppColors.offWhite, size: 20.r)
                  : null,
              icon: Icons.logout_rounded,
              label: AppLocalizations.of(context)!.signOut,
              onTap: () => showDialog(
                context: context,
                builder: (context) {
                  return ConfirmDialog(
                    title: AppLocalizations.of(context)!.signOut,
                    message: AppLocalizations.of(context)!.signOutConfirmation,
                    onConfirm: () {
                      context.read<AuthCubit>().logout();
                      context.go(AppRoutes.login);
                    },
                  );
                },
              ),
            ),
          ),
        ),
      );
    } else {
      emit(
        LoginButton(
          button: DrawerItem(
            icon: Icons.login_rounded,
            label: AppLocalizations.of(context)!.signIn,
            onTap: () => context.go(AppRoutes.login),
          ),
        ),
      );
    }
  }
}
