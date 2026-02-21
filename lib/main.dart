import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/controllers/blocs/bloc/locale_bloc/locale_bloc_bloc.dart';
import 'package:kalivra/controllers/blocs/bloc/theme_bloc/theme_bloc_bloc.dart';
import 'package:kalivra/controllers/blocs/cubit/cart_cubit/cart_cubit.dart';
import 'package:kalivra/controllers/prefs/pref_keys.dart';
import 'package:kalivra/core/app_dependencies.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/core/screen_util_config.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final deps = await AppDependencies.create();
  deps.productsCubit.loadAll();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ThemeBloc()..add(GetThemeMode())),
        BlocProvider(create: (context) => LocaleBloc()..add(GetLocale())),
        BlocProvider.value(value: deps.cartCubit),
        BlocProvider.value(value: deps.authCubit),
        BlocProvider.value(value: deps.productsCubit),
        BlocProvider.value(value: deps.ordersCubit),
        BlocProvider.value(value: deps.wishlistCubit),
        BlocProvider.value(value: deps.checkoutCubit),
        BlocProvider.value(value: deps.notificationsCubit),
      ],
      child: const Main(),
    ),
  );
}

class Main extends StatelessWidget {
  const Main({super.key, });
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: kDesignSize,
      minTextAdapt: true,
      fontSizeResolver: (fontSize, instance) {
        final scaled = FontSizeResolvers.width(fontSize, instance);
        return scaled.clamp(
          fontSize * kMinTextScaleFactor,
          fontSize * kMaxTextScaleFactor,
        );
      },
      builder: (context, child) => child!,
      child: BlocListener<CartCubit, CartState>(
        listenWhen: (prev, curr) =>
            (curr.loginRequiredForAdd && !prev.loginRequiredForAdd) ||
            (curr.addSuccessMessage != null && curr.addSuccessMessage != prev.addSuccessMessage),
        listener: (context, state) {
          if (state.loginRequiredForAdd) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('يجب تسجيل الدخول لإضافة المنتجات إلى السلة'),
                behavior: SnackBarBehavior.floating,
              ),
            );
            AppRouter.router.push(AppRoutes.login);
            context.read<CartCubit>().clearLoginRequired();
          }
          if (state.addSuccessMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.addSuccessMessage!),
                behavior: SnackBarBehavior.floating,
              ),
            );
            context.read<CartCubit>().clearAddSuccessMessage();
          }
        },
        child: Builder(
          builder: (context) {
            final theme = context.watch<ThemeBloc>().state;
            final locale = context.watch<LocaleBloc>().state;
            return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: theme is ThemeFetched ? theme.mode : ThemeMode.system,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale(PrefKeys.enLocaleKey),
              Locale(PrefKeys.arLocaleKey),
            ],
            locale: locale is LocaleFetched
                ? locale.locale
                : Locale(PrefKeys.arLocaleKey),
            routerConfig: AppRouter.router,
            );
          },
        ),
      ),
    );
  }
}
