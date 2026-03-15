import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/controller/blocs/cubit/auth_cubit/auth_cubit.dart';
import 'package:kalivra/controller/prefs/local_store.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/view/screens/auth/intro_screen.dart';
import 'package:kalivra/view/splash_screen.dart';
import 'package:kalivra/view/widgets/confirm_dialog.dart';
import 'package:kalivra/view/widgets/drawer/drawer_item.dart';

part 'middleware_state.dart';

class MiddlewareCubit extends Cubit<MiddlewareState> {
  MiddlewareCubit() : super(MiddlewareFetched(screen:SplashScreen()));

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
      showDialog(context: context, builder: (context) => ConfirmDialog(message: 'هلأنت متأكد من الهاب لصفحة تسجيل الدخول؟',title: 'تسجيل الدخول',));
    }
  }

  Future<void> getLoinOrLogoutButton(BuildContext context) async {
    final token = await LocalStore.getToken();
    if (token != null && token.isNotEmpty) {
      emit(
        LogOutButton(
          button:DrawerItem(icon: Icons.logout_rounded,label: 'تسجيل الخروج',onTap: () =>   context.read<AuthCubit>().logout(),) 
        ),
      );
    } else {
      emit(
        LoginButton(
          button:DrawerItem(icon: Icons.login_rounded,label: 'تسجيل الدخول',onTap: () => context.pushNamed(AppRoutes.login),) ,
        
        ),
      );
    }
  }
}