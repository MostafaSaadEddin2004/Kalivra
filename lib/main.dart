import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/controller/blocs/bloc/locale_bloc/locale_bloc_bloc.dart';
import 'package:kalivra/controller/blocs/bloc/theme_bloc/theme_bloc_bloc.dart';
import 'package:kalivra/controller/blocs/cubit/auth_cubit/auth_cubit.dart';
import 'package:kalivra/controller/blocs/cubit/middleware_cubit/middleware_cubit.dart';
import 'package:kalivra/controller/prefs/pref_keys.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/core/screen_util_config.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create:  (context) => MiddlewareCubit(),),
        BlocProvider(create: (context) => ThemeBloc()..add(GetThemeMode())),
        BlocProvider(create: (context) => LocaleBloc()..add(GetLocale())),
        BlocProvider(create: (context) => AuthCubit()),
      ],
      child: const Main(),
    ),
  );
}

class Main extends StatelessWidget {
  const Main({super.key});
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
                  : LocaleBloc.localeFromSystem(
                      ui.PlatformDispatcher.instance.locale,
                    ),
              routerConfig: AppRouter.router,
            );
          },
        )
    );
  }
}
