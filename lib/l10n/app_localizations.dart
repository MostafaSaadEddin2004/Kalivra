import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// The conventional newborn programmer greeting
  ///
  /// In en, this message translates to:
  /// **'Hello World!'**
  String get helloWorld;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navCategories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get navCategories;

  /// No description provided for @navNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get navNotifications;

  /// No description provided for @navSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get navSearch;

  /// No description provided for @drawerMyAccount.
  ///
  /// In en, this message translates to:
  /// **'My Account'**
  String get drawerMyAccount;

  /// No description provided for @drawerMyOrders.
  ///
  /// In en, this message translates to:
  /// **'My Orders'**
  String get drawerMyOrders;

  /// No description provided for @drawerFavorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get drawerFavorites;

  /// No description provided for @drawerSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get drawerSettings;

  /// No description provided for @drawerContactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get drawerContactUs;

  /// No description provided for @drawerAboutApp.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get drawerAboutApp;

  /// No description provided for @drawerPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get drawerPrivacyPolicy;

  /// No description provided for @drawerShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get drawerShare;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearance;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsAccountSecurity.
  ///
  /// In en, this message translates to:
  /// **'Account & Security'**
  String get settingsAccountSecurity;

  /// No description provided for @settingsChangePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get settingsChangePassword;

  /// No description provided for @settingsChangePhone.
  ///
  /// In en, this message translates to:
  /// **'Change Phone Number'**
  String get settingsChangePhone;

  /// No description provided for @appearanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearanceTitle;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get themeDark;

  /// No description provided for @themeDarkSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get themeDarkSubtitle;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get themeLight;

  /// No description provided for @themeLightSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Light mode'**
  String get themeLightSubtitle;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get themeSystem;

  /// No description provided for @themeSystemSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Follow device setting'**
  String get themeSystemSubtitle;

  /// No description provided for @languageTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageTitle;

  /// No description provided for @languageArabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get languageArabic;

  /// No description provided for @languageArabicSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get languageArabicSubtitle;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageEnglishSubtitle.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglishSubtitle;

  /// No description provided for @languageFollowSystem.
  ///
  /// In en, this message translates to:
  /// **'Follow system'**
  String get languageFollowSystem;

  /// No description provided for @languageFollowSystemSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use device language'**
  String get languageFollowSystemSubtitle;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version 1.0.0'**
  String get version;

  /// No description provided for @menu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

  /// No description provided for @cart.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get cart;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @loginRequiredForCart.
  ///
  /// In en, this message translates to:
  /// **'Please sign in to add products to the cart'**
  String get loginRequiredForCart;

  /// No description provided for @addToCartSuccess.
  ///
  /// In en, this message translates to:
  /// **'Added \"{productName}\" to cart'**
  String addToCartSuccess(String productName);

  /// No description provided for @continueShopping.
  ///
  /// In en, this message translates to:
  /// **'Continue Shopping'**
  String get continueShopping;

  /// No description provided for @emptyCart.
  ///
  /// In en, this message translates to:
  /// **'Empty Cart'**
  String get emptyCart;

  /// No description provided for @priceDetails.
  ///
  /// In en, this message translates to:
  /// **'Price Details'**
  String get priceDetails;

  /// No description provided for @subtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// No description provided for @discount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get discount;

  /// No description provided for @tax.
  ///
  /// In en, this message translates to:
  /// **'Tax'**
  String get tax;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @deliveryCost.
  ///
  /// In en, this message translates to:
  /// **'Delivery'**
  String get deliveryCost;

  /// No description provided for @productsTotal.
  ///
  /// In en, this message translates to:
  /// **'Products Total'**
  String get productsTotal;

  /// No description provided for @amountDue.
  ///
  /// In en, this message translates to:
  /// **'Amount Due'**
  String get amountDue;

  /// No description provided for @proceed.
  ///
  /// In en, this message translates to:
  /// **'Proceed'**
  String get proceed;

  /// No description provided for @productDetails.
  ///
  /// In en, this message translates to:
  /// **'Product Details'**
  String get productDetails;

  /// No description provided for @invalidProductId.
  ///
  /// In en, this message translates to:
  /// **'Invalid product ID'**
  String get invalidProductId;

  /// No description provided for @addToWishlistSuccess.
  ///
  /// In en, this message translates to:
  /// **'Added \"{productName}\" to favorites'**
  String addToWishlistSuccess(String productName);

  /// No description provided for @addToWishlistFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to add product to favorites'**
  String get addToWishlistFailed;

  /// No description provided for @unit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get unit;

  /// No description provided for @maxOrderLimit.
  ///
  /// In en, this message translates to:
  /// **'Max order limit'**
  String get maxOrderLimit;

  /// No description provided for @addToWishlist.
  ///
  /// In en, this message translates to:
  /// **'Add to Favorites'**
  String get addToWishlist;

  /// No description provided for @addToCart.
  ///
  /// In en, this message translates to:
  /// **'Add to Cart'**
  String get addToCart;

  /// No description provided for @notificationsWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Kalivra'**
  String get notificationsWelcomeTitle;

  /// No description provided for @notificationsWelcomeBody.
  ///
  /// In en, this message translates to:
  /// **'Discover building and decor products at competitive prices.'**
  String get notificationsWelcomeBody;

  /// No description provided for @now.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get now;

  /// No description provided for @notificationsPaintOfferTitle.
  ///
  /// In en, this message translates to:
  /// **'Special offer on paints'**
  String get notificationsPaintOfferTitle;

  /// No description provided for @notificationsPaintOfferBody.
  ///
  /// In en, this message translates to:
  /// **'Up to 20% off on paint collection this week.'**
  String get notificationsPaintOfferBody;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @notificationsOrderProcessingTitle.
  ///
  /// In en, this message translates to:
  /// **'Your order is being processed'**
  String get notificationsOrderProcessingTitle;

  /// No description provided for @notificationsOrderProcessingBody.
  ///
  /// In en, this message translates to:
  /// **'We have received your order. Shipping within 24 hours.'**
  String get notificationsOrderProcessingBody;

  /// No description provided for @twoDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'Two days ago'**
  String get twoDaysAgo;

  /// No description provided for @loginRequiredForNotifications.
  ///
  /// In en, this message translates to:
  /// **'Sign in to view notifications'**
  String get loginRequiredForNotifications;

  /// No description provided for @notificationsLoginPrompt.
  ///
  /// In en, this message translates to:
  /// **'Sign in or create an account to receive order and offer notifications.'**
  String get notificationsLoginPrompt;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @loadCategoriesFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load categories or products'**
  String get loadCategoriesFailed;

  /// No description provided for @allProducts.
  ///
  /// In en, this message translates to:
  /// **'All Products'**
  String get allProducts;

  /// No description provided for @product.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get product;

  /// No description provided for @noProductsInCategory.
  ///
  /// In en, this message translates to:
  /// **'No products in this category'**
  String get noProductsInCategory;

  /// No description provided for @offers.
  ///
  /// In en, this message translates to:
  /// **'Offers'**
  String get offers;

  /// No description provided for @loadOffersFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load offers'**
  String get loadOffersFailed;

  /// No description provided for @noOffers.
  ///
  /// In en, this message translates to:
  /// **'No offers at the moment'**
  String get noOffers;

  /// No description provided for @allSaleProducts.
  ///
  /// In en, this message translates to:
  /// **'All Sale Products'**
  String get allSaleProducts;

  /// No description provided for @products.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get products;

  /// No description provided for @loadProductsFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load products'**
  String get loadProductsFailed;

  /// No description provided for @noProducts.
  ///
  /// In en, this message translates to:
  /// **'No products'**
  String get noProducts;

  /// No description provided for @branchCount.
  ///
  /// In en, this message translates to:
  /// **'Branches'**
  String get branchCount;

  /// No description provided for @locations.
  ///
  /// In en, this message translates to:
  /// **'Locations'**
  String get locations;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @website.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get website;

  /// No description provided for @noProductsForBrand.
  ///
  /// In en, this message translates to:
  /// **'No products for this brand at the moment'**
  String get noProductsForBrand;

  /// No description provided for @noOffersForBrand.
  ///
  /// In en, this message translates to:
  /// **'No offers for this brand at the moment'**
  String get noOffersForBrand;

  /// No description provided for @orderSummary.
  ///
  /// In en, this message translates to:
  /// **'Order Summary'**
  String get orderSummary;

  /// No description provided for @quantityLabel.
  ///
  /// In en, this message translates to:
  /// **'Quantity: {count}'**
  String quantityLabel(int count);

  /// No description provided for @shipping.
  ///
  /// In en, this message translates to:
  /// **'Shipping'**
  String get shipping;

  /// No description provided for @checkoutStepAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get checkoutStepAddress;

  /// No description provided for @checkoutStepShipping.
  ///
  /// In en, this message translates to:
  /// **'Shipping'**
  String get checkoutStepShipping;

  /// No description provided for @checkoutStepPayment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get checkoutStepPayment;

  /// No description provided for @checkoutStepComplete.
  ///
  /// In en, this message translates to:
  /// **'Complete Order'**
  String get checkoutStepComplete;

  /// No description provided for @completeStepData.
  ///
  /// In en, this message translates to:
  /// **'Please complete the required fields in this step'**
  String get completeStepData;

  /// No description provided for @placeOrderFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to place order. Please try again.'**
  String get placeOrderFailed;

  /// No description provided for @myAccount.
  ///
  /// In en, this message translates to:
  /// **'My Account'**
  String get myAccount;

  /// No description provided for @loginToViewProfile.
  ///
  /// In en, this message translates to:
  /// **'Sign in to view your profile'**
  String get loginToViewProfile;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @accountInfo.
  ///
  /// In en, this message translates to:
  /// **'Account Information'**
  String get accountInfo;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @mobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get mobileNumber;

  /// No description provided for @joinDate.
  ///
  /// In en, this message translates to:
  /// **'Join Date'**
  String get joinDate;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @mainAddress.
  ///
  /// In en, this message translates to:
  /// **'Main Address'**
  String get mainAddress;

  /// No description provided for @postalCode.
  ///
  /// In en, this message translates to:
  /// **'Postal Code'**
  String get postalCode;

  /// No description provided for @stats.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get stats;

  /// No description provided for @ordersCount.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get ordersCount;

  /// No description provided for @pendingOrders.
  ///
  /// In en, this message translates to:
  /// **'Pending Orders'**
  String get pendingOrders;

  /// No description provided for @memberSince.
  ///
  /// In en, this message translates to:
  /// **'Member since {year}'**
  String memberSince(int year);

  /// No description provided for @referralCode.
  ///
  /// In en, this message translates to:
  /// **'Referral Code'**
  String get referralCode;

  /// No description provided for @referralCodeHint.
  ///
  /// In en, this message translates to:
  /// **'Share this code or scan with friends to get a discount on sign-up. You benefit too.'**
  String get referralCodeHint;

  /// No description provided for @customerSince.
  ///
  /// In en, this message translates to:
  /// **'Customer since {year}'**
  String customerSince(int year);

  /// No description provided for @myOrders.
  ///
  /// In en, this message translates to:
  /// **'My Orders'**
  String get myOrders;

  /// No description provided for @loadOrdersFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load orders'**
  String get loadOrdersFailed;

  /// No description provided for @noOrders.
  ///
  /// In en, this message translates to:
  /// **'No orders yet'**
  String get noOrders;

  /// No description provided for @ordersPrompt.
  ///
  /// In en, this message translates to:
  /// **'Your orders will appear here'**
  String get ordersPrompt;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @statusComplete.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get statusComplete;

  /// No description provided for @statusShipping.
  ///
  /// In en, this message translates to:
  /// **'Shipping'**
  String get statusShipping;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @loadFavoritesFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load favorites'**
  String get loadFavoritesFailed;

  /// No description provided for @favoritesEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your favorites list is empty'**
  String get favoritesEmpty;

  /// No description provided for @favoritesPrompt.
  ///
  /// In en, this message translates to:
  /// **'Add products to favorites using the heart button on the product page'**
  String get favoritesPrompt;

  /// No description provided for @shopNow.
  ///
  /// In en, this message translates to:
  /// **'Shop Now'**
  String get shopNow;

  /// No description provided for @addressSaved.
  ///
  /// In en, this message translates to:
  /// **'Address saved'**
  String get addressSaved;

  /// No description provided for @saveAddress.
  ///
  /// In en, this message translates to:
  /// **'Save Address'**
  String get saveAddress;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethod;

  /// No description provided for @cashOnDelivery.
  ///
  /// In en, this message translates to:
  /// **'Cash on Delivery'**
  String get cashOnDelivery;

  /// No description provided for @cashOnDeliverySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pay in cash when you receive your order'**
  String get cashOnDeliverySubtitle;

  /// No description provided for @onlinePayment.
  ///
  /// In en, this message translates to:
  /// **'Online Payment'**
  String get onlinePayment;

  /// No description provided for @onlinePaymentSubtitle.
  ///
  /// In en, this message translates to:
  /// **'ShamCash, Syriatel Cash, MTN Cash'**
  String get onlinePaymentSubtitle;

  /// No description provided for @selectPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Select online payment method'**
  String get selectPaymentMethod;

  /// No description provided for @walletDetails.
  ///
  /// In en, this message translates to:
  /// **'Wallet Details'**
  String get walletDetails;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @invalidPhone.
  ///
  /// In en, this message translates to:
  /// **'Invalid phone number'**
  String get invalidPhone;

  /// No description provided for @walletPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Wallet phone number *'**
  String get walletPhoneLabel;

  /// No description provided for @walletNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name as in wallet (optional)'**
  String get walletNameLabel;

  /// No description provided for @walletNameHint.
  ///
  /// In en, this message translates to:
  /// **'For payment verification'**
  String get walletNameHint;

  /// No description provided for @paymentShamcash.
  ///
  /// In en, this message translates to:
  /// **'ShamCash'**
  String get paymentShamcash;

  /// No description provided for @paymentSyriatel.
  ///
  /// In en, this message translates to:
  /// **'Syriatel Cash'**
  String get paymentSyriatel;

  /// No description provided for @paymentMtn.
  ///
  /// In en, this message translates to:
  /// **'MTN Cash'**
  String get paymentMtn;

  /// No description provided for @paymentShamcashDesc.
  ///
  /// In en, this message translates to:
  /// **'Syrian e-wallet for transfer and payment via app'**
  String get paymentShamcashDesc;

  /// No description provided for @paymentSyriatelDesc.
  ///
  /// In en, this message translates to:
  /// **'Syriatel e-payment platform for transfer and payment'**
  String get paymentSyriatelDesc;

  /// No description provided for @paymentMtnDesc.
  ///
  /// In en, this message translates to:
  /// **'MTN Syria mobile wallet service'**
  String get paymentMtnDesc;

  /// No description provided for @shippingMethod.
  ///
  /// In en, this message translates to:
  /// **'Shipping Method'**
  String get shippingMethod;

  /// No description provided for @standardDelivery.
  ///
  /// In en, this message translates to:
  /// **'Standard delivery'**
  String get standardDelivery;

  /// No description provided for @standardDeliveryDesc.
  ///
  /// In en, this message translates to:
  /// **'5-7 business days'**
  String get standardDeliveryDesc;

  /// No description provided for @fastDelivery.
  ///
  /// In en, this message translates to:
  /// **'Fast delivery'**
  String get fastDelivery;

  /// No description provided for @fastDeliveryDesc.
  ///
  /// In en, this message translates to:
  /// **'2-3 business days'**
  String get fastDeliveryDesc;

  /// No description provided for @sameDayDelivery.
  ///
  /// In en, this message translates to:
  /// **'Same day'**
  String get sameDayDelivery;

  /// No description provided for @sameDayDeliveryDesc.
  ///
  /// In en, this message translates to:
  /// **'Order before 12 noon'**
  String get sameDayDeliveryDesc;

  /// No description provided for @preferredDeliveryDate.
  ///
  /// In en, this message translates to:
  /// **'Preferred delivery date'**
  String get preferredDeliveryDate;

  /// No description provided for @chooseDate.
  ///
  /// In en, this message translates to:
  /// **'Choose date'**
  String get chooseDate;

  /// No description provided for @deliveryNotes.
  ///
  /// In en, this message translates to:
  /// **'Delivery notes (optional)'**
  String get deliveryNotes;

  /// No description provided for @deliveryNotesHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Leave at door, call on arrival...'**
  String get deliveryNotesHint;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @firstNameRequired.
  ///
  /// In en, this message translates to:
  /// **'First Name *'**
  String get firstNameRequired;

  /// No description provided for @lastNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Last Name *'**
  String get lastNameRequired;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email *'**
  String get emailRequired;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'example@email.com'**
  String get emailHint;

  /// No description provided for @companyName.
  ///
  /// In en, this message translates to:
  /// **'Company Name'**
  String get companyName;

  /// No description provided for @phoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone *'**
  String get phoneRequired;

  /// No description provided for @streetRequired.
  ///
  /// In en, this message translates to:
  /// **'Street *'**
  String get streetRequired;

  /// No description provided for @streetHint.
  ///
  /// In en, this message translates to:
  /// **'Street address'**
  String get streetHint;

  /// No description provided for @postalCodeRequired.
  ///
  /// In en, this message translates to:
  /// **'Postal Code *'**
  String get postalCodeRequired;

  /// No description provided for @stateRequired.
  ///
  /// In en, this message translates to:
  /// **'State *'**
  String get stateRequired;

  /// No description provided for @cityRequired.
  ///
  /// In en, this message translates to:
  /// **'City *'**
  String get cityRequired;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get invalidEmail;

  /// No description provided for @noOrder.
  ///
  /// In en, this message translates to:
  /// **'No order'**
  String get noOrder;

  /// No description provided for @errorMissingData.
  ///
  /// In en, this message translates to:
  /// **'Error: Data was not passed'**
  String get errorMissingData;

  /// No description provided for @productUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Product unavailable'**
  String get productUnavailable;

  /// No description provided for @brandUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Brand unavailable'**
  String get brandUnavailable;

  /// No description provided for @adUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Ad unavailable'**
  String get adUnavailable;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get login;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Sign in failed'**
  String get loginFailed;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get loginTitle;

  /// No description provided for @loginHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number and password to access your account'**
  String get loginHint;

  /// No description provided for @enterPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter phone number'**
  String get enterPhone;

  /// No description provided for @invalidPhoneShort.
  ///
  /// In en, this message translates to:
  /// **'Invalid number'**
  String get invalidPhoneShort;

  /// No description provided for @phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneLabel;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter password'**
  String get enterPassword;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get noAccount;

  /// No description provided for @registerNow.
  ///
  /// In en, this message translates to:
  /// **'Register now'**
  String get registerNow;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get signUp;

  /// No description provided for @signUpHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your details to register and verify your phone via WhatsApp'**
  String get signUpHint;

  /// No description provided for @enterName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enterName;

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMinLength;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @confirmPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter confirmation password'**
  String get confirmPasswordRequired;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @continueVerification.
  ///
  /// In en, this message translates to:
  /// **'Continue to Verify'**
  String get continueVerification;

  /// No description provided for @haveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get haveAccount;

  /// No description provided for @unexpectedError.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred'**
  String get unexpectedError;

  /// No description provided for @inviteCodeQuestion.
  ///
  /// In en, this message translates to:
  /// **'Have an invite code from a friend?'**
  String get inviteCodeQuestion;

  /// No description provided for @inviteCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Invite Code'**
  String get inviteCodeLabel;

  /// No description provided for @inviteCodeHint.
  ///
  /// In en, this message translates to:
  /// **'Enter code or tap icon to scan or choose image'**
  String get inviteCodeHint;

  /// No description provided for @codeCopied.
  ///
  /// In en, this message translates to:
  /// **'Code copied'**
  String get codeCopied;

  /// No description provided for @changePasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePasswordTitle;

  /// No description provided for @passwordUpdated.
  ///
  /// In en, this message translates to:
  /// **'Password updated'**
  String get passwordUpdated;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get currentPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @newPasswordConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get newPasswordConfirm;

  /// No description provided for @passwordUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password updated successfully'**
  String get passwordUpdatedSuccess;

  /// No description provided for @completeProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Complete Your Profile'**
  String get completeProfileTitle;

  /// No description provided for @addressOrLocation.
  ///
  /// In en, this message translates to:
  /// **'Address / Location'**
  String get addressOrLocation;

  /// No description provided for @editProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfileTitle;

  /// No description provided for @profileSaved.
  ///
  /// In en, this message translates to:
  /// **'Changes saved'**
  String get profileSaved;

  /// No description provided for @personalInfo.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInfo;

  /// No description provided for @newPhoneSuccess.
  ///
  /// In en, this message translates to:
  /// **'Phone number changed successfully'**
  String get newPhoneSuccess;

  /// No description provided for @changePhoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Change Phone Number'**
  String get changePhoneTitle;

  /// No description provided for @sendCodeViaWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'Send code via WhatsApp'**
  String get sendCodeViaWhatsApp;

  /// No description provided for @enterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter phone number'**
  String get enterPhoneNumber;

  /// No description provided for @enterCode4To6.
  ///
  /// In en, this message translates to:
  /// **'Enter the 4-6 digit code'**
  String get enterCode4To6;

  /// No description provided for @rateTitle.
  ///
  /// In en, this message translates to:
  /// **'Rate'**
  String get rateTitle;

  /// No description provided for @submitRating.
  ///
  /// In en, this message translates to:
  /// **'Submit Rating'**
  String get submitRating;

  /// No description provided for @thanksForRating.
  ///
  /// In en, this message translates to:
  /// **'Thanks for your rating'**
  String get thanksForRating;

  /// No description provided for @size.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get size;

  /// No description provided for @color.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get color;

  /// No description provided for @dash.
  ///
  /// In en, this message translates to:
  /// **'—'**
  String get dash;

  /// No description provided for @confirmOrder.
  ///
  /// In en, this message translates to:
  /// **'Confirm Order'**
  String get confirmOrder;

  /// No description provided for @introTitle1.
  ///
  /// In en, this message translates to:
  /// **'What is Kalivra?'**
  String get introTitle1;

  /// No description provided for @introTitle2.
  ///
  /// In en, this message translates to:
  /// **'What we offer'**
  String get introTitle2;

  /// No description provided for @introTitle3.
  ///
  /// In en, this message translates to:
  /// **'Join us'**
  String get introTitle3;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
