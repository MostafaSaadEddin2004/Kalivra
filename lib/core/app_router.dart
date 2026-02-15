import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/views/splash_screen.dart';
import 'package:kalivra/views/screens/home/home_screen.dart';
import 'package:kalivra/views/screens/drawer_screens/about_screen.dart';
import 'package:kalivra/views/screens/drawer_screens/profile_screens/profile_screen.dart';
import 'package:kalivra/views/screens/drawer_screens/contact_screen.dart';
import 'package:kalivra/views/screens/drawer_screens/profile_screens/edit_profile_screen.dart';
import 'package:kalivra/views/screens/drawer_screens/favorites_screen.dart';
import 'package:kalivra/models/order_model.dart';
import 'package:kalivra/views/screens/drawer_screens/orders_screens/order_details_screen.dart';
import 'package:kalivra/views/screens/drawer_screens/orders_screens/orders_screen.dart';
import 'package:kalivra/views/screens/drawer_screens/privacy_screen.dart';
import 'package:kalivra/views/screens/drawer_screens/rate_screen.dart';
import 'package:kalivra/views/screens/drawer_screens/change_password_screen.dart';
import 'package:kalivra/views/screens/drawer_screens/confirm_new_phone_screen.dart';
import 'package:kalivra/views/screens/drawer_screens/language_screen.dart';
import 'package:kalivra/views/screens/drawer_screens/otp_code_entry_screen.dart';
import 'package:kalivra/views/screens/drawer_screens/otp_phone_entry_screen.dart';
import 'package:kalivra/views/screens/drawer_screens/settings_screen.dart';
import 'package:kalivra/views/screens/drawer_screens/set_new_password_screen.dart';
import 'package:kalivra/views/screens/drawer_screens/theme_mode_screen.dart';
import 'package:kalivra/views/screens/home/product_details_screen.dart';
import 'package:kalivra/views/screens/home/brand_details_screen.dart';
import 'package:kalivra/views/screens/home/all_brands_screen.dart';
import 'package:kalivra/views/screens/home/all_products_screen.dart';
import 'package:kalivra/views/screens/home/all_sale_products_screen.dart';
import 'package:kalivra/views/screens/home/all_ads_screen.dart';
import 'package:kalivra/views/screens/home/ad_details_screen.dart';
import 'package:kalivra/views/screens/home/cart_screen.dart';
import 'package:kalivra/views/screens/auth/intro_screen.dart';
import 'package:kalivra/views/screens/auth/login_screen.dart';
import 'package:kalivra/views/screens/auth/sign_up_screen.dart';
import 'package:kalivra/views/screens/auth/complete_profile_screen.dart';
import 'package:kalivra/models/product_model.dart';
import 'package:kalivra/models/brand_model.dart';
import 'package:kalivra/models/advertisement_model.dart';

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
  static const String rate = '/rate';
  static const String editProfile = '/edit-profile';
  static const String orderDetails = '/order-details';
  static const String language = '/language';
  static const String changePassword = '/change-password';
  static const String otp = '/otp';
  static const String otpVerify = '/otp-verify';
  static const String setNewPassword = '/set-new-password';
  static const String confirmNewPhone = '/confirm-new-phone';
  static const String themeMode = '/theme-mode';
  static const String productDetails = '/product-details';
  static const String brandDetails = '/brand-details';
  static const String allBrands = '/all-brands';
  static const String allProducts = '/all-products';
  static const String allSaleProducts = '/all-sale-products';
  static const String allAds = '/all-ads';
  static const String adDetails = '/ad-details';
  static const String intro = '/intro';
  static const String login = '/login';
  static const String signUp = '/sign-up';
  static const String completeProfile = '/complete-profile';
  static const String cart = '/cart';
}

abstract class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    routes: <RouteBase>[
        GoRoute(
          path: AppRoutes.splash,
          name: 'splash',
          builder: (_, _) => const SplashScreen(),
          routes: <RouteBase>[
            GoRoute(
              path: 'intro',
              name: 'intro',
              builder: (_, _) => const IntroScreen(),
            ),
            GoRoute(
              path: 'login',
              name: 'login',
              builder: (_, _) => const LoginScreen(),
            ),
            GoRoute(
              path: 'sign-up',
              name: 'signUp',
              builder: (_, _) => const SignUpScreen(),
            ),
            GoRoute(
              path: 'complete-profile',
              name: 'completeProfile',
              builder: (context, state) {
                final args = state.extra as OtpOnboardingArgs?;
                return CompleteProfileScreen(args: args);
              },
            ),
            GoRoute(
              path: AppRoutes.home,
              name: 'home',
              builder: (_, _) => const HomeScreen(),
            ),
            GoRoute(
              path: AppRoutes.account,
              name: 'account',
              builder: (_, _) => const Profile(),
            ),
            GoRoute(
              path: AppRoutes.editProfile,
              name: 'editProfile',
              builder: (_, _) => const EditProfileScreen(),
            ),
            GoRoute(
              path: AppRoutes.orders,
              name: 'orders',
              builder: (_, _) => const OrdersScreen(),
            ),
            GoRoute(
              path: AppRoutes.orderDetails,
              name: 'orderDetails',
              builder: (context, state) {
                final order = state.extra as OrderModel?;
                if (order == null) {
                  return const Scaffold(
                    body: Center(child: Text('لا يوجد طلب')),
                  );
                }
                return OrderDetailsScreen(order: order);
              },
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
              path: AppRoutes.language,
              name: 'language',
              builder: (_, _) => const LanguageScreen(),
            ),
            GoRoute(
              path: AppRoutes.changePassword,
              name: 'changePassword',
              builder: (_, _) => const ChangePasswordScreen(),
            ),
            GoRoute(
              path: AppRoutes.otp,
              name: 'otp',
              builder: (context, state) {
                final extra = state.extra;
                if (extra is OtpOnboardingArgs && extra.mode == OtpScreenMode.signUp) {
                  return OtpPhoneEntryScreen(signUpArgs: extra);
                }
                return OtpPhoneEntryScreen(mode: extra as OtpScreenMode? ?? OtpScreenMode.changePhone);
              },
            ),
            GoRoute(
              path: AppRoutes.otpVerify,
              name: 'otpVerify',
              builder: (context, state) {
                final args = state.extra as OtpOnboardingArgs?;
                if (args == null) {
                  return const Scaffold(
                    body: Center(child: Text('خطأ: لم يتم تمرير البيانات')),
                  );
                }
                return OtpCodeEntryScreen(args: args);
              },
            ),
            GoRoute(
              path: AppRoutes.setNewPassword,
              name: 'setNewPassword',
              builder: (_, _) => const SetNewPasswordScreen(),
            ),
            GoRoute(
              path: AppRoutes.confirmNewPhone,
              name: 'confirmNewPhone',
              builder: (context, state) {
                final phone = state.extra as String? ?? '';
                return ConfirmNewPhoneScreen(phone: phone);
              },
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
              path: AppRoutes.rate,
              name: 'rate',
              builder: (_, _) => const RateScreen(),
            ),
            GoRoute(
              path: AppRoutes.themeMode,
              name: 'themeMode',
              builder: (_, _) => const ThemeModeScreen(),
            ),
            GoRoute(
              path: AppRoutes.productDetails,
              name: 'productDetails',
              builder: (context, state) {
                final product = state.extra as ProductModel?;
                if (product == null) {
                  return const Scaffold(
                    body: Center(child: Text('المنتج غير متوفر')),
                  );
                }
                return ProductDetailsScreen(product: product);
              },
            ),
            GoRoute(
              path: AppRoutes.brandDetails,
              name: 'brandDetails',
              builder: (context, state) {
                final brand = state.extra as BrandModel?;
                if (brand == null) {
                  return const Scaffold(
                    body: Center(child: Text('العلامة غير متوفرة')),
                  );
                }
                return BrandDetailsScreen(brand: brand);
              },
            ),
            GoRoute(
              path: AppRoutes.allBrands,
              name: 'allBrands',
              builder: (_, _) => const AllBrandsScreen(),
            ),
            GoRoute(
              path: AppRoutes.allProducts,
              name: 'allProducts',
              builder: (_, _) => const AllProductsScreen(),
            ),
            GoRoute(
              path: AppRoutes.allSaleProducts,
              name: 'allSaleProducts',
              builder: (_, _) => const AllSaleProductsScreen(),
            ),
            GoRoute(
              path: AppRoutes.allAds,
              name: 'allAds',
              builder: (_, _) => const AllAdsScreen(),
            ),
            GoRoute(
              path: AppRoutes.adDetails,
              name: 'adDetails',
              builder: (context, state) {
                final ad = state.extra as AdvertisementModel?;
                if (ad == null) {
                  return const Scaffold(
                    body: Center(child: Text('الإعلان غير متوفر')),
                  );
                }
                return AdDetailsScreen(ad: ad);
              },
            ),
            GoRoute(
              path: AppRoutes.cart,
              name: 'cart',
              builder: (_, _) => const CartScreen(),
            ),
          ],
        ),
      ],
  );
}
