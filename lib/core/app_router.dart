import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/model/association/association_announcement_model.dart';
import 'package:kalivra/model/customer/customer_api_model.dart';
import 'package:kalivra/view/screens/profile_screens/association_screens/association_announcement_details_screen.dart';
import 'package:kalivra/view/screens/profile_screens/association_screens/association_announcements_screen.dart';
import 'package:kalivra/view/screens/profile_screens/association_screens/association_contact_us_screen.dart';
import 'package:kalivra/view/screens/profile_screens/association_screens/association_faq_screen.dart';
import 'package:kalivra/view/screens/profile_screens/association_screens/association_requests_and_services_screen.dart';
import 'package:kalivra/view/screens/profile_screens/association_screens/association_submitted_requests_screen.dart';
import 'package:kalivra/view/screens/profile_screens/terms_conditions_screen.dart';
import 'package:kalivra/view/splash_screen.dart';
import 'package:kalivra/view/screens/home/home_screen.dart';
import 'package:kalivra/view/screens/profile_screens/about_screen.dart';
import 'package:kalivra/view/screens/profile_screens/profile_screens/profile_screen.dart';
import 'package:kalivra/view/screens/profile_screens/contact_screen.dart';
import 'package:kalivra/view/screens/profile_screens/association_screens/association_member_profile_screen.dart';
import 'package:kalivra/view/screens/profile_screens/profile_screens/edit_profile_screen.dart';
import 'package:kalivra/view/screens/profile_screens/favorites_screen.dart';
import 'package:kalivra/view/screens/profile_screens/kalivra_faq_screen.dart';
import 'package:kalivra/model/order/order_model.dart';
import 'package:kalivra/view/screens/profile_screens/orders_screens/order_details_screen.dart';
import 'package:kalivra/view/screens/profile_screens/orders_screens/orders_screen.dart';
import 'package:kalivra/view/screens/profile_screens/privacy_policy_screen.dart';
import 'package:kalivra/view/screens/profile_screens/rate_screen.dart';
import 'package:kalivra/view/screens/profile_screens/change_password_screen.dart';
import 'package:kalivra/view/screens/profile_screens/confirm_new_phone_screen.dart';
import 'package:kalivra/view/screens/profile_screens/language_screen.dart';
import 'package:kalivra/view/screens/profile_screens/otp_phone_entry_screen.dart';
import 'package:kalivra/view/screens/profile_screens/settings_screen.dart';
import 'package:kalivra/view/screens/profile_screens/set_new_password_screen.dart';
import 'package:kalivra/view/screens/profile_screens/theme_mode_screen.dart';
import 'package:kalivra/view/screens/home/product_details_screen.dart';
import 'package:kalivra/view/screens/home/brand_details_screen.dart';
import 'package:kalivra/view/screens/home/all_categories_screen.dart';
import 'package:kalivra/view/screens/home/category_products_screen.dart';
import 'package:kalivra/view/screens/home/all_brands_screen.dart';
import 'package:kalivra/view/screens/home/all_products_screen.dart';
import 'package:kalivra/view/screens/home/all_sale_products_screen.dart';
import 'package:kalivra/view/screens/home/ad_details_screen.dart';
import 'package:kalivra/view/screens/home/cart_screen.dart';
import 'package:kalivra/view/screens/home/notifications_screen.dart';
import 'package:kalivra/view/screens/home/search_screen.dart';
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
import 'package:kalivra/model/category/category_api_model.dart';

abstract class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String account = '/account';
  static const String orders = '/orders';
  static const String favorites = '/favorites';
  static const String settings = '/settings';
  static const String contact = '/contact';
  static const String about = '/about';
  static const String privacyPolicy = '/privacyPolicy';
  static const String termsConditions = '/termsConditions';
  static const String kalivraFaq = '/kalivra-faq';
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
  static const String allCategories = '/all-categories';
  static const String categoryProducts = '/category-products';
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
  static const String search = '/search';
  static const String notifications = '/notifications';
  static const String checkout = '/checkout';
  static const String associationMemberProfile = '/association-member-profile';
  static const String associationSubmittedRequests =
      '/association-submitted-requests';
  static const String associationFaq = '/association-faq';
  static const String associationContactUs = '/association-contact-us';
  static const String associationRequestsAndServices =
      '/association-requests-and-services';
  static const String associationAnnouncements = '/association-announcements';
  static const String associationAnnouncementDetails =
      '/association-announcement-details';
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
  static const String privacyPolicy = 'privacyPolicy';
  static const String termsConditions = 'termsConditions';
  static const String kalivraFaq = 'kalivra-faq';
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
  static const String allCategories = 'all-categories';
  static const String categoryProducts = 'categoryProducts';
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
  static const String search = 'search';
  static const String notifications = 'notifications';
  static const String checkout = 'checkout';
  static const String associationMemberProfile = 'association-member-profile';
  static const String associationSubmittedRequests =
      'association-submitted-requests';
  static const String associationFaq = 'association-faq';
  static const String associationContactUs = 'association-contact-us';
  static const String associationRequestsAndServices =
      'association-requests-and-services';
  static const String associationAnnouncements = 'association-announcements';
  static const String associationAnnouncementDetails =
      'association-announcement-details';
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
            builder: (_, state) {
              final extra = state.extra;
              final initialCategory = extra is CategoryApiModel ? extra : null;
              return HomeScreen(
                key: ValueKey('home-${initialCategory?.id ?? 'all'}'),
                initialCategory: initialCategory,
              );
            },
          ),
          GoRoute(
            path: AppRoutes.account,
            name: AppRoutesName.account,
            builder: (_, _) => const Profile(),
          ),
          GoRoute(
            path: AppRoutes.editProfile,
            name: AppRoutesName.editProfile,
            builder: (context, state) {
              final userInfo = state.extra as CustomerApiModel?;
              if (userInfo == null) {
                return const Profile();
              }
              return EditProfileScreen(userInfo: userInfo);
            },
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
            path: AppRoutes.setNewPassword,
            name: AppRoutesName.setNewPassword,
            builder: (context, state) {
              final whatsappNumber = state.extra as String? ?? '';
              return SetNewPasswordScreen(whatsappNumber: whatsappNumber);
            },
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
            path: AppRoutes.privacyPolicy,
            name: AppRoutesName.privacyPolicy,
            builder: (_, _) => const PrivacyPolicyScreen(),
          ),
          GoRoute(
            path: AppRoutes.termsConditions,
            name: AppRoutesName.termsConditions,
            builder: (_, _) => const TermsConditionsScreen(),
          ),
          GoRoute(
            path: AppRoutes.kalivraFaq,
            name: AppRoutesName.kalivraFaq,
            builder: (_, _) => const KalivraFaqScreen(),
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
            path: AppRoutes.allCategories,
            name: AppRoutesName.allCategories,
            builder: (_, _) => const AllCategoriesScreen(),
          ),
          GoRoute(
            path: AppRoutes.categoryProducts,
            name: AppRoutesName.categoryProducts,
            builder: (context, state) {
              final category = state.extra as CategoryApiModel?;
              if (category == null) {
                return Scaffold(
                  body: Center(
                    child: Text(AppLocalizations.of(context)!.navCategories),
                  ),
                );
              }
              return CategoryProductsScreen(category: category);
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
            path: AppRoutes.search,
            name: AppRoutesName.search,
            builder: (_, _) => const SearchScreen(),
          ),
          GoRoute(
            path: AppRoutes.notifications,
            name: AppRoutesName.notifications,
            builder: (_, _) => const NotificationsScreen(),
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
            path: AppRoutes.associationSubmittedRequests,
            builder: (context, state) =>
                const AssociationSubmittedRequestsScreen(),
          ),
          GoRoute(
            path: AppRoutes.associationFaq,
            name: AppRoutesName.associationFaq,
            builder: (context, state) => const AssociationFaqScreen(),
          ),
          GoRoute(
            path: AppRoutes.associationContactUs,
            name: AppRoutesName.associationContactUs,
            builder: (context, state) => const AssociationContactUsScreen(),
          ),
          GoRoute(
            path: AppRoutes.associationRequestsAndServices,
            name: AppRoutesName.associationRequestsAndServices,
            builder: (context, state) =>
                const AssociationRequestsAndServicesScreen(),
          ),
          GoRoute(
            path: AppRoutes.associationAnnouncements,
            name: AppRoutesName.associationAnnouncements,
            builder: (context, state) => const AssociationAnnouncementsScreen(),
          ),
          GoRoute(
            path: AppRoutes.associationAnnouncementDetails,
            name: AppRoutesName.associationAnnouncementDetails,
            builder: (context, state) {
              final extra = state.extra;
              final announcement = extra is AssociationAnnouncementModel
                  ? extra
                  : null;
              final id = announcement?.id ?? (extra is int ? extra : 0);

              if (id == 0) {
                return Scaffold(
                  body: Center(
                    child: Text(AppLocalizations.of(context)!.errorMissingData),
                  ),
                );
              }

              return AssociationAnnouncementDetailsScreen(
                announcementId: id,
                initialAnnouncement: announcement,
              );
            },
          ),
        ],
      ),
    ],
  );
}
