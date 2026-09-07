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
  OverlayEntry? _notificationToastEntry;

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
    _hideNotificationToast();
    AppRouter.router.push(_routeForNotification(notification));
  }

  void _hideNotificationToast() {
    _notificationToastEntry?.remove();
    _notificationToastEntry = null;
  }

  void _showNotificationToast(AppNotification notification) {
    final overlay = AppRouter.rootNavigatorKey.currentState?.overlay;
    if (overlay == null) return;

    final title = notification.title.trim();
    final message = notification.message.trim();

    _hideNotificationToast();
    _notificationToastEntry = OverlayEntry(
      builder: (context) => _InAppNotificationToast(
        title: title.isEmpty ? 'Kalivra' : title,
        message: message,
        icon: notification.icon,
        onTap: () => _openNotification(notification),
        onDismiss: _hideNotificationToast,
      ),
    );

    overlay.insert(_notificationToastEntry!);
    final toastEntry = _notificationToastEntry;
    Future<void>.delayed(const Duration(seconds: 6), () {
      if (!mounted || _notificationToastEntry != toastEntry) return;
      _hideNotificationToast();
    });
  }

  String _routeForNotification(AppNotification notification) {
    switch (notification.type) {
      case AppNotificationType.orderPlaced:
      case AppNotificationType.orderCanceled:
      case AppNotificationType.shipment:
        return AppRoutes.orders;
      case AppNotificationType.associationRequest:
      case AppNotificationType.membership:
      case AppNotificationType.paymentConfirmation:
        return AppRoutes.associationMemberProfile;
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
  void dispose() {
    _hideNotificationToast();
    super.dispose();
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

class _InAppNotificationToast extends StatelessWidget {
  const _InAppNotificationToast({
    required this.title,
    required this.message,
    required this.icon,
    required this.onTap,
    required this.onDismiss,
  });

  final String title;
  final String message;
  final IconData icon;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PositionedDirectional(
      top: 0,
      start: 0,
      end: 0,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 0),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12.r),
              onTap: onTap,
              child: Container(
                padding: EdgeInsets.all(14.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.onTertiaryFixed,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withValues(alpha: 0.18),
                      blurRadius: 18.r,
                      offset: Offset(0, 8.h),
                    ),
                  ],
                ),
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
                        icon,
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
                            title,
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
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints.tight(Size.square(32.r)),
                      onPressed: onDismiss,
                      icon: Icon(
                        Icons.close_rounded,
                        color: theme.colorScheme.onPrimaryFixed,
                        size: 20.r,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
