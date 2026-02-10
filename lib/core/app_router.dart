import 'package:go_router/go_router.dart';
import 'package:kalivra/views/splash_screen.dart';
import 'package:kalivra/views/screens/home/home_screen.dart';
import 'package:kalivra/views/screens/drawer_screens/about_screen.dart';
import 'package:kalivra/views/screens/drawer_screens/account_screen.dart';
import 'package:kalivra/views/screens/drawer_screens/contact_screen.dart';
import 'package:kalivra/views/screens/drawer_screens/favorites_screen.dart';
import 'package:kalivra/views/screens/drawer_screens/login_screen.dart';
import 'package:kalivra/views/screens/drawer_screens/orders_screen.dart';
import 'package:kalivra/views/screens/drawer_screens/privacy_screen.dart';
import 'package:kalivra/views/screens/drawer_screens/rate_screen.dart';
import 'package:kalivra/views/screens/drawer_screens/settings_screen.dart';
import 'package:kalivra/views/screens/drawer_screens/share_screen.dart';

/// Route path constants. Use these for navigation.
abstract class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String account = '/account';
  static const String orders = '/orders';
  static const String favorites = '/favorites';
  static const String settings = '/settings';
  static const String contact = '/contact';
  static const String about = '/about';
  static const String privacy = '/privacy';
  static const String share = '/share';
  static const String rate = '/rate';
  static const String login = '/login';
}

abstract class AppRouter {
  static GoRouter appRouter() {
    return GoRouter(
      routes: <RouteBase>[
        GoRoute(
          path: AppRoutes.splash,
          name: 'splash',
          builder: (_, _) => const SplashScreen(),
          routes: <RouteBase>[
            GoRoute(
              path: AppRoutes.home,
              name: 'home',
              builder: (_, _) => const HomeScreen(),
            ),
            GoRoute(
              path: AppRoutes.account,
              name: 'account',
              builder: (_, _) => const AccountScreen(),
            ),
            GoRoute(
              path: AppRoutes.orders,
              name: 'orders',
              builder: (_, _) => const OrdersScreen(),
            ),
            GoRoute(
              path: AppRoutes.favorites,
              name: 'favorites',
              builder: (_, _) => const FavoritesScreen(),
            ),
            GoRoute(
              path: AppRoutes.settings,
              name: 'settings',
              builder: (_, _) => const SettingsScreen(),
            ),
            GoRoute(
              path: AppRoutes.contact,
              name: 'contact',
              builder: (_, _) => const ContactScreen(),
            ),
            GoRoute(
              path: AppRoutes.about,
              name: 'about',
              builder: (_, _) => const AboutScreen(),
            ),
            GoRoute(
              path: AppRoutes.privacy,
              name: 'privacy',
              builder: (_, _) => const PrivacyScreen(),
            ),
            GoRoute(
              path: AppRoutes.share,
              name: 'share',
              builder: (_, _) => const ShareScreen(),
            ),
            GoRoute(
              path: AppRoutes.rate,
              name: 'rate',
              builder: (_, _) => const RateScreen(),
            ),
            GoRoute(
              path: AppRoutes.login,
              name: 'login',
              builder: (_, _) => const LoginScreen(),
            ),
          ],
        ),
      ],
    );
  }
}
