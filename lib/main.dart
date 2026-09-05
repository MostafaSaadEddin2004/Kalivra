import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/controller/blocs/bloc/locale_bloc/locale_bloc_bloc.dart';
import 'package:kalivra/controller/blocs/bloc/theme_bloc/theme_bloc_bloc.dart';
import 'package:kalivra/controller/blocs/cubit/address_info_cubit/address_info_cubit.dart';
import 'package:kalivra/controller/blocs/cubit/app_info_cubit/app_info_cubit.dart';
import 'package:kalivra/controller/blocs/cubit/assoiciation_link_cubit/association_link_cubit.dart';
import 'package:kalivra/controller/blocs/cubit/cart_cubit/cart_cubit.dart';
import 'package:kalivra/controller/blocs/cubit/auth_cubit/auth_cubit.dart';
import 'package:kalivra/controller/blocs/cubit/brand_cubit/brand_cubit.dart';
import 'package:kalivra/controller/blocs/cubit/checkout_cubit/checkout_cubit.dart';
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
        BlocProvider(create: (context) => CheckoutCubit()),
        BlocProvider(create: (context) => ProductsCubit()),
        BlocProvider(create: (context) => BrandCubit()),
        BlocProvider(create: (context) => NotificationsCubit()),
        BlocProvider(create: (context) => WishlistCubit()),
        BlocProvider(create: (context) => OrdersCubit()),
        BlocProvider(create: (context) => AppInfoCubit()),
        BlocProvider(create: (context) => AssociationLinkCubit()),
        BlocProvider(create: (context) => AddressInfoCubit()),
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
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

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

    final cubit = context.read<NotificationsCubit>();
    final notification = cubit.receiveRemoteNotification(data);
    cubit.syncFromServer();
    _showNotificationToast(notification);
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

  void _openNotification(AppNotification notification) {
    context.read<NotificationsCubit>().markAsRead(notification.id);
    _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
    AppRouter.router.push(_routeForNotification(notification));
  }

  void _showNotificationToast(AppNotification notification) {
    final messengerState = _scaffoldMessengerKey.currentState;
    if (messengerState == null) return;

    final messengerContext = messengerState.context;
    final theme = Theme.of(messengerContext);
    final title = notification.title.trim();
    final message = notification.message.trim();

    messengerState
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: theme.colorScheme.onTertiaryFixed,
          duration: const Duration(seconds: 6),
          margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 18.h),
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          content: InkWell(
            borderRadius: BorderRadius.circular(12.r),
            onTap: () => _openNotification(notification),
            child: Padding(
              padding: EdgeInsets.all(14.w),
              child: Row(
                children: [
                  Container(
                    width: 42.r,
                    height: 42.r,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onPrimaryFixed.withValues(
                        alpha: 0.14,
                      ),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(
                      notification.icon,
                      color: theme.colorScheme.onPrimaryFixed,
                      size: 22.r,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title.isEmpty ? 'Kalivra' : title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onPrimaryFixed,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        if (message.isNotEmpty) ...[
                          SizedBox(height: 3.h),
                          Text(
                            message,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onPrimaryFixed
                                  .withValues(alpha: 0.82),
                              height: 1.3,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: theme.colorScheme.onPrimaryFixed,
                    size: 22.r,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
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
        return AppRoutes.associationAnnouncements;
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
            scaffoldMessengerKey: _scaffoldMessengerKey,
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
