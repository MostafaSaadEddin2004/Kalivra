import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/view/screens/drawer_screens/association_screens/association_drafts_screen.dart';
import 'package:kalivra/view/screens/drawer_screens/association_screens/association_submitted_requests_screen.dart';
import 'package:kalivra/view/splash_screen.dart';
import 'package:kalivra/view/screens/home/home_screen.dart';
import 'package:kalivra/view/screens/drawer_screens/about_screen.dart';
import 'package:kalivra/view/screens/drawer_screens/profile_screens/profile_screen.dart';
import 'package:kalivra/view/screens/drawer_screens/contact_screen.dart';
import 'package:kalivra/view/screens/drawer_screens/association_screens/association_link_request_screen.dart';
import 'package:kalivra/view/screens/drawer_screens/association_screens/association_member_profile_screen.dart';
import 'package:kalivra/view/screens/drawer_screens/profile_screens/edit_profile_screen.dart';
import 'package:kalivra/view/screens/drawer_screens/favorites_screen.dart';
import 'package:kalivra/model/order/order_model.dart';
import 'package:kalivra/view/screens/drawer_screens/orders_screens/order_details_screen.dart';
import 'package:kalivra/view/screens/drawer_screens/orders_screens/orders_screen.dart';
import 'package:kalivra/view/screens/drawer_screens/privacy_screen.dart';
import 'package:kalivra/view/screens/drawer_screens/rate_screen.dart';
import 'package:kalivra/view/screens/drawer_screens/change_password_screen.dart';
import 'package:kalivra/view/screens/drawer_screens/confirm_new_phone_screen.dart';
import 'package:kalivra/view/screens/drawer_screens/language_screen.dart';
import 'package:kalivra/view/screens/drawer_screens/otp_code_entry_screen.dart';
import 'package:kalivra/view/screens/drawer_screens/otp_phone_entry_screen.dart';
import 'package:kalivra/view/screens/drawer_screens/settings_screen.dart';
import 'package:kalivra/view/screens/drawer_screens/set_new_password_screen.dart';
import 'package:kalivra/view/screens/drawer_screens/theme_mode_screen.dart';
import 'package:kalivra/view/screens/home/product_details_screen.dart';
import 'package:kalivra/view/screens/home/brand_details_screen.dart';
import 'package:kalivra/view/screens/home/all_brands_screen.dart';
import 'package:kalivra/view/screens/home/all_products_screen.dart';
import 'package:kalivra/view/screens/home/all_sale_products_screen.dart';
import 'package:kalivra/view/screens/home/ad_details_screen.dart';
import 'package:kalivra/view/screens/home/cart_screen.dart';
import 'package:kalivra/view/screens/checkout/checkout_screen.dart';
import 'package:kalivra/view/screens/auth/intro_screen.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/view/screens/auth/auth_otp_screen.dart';
import 'package:kalivra/view/screens/auth/login_screen.dart';
import 'package:kalivra/view/screens/auth/sign_up_screen.dart';
import 'package:kalivra/view/screens/auth/complete_profile_screen.dart';
import 'package:kalivra/model/product/product_model.dart';
import 'package:kalivra/model/brand/brand_model.dart';
import 'package:kalivra/model/ad/advertisement_model.dart';

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
  static const String authOtp = '/auth-otp';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String associationLinkRequest = '/association-link-request';
  static const String associationMemberProfile = '/association-member-profile';
  static const String associationDrafts = '/association-drafts';
  static const String associationSubmittedRequests =
      '/association-submitted-requests';
}

abstract class AppRoutesName {
  static const String splash = 'splash';
  static const String home = 'home';
  static const String account = 'account';
  static const String orders = 'orders';
  static const String favorites = 'favorites';
  static const String settings = 'settings';
  static const String contact = 'contact';
  static const String about = 'about';
  static const String privacy = 'privacy';
  static const String rate = 'rate';
  static const String editProfile = 'edit-profile';
  static const String orderDetails = 'order-details';
  static const String language = 'language';
  static const String changePassword = 'change-password';
  static const String otp = 'otp';
  static const String otpVerify = 'otp-verify';
  static const String setNewPassword = 'set-new-password';
  static const String confirmNewPhone = 'confirm-new-phone';
  static const String themeMode = 'theme-mode';
  static const String productDetails = 'product-details';
  static const String brandDetails = 'brand-details';
  static const String allBrands = 'all-brands';
  static const String allProducts = 'all-products';
  static const String allSaleProducts = 'all-sale-products';
  static const String allAds = 'all-ads';
  static const String adDetails = 'ad-details';
  static const String intro = 'intro';
  static const String login = 'login';
  static const String signUp = 'sign-up';
  static const String completeProfile = 'complete-profile';
  static const String authOtp = 'auth-otp';
  static const String cart = 'cart';
  static const String checkout = 'checkout';
  static const String associationLinkRequest = 'association-link-request';
  static const String associationMemberProfile = 'association-member-profile';
  static const String associationDrafts = 'association-drafts';
  static const String associationSubmittedRequests =
      'association-submitted-requests';
}

abstract class AppRouter {
  static void openScreenWithPop(BuildContext context, String location) {
    context.push(location);
  }

  static void openScreen(BuildContext context, String location) {
    context.go(location);
  }

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.splash,
        name: AppRoutesName.splash,
        builder: (_, _) => const SplashScreen(),
        routes: <RouteBase>[
          GoRoute(
            path: AppRoutes.intro,
            name: AppRoutesName.intro,
            builder: (_, _) => const IntroScreen(),
          ),
          GoRoute(
            path: AppRoutes.login,
            name: AppRoutesName.login,
            builder: (_, _) => const LoginScreen(),
          ),
          GoRoute(
            path: AppRoutes.signUp,
            name: AppRoutesName.signUp,
            builder: (_, _) => const SignUpScreen(),
          ),
          GoRoute(
            path: AppRoutes.completeProfile,
            name: AppRoutesName.completeProfile,
            builder: (context, state) {
              final args = state.extra as OtpOnboardingArgs?;
              return CompleteProfileScreen(args: args);
            },
          ),
          GoRoute(
            path: AppRoutes.authOtp,
            name: AppRoutesName.authOtp,
            builder: (context, state) {
              final args = state.extra as AuthOtpArgs?;
              if (args == null) {
                return Scaffold(
                  body: Center(
                    child: Text(AppLocalizations.of(context)!.errorMissingData),
                  ),
                );
              }
              return AuthOtpScreen(args: args);
            },
          ),
          GoRoute(
            path: AppRoutes.home,
            name: AppRoutesName.home,
            builder: (_, _) => const HomeScreen(),
          ),
          GoRoute(
            path: AppRoutes.account,
            name: AppRoutesName.account,
            builder: (_, _) => const Profile(),
          ),
          GoRoute(
            path: AppRoutes.editProfile,
            name: AppRoutesName.editProfile,
            builder: (_, _) => const EditProfileScreen(),
          ),
          GoRoute(
            path: AppRoutes.orders,
            name: AppRoutesName.orders,
            builder: (_, _) => const OrdersScreen(),
          ),
          GoRoute(
            path: AppRoutes.orderDetails,
            name: AppRoutesName.orderDetails,
            builder: (context, state) {
              final order = state.extra as OrderModel?;
              if (order == null) {
                return Scaffold(
                  body: Center(
                    child: Text(AppLocalizations.of(context)!.noOrder),
                  ),
                );
              }
              return OrderDetailsScreen(order: order);
            },
          ),
          GoRoute(
            path: AppRoutes.favorites,
            name: AppRoutesName.favorites,
            builder: (_, _) => const FavoritesScreen(),
          ),
          GoRoute(
            path: AppRoutes.settings,
            name: AppRoutesName.settings,
            builder: (_, _) => const SettingsScreen(),
          ),
          GoRoute(
            path: AppRoutes.language,
            name: AppRoutesName.language,
            builder: (_, _) => const LanguageScreen(),
          ),
          GoRoute(
            path: AppRoutes.changePassword,
            name: AppRoutesName.changePassword,
            builder: (_, _) => const ChangePasswordScreen(),
          ),
          GoRoute(
            path: AppRoutes.otp,
            name: AppRoutesName.otp,
            builder: (context, state) {
              final extra = state.extra;
              if (extra is OtpOnboardingArgs &&
                  extra.mode == OtpScreenMode.signUp) {
                return OtpPhoneEntryScreen(signUpArgs: extra);
              }
              return OtpPhoneEntryScreen(
                mode: extra as OtpScreenMode? ?? OtpScreenMode.changePhone,
              );
            },
          ),
          GoRoute(
            path: AppRoutes.otpVerify,
            name: AppRoutesName.otpVerify,
            builder: (context, state) {
              final args = state.extra as OtpOnboardingArgs?;
              if (args == null) {
                return Scaffold(
                  body: Center(
                    child: Text(AppLocalizations.of(context)!.errorMissingData),
                  ),
                );
              }
              return OtpCodeEntryScreen(args: args);
            },
          ),
          GoRoute(
            path: AppRoutes.setNewPassword,
            name: AppRoutesName.setNewPassword,
            builder: (_, _) => const SetNewPasswordScreen(),
          ),
          GoRoute(
            path: AppRoutes.confirmNewPhone,
            name: AppRoutesName.confirmNewPhone,
            builder: (context, state) {
              final phone = state.extra as String? ?? '';
              return ConfirmNewPhoneScreen(phone: phone);
            },
          ),
          GoRoute(
            path: AppRoutes.contact,
            name: AppRoutesName.contact,
            builder: (_, _) => const ContactScreen(),
          ),
          GoRoute(
            path: AppRoutes.about,
            name: AppRoutesName.about,
            builder: (_, _) => const AboutScreen(),
          ),
          GoRoute(
            path: AppRoutes.privacy,
            name: AppRoutesName.privacy,
            builder: (_, _) => const PrivacyScreen(),
          ),
          GoRoute(
            path: AppRoutes.rate,
            name: AppRoutesName.rate,
            builder: (_, _) => const RateScreen(),
          ),
          GoRoute(
            path: AppRoutes.themeMode,
            name: AppRoutesName.themeMode,
            builder: (_, _) => const ThemeModeScreen(),
          ),
          GoRoute(
            path: AppRoutes.productDetails,
            name: AppRoutesName.productDetails,
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
            name: AppRoutesName.brandDetails,
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
            name: AppRoutesName.allBrands,
            builder: (_, _) => const AllBrandsScreen(),
          ),
          GoRoute(
            path: AppRoutes.allProducts,
            name: AppRoutesName.allProducts,
            builder: (_, _) => const AllProductsScreen(),
          ),
          GoRoute(
            path: AppRoutes.allSaleProducts,
            name: AppRoutesName.allSaleProducts,
            builder: (_, _) => const AllSaleProductsScreen(),
          ),
          GoRoute(
            path: AppRoutes.adDetails,
            name: AppRoutesName.adDetails,
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
            name: AppRoutesName.cart,
            builder: (_, _) => const CartScreen(),
          ),
          GoRoute(
            path: AppRoutes.checkout,
            name: AppRoutesName.checkout,
            builder: (_, _) => const CheckoutScreen(),
          ),
          GoRoute(
            path: AppRoutes.associationMemberProfile,
            name: AppRoutesName.associationMemberProfile,
            builder: (_, _) => const AssociationMemberProfileScreen(),
          ),
          GoRoute(
            path: AppRoutes.associationLinkRequest,
            builder: (context, state) {
              final extra = state.extra as Map<String, dynamic>?;
              return AssociationLinkRequestScreen(
                draftId: extra?['draftId'] as String?,
                resubmit: extra?['resubmit'] as bool? ?? false,
              );
            },
          ),
          GoRoute(
            path: AppRoutes.associationDrafts,
            builder: (context, state) => const AssociationDraftsScreen(),
          ),
          GoRoute(
            path: AppRoutes.associationSubmittedRequests,
            builder: (context, state) =>
                const AssociationSubmittedRequestsScreen(),
          ),
        ],
      ),
    ],
  );
}
