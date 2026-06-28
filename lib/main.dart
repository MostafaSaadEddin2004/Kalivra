import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/controller/blocs/bloc/locale_bloc/locale_bloc_bloc.dart';
import 'package:kalivra/controller/blocs/bloc/theme_bloc/theme_bloc_bloc.dart';
import 'package:kalivra/controller/blocs/cubit/app_info_cubit/app_info_cubit.dart';
import 'package:kalivra/controller/blocs/cubit/assoiciation_link_cubit/association_link_cubit.dart';
import 'package:kalivra/controller/blocs/cubit/cart_cubit/cart_cubit.dart';
import 'package:kalivra/controller/blocs/cubit/auth_cubit/auth_cubit.dart';
import 'package:kalivra/controller/blocs/cubit/brand_cubit/brand_cubit.dart';
import 'package:kalivra/controller/blocs/cubit/middleware_cubit/middleware_cubit.dart';
import 'package:kalivra/controller/blocs/cubit/notifications_cubit/notifications_cubit.dart';
import 'package:kalivra/controller/blocs/cubit/orders_cubit/orders_cubit.dart';
import 'package:kalivra/controller/blocs/cubit/products_cubit/products_cubit.dart';
import 'package:kalivra/controller/blocs/cubit/wishlist_cubit/wishlist_cubit.dart';
import 'package:kalivra/controller/prefs/pref_keys.dart';
import 'package:kalivra/core/app_router.dart';
import 'package:kalivra/core/firebase_helper.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/core/screen_util_config.dart';
import 'package:kalivra/model/notifications/app_notification.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await FirebaseHelper.initialize();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => MiddlewareCubit()),
        BlocProvider(create: (context) => ThemeBloc()..add(GetThemeMode())),
        BlocProvider(create: (context) => LocaleBloc()..add(GetLocale())),
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => CartCubit()),
        BlocProvider(create: (context) => ProductsCubit()),
        BlocProvider(create: (context) => BrandCubit()),
        BlocProvider(create: (context) => NotificationsCubit()),
        BlocProvider(create: (context) => WishlistCubit()),
        BlocProvider(create: (context) => OrdersCubit()),
        BlocProvider(create: (context) => AppInfoCubit()),
        BlocProvider(create: (context) => AssociationLinkCubit()),
      ],
      child: const Main(),
    ),
  );
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      FirebaseHelper.initialize(
        onNotificationReceived: _handleNotificationReceived,
        onNotificationTap: _handleNotificationTap,
      );
    });
  }

  void _handleNotificationReceived(Map<String, dynamic> data) {
    if (!mounted) {
      return;
    }

    context.read<NotificationsCubit>().receiveRemoteNotification(data);
  }

  void _handleNotificationTap(Map<String, dynamic> data) {
    if (!mounted) {
      return;
    }

    final notification = context
        .read<NotificationsCubit>()
        .receiveRemoteNotification(data);
    context.read<NotificationsCubit>().markAsRead(notification.id);
    AppRouter.router.push(_routeForNotification(notification));
  }

  String _routeForNotification(AppNotification notification) {
    switch (notification.type) {
      case AppNotificationType.memberOperation:
        return AppRoutes.associationMemberProfile;
      case AppNotificationType.financialOperation:
        return AppRoutes.orders;
      case AppNotificationType.decisionSession:
      case AppNotificationType.officialAnnouncement:
      case AppNotificationType.legalDeadline:
        return AppRoutes.associationRequestsAndServices;
      case AppNotificationType.manualSystemNotice:
        return AppRoutes.settings;
      case AppNotificationType.deliveryFailure:
        return AppRoutes.contact;
    }
  }

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
      ),
    );
  }
}
