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

  /// No description provided for @drawerAssociationLinkRequest.
  ///
  /// In en, this message translates to:
  /// **'Association Link Request'**
  String get drawerAssociationLinkRequest;

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

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

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

  /// No description provided for @aboutAppDescription.
  ///
  /// In en, this message translates to:
  /// **'Kalivra gives you an easy and secure shopping experience for building and finishing products. Browse categories, order what you need, and track your orders in one place.'**
  String get aboutAppDescription;

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

  /// No description provided for @productOrderInfo.
  ///
  /// In en, this message translates to:
  /// **'Order information'**
  String get productOrderInfo;

  /// No description provided for @unitPiece.
  ///
  /// In en, this message translates to:
  /// **'Piece'**
  String get unitPiece;

  /// No description provided for @maxOrderLimitValue.
  ///
  /// In en, this message translates to:
  /// **'Up to {count} per order'**
  String maxOrderLimitValue(int count);

  /// No description provided for @addToWishlist.
  ///
  /// In en, this message translates to:
  /// **'Add to Favorites'**
  String get addToWishlist;

  /// No description provided for @removeFromWishlist.
  ///
  /// In en, this message translates to:
  /// **'Remove from Favorites'**
  String get removeFromWishlist;

  /// No description provided for @removeFromWishlistSuccess.
  ///
  /// In en, this message translates to:
  /// **'Removed \"{productName}\" from favorites'**
  String removeFromWishlistSuccess(String productName);

  /// No description provided for @removeFromWishlistFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to remove product from favorites'**
  String get removeFromWishlistFailed;

  /// No description provided for @addToCart.
  ///
  /// In en, this message translates to:
  /// **'Add to Cart'**
  String get addToCart;

  /// No description provided for @productSku.
  ///
  /// In en, this message translates to:
  /// **'SKU'**
  String get productSku;

  /// No description provided for @productDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get productDescription;

  /// No description provided for @productNew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get productNew;

  /// No description provided for @productFeatured.
  ///
  /// In en, this message translates to:
  /// **'Featured'**
  String get productFeatured;

  /// No description provided for @productOnSale.
  ///
  /// In en, this message translates to:
  /// **'On Sale'**
  String get productOnSale;

  /// No description provided for @productAvailability.
  ///
  /// In en, this message translates to:
  /// **'Availability'**
  String get productAvailability;

  /// No description provided for @productAvailable.
  ///
  /// In en, this message translates to:
  /// **'In stock'**
  String get productAvailable;

  /// No description provided for @productOutOfStock.
  ///
  /// In en, this message translates to:
  /// **'Out of stock'**
  String get productOutOfStock;

  /// No description provided for @productRating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get productRating;

  /// No description provided for @productRatingSummary.
  ///
  /// In en, this message translates to:
  /// **'{rating} / 5 ({count})'**
  String productRatingSummary(String rating, int count);

  /// No description provided for @productReviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get productReviews;

  /// No description provided for @productReviewsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} reviews'**
  String productReviewsCount(int count);

  /// No description provided for @productMinPriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Starting from'**
  String get productMinPriceLabel;

  /// No description provided for @productInfo.
  ///
  /// In en, this message translates to:
  /// **'Product information'**
  String get productInfo;

  /// No description provided for @productUrlKey.
  ///
  /// In en, this message translates to:
  /// **'Product link'**
  String get productUrlKey;

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

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

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

  /// No description provided for @loginSuccess.
  ///
  /// In en, this message translates to:
  /// **'Signed in successfully'**
  String get loginSuccess;

  /// No description provided for @invalidLoginCredentials.
  ///
  /// In en, this message translates to:
  /// **'Incorrect WhatsApp number or password'**
  String get invalidLoginCredentials;

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

  /// No description provided for @signUpWhatsAppLabel.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp Number'**
  String get signUpWhatsAppLabel;

  /// No description provided for @signUpWhatsAppHint.
  ///
  /// In en, this message translates to:
  /// **'9xx xxx xxx'**
  String get signUpWhatsAppHint;

  /// No description provided for @enterWhatsAppNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter WhatsApp number'**
  String get enterWhatsAppNumber;

  /// No description provided for @invalidWhatsAppShort.
  ///
  /// In en, this message translates to:
  /// **'Invalid WhatsApp number'**
  String get invalidWhatsAppShort;

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

  /// No description provided for @enterFirstName.
  ///
  /// In en, this message translates to:
  /// **'Enter first name'**
  String get enterFirstName;

  /// No description provided for @enterLastName.
  ///
  /// In en, this message translates to:
  /// **'Enter last name'**
  String get enterLastName;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter email'**
  String get enterEmail;

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

  /// No description provided for @enterCurrentPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter current password'**
  String get enterCurrentPassword;

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

  /// No description provided for @profileImageTooLarge.
  ///
  /// In en, this message translates to:
  /// **'Image must be 5 MB or smaller'**
  String get profileImageTooLarge;

  /// No description provided for @profileUnsupportedImageType.
  ///
  /// In en, this message translates to:
  /// **'Unsupported image type. Please choose a PNG, JPEG, JPG, or SVG image.'**
  String get profileUnsupportedImageType;

  /// No description provided for @skipForNow.
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get skipForNow;

  /// No description provided for @authOtpTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify account'**
  String get authOtpTitle;

  /// No description provided for @authOtpSentTo.
  ///
  /// In en, this message translates to:
  /// **'Verification code sent to {destination}'**
  String authOtpSentTo(String destination);

  /// No description provided for @authOtpVerifySuccess.
  ///
  /// In en, this message translates to:
  /// **'Account verified successfully'**
  String get authOtpVerifySuccess;

  /// No description provided for @authOtpVerifyFailed.
  ///
  /// In en, this message translates to:
  /// **'Verification failed. Please try again.'**
  String get authOtpVerifyFailed;

  /// No description provided for @authOtpCodeLength.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit verification code'**
  String get authOtpCodeLength;

  /// No description provided for @authOtpResendIn.
  ///
  /// In en, this message translates to:
  /// **'Resend again in {time}'**
  String authOtpResendIn(String time);

  /// No description provided for @authOtpResendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get authOtpResendCode;

  /// No description provided for @authOtpResendSuccess.
  ///
  /// In en, this message translates to:
  /// **'Verification code sent again'**
  String get authOtpResendSuccess;

  /// No description provided for @authOtpResendFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to resend code. Please try again.'**
  String get authOtpResendFailed;

  /// No description provided for @yourAccount.
  ///
  /// In en, this message translates to:
  /// **'your account'**
  String get yourAccount;

  /// No description provided for @profileCity.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get profileCity;

  /// No description provided for @profileCountry.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get profileCountry;

  /// No description provided for @genderLabel.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get genderLabel;

  /// No description provided for @dateOfBirthLabel.
  ///
  /// In en, this message translates to:
  /// **'Date of birth'**
  String get dateOfBirthLabel;

  /// No description provided for @dateOfBirthHint.
  ///
  /// In en, this message translates to:
  /// **'YYYY-MM-DD (optional)'**
  String get dateOfBirthHint;

  /// No description provided for @genderMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get genderMale;

  /// No description provided for @genderFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get genderFemale;

  /// No description provided for @genderOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get genderOther;

  /// No description provided for @changePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change photo'**
  String get changePhoto;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get saveChanges;

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

  /// No description provided for @phoneVerifiedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Phone number verified successfully'**
  String get phoneVerifiedSuccess;

  /// No description provided for @confirmPhoneUpdateHint.
  ///
  /// In en, this message translates to:
  /// **'Tap confirm to update the phone number in your account'**
  String get confirmPhoneUpdateHint;

  /// No description provided for @confirmChangePhone.
  ///
  /// In en, this message translates to:
  /// **'Confirm change'**
  String get confirmChangePhone;

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

  /// No description provided for @rateQuestion.
  ///
  /// In en, this message translates to:
  /// **'How would you rate your experience with us?'**
  String get rateQuestion;

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

  /// No description provided for @showAll.
  ///
  /// In en, this message translates to:
  /// **'Show All'**
  String get showAll;

  /// No description provided for @emptyCartTitle.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty'**
  String get emptyCartTitle;

  /// No description provided for @emptyCartBody.
  ///
  /// In en, this message translates to:
  /// **'Browse categories and add products here'**
  String get emptyCartBody;

  /// No description provided for @brandsSection.
  ///
  /// In en, this message translates to:
  /// **'Brands'**
  String get brandsSection;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @sizePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Size — —'**
  String get sizePlaceholder;

  /// No description provided for @colorPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Color — —'**
  String get colorPlaceholder;

  /// No description provided for @currencySYP.
  ///
  /// In en, this message translates to:
  /// **'SYP'**
  String get currencySYP;

  /// No description provided for @setNewPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get setNewPasswordTitle;

  /// No description provided for @setNewPasswordBody.
  ///
  /// In en, this message translates to:
  /// **'Enter your new account password'**
  String get setNewPasswordBody;

  /// No description provided for @confirmPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Does not match the new password'**
  String get confirmPasswordMismatch;

  /// No description provided for @updatePasswordButton.
  ///
  /// In en, this message translates to:
  /// **'Update Password'**
  String get updatePasswordButton;

  /// No description provided for @verifyCodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify Code'**
  String get verifyCodeTitle;

  /// No description provided for @recoverPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Recover Password'**
  String get recoverPasswordTitle;

  /// No description provided for @changePhoneOtpTitle.
  ///
  /// In en, this message translates to:
  /// **'Change Phone Number'**
  String get changePhoneOtpTitle;

  /// No description provided for @enterCodeHintSnack.
  ///
  /// In en, this message translates to:
  /// **'Enter the 4-6 digit code'**
  String get enterCodeHintSnack;

  /// No description provided for @otpCodeHintSignUp.
  ///
  /// In en, this message translates to:
  /// **'Enter the verification code sent to you on WhatsApp'**
  String get otpCodeHintSignUp;

  /// No description provided for @otpCodeHintOther.
  ///
  /// In en, this message translates to:
  /// **'Enter the code sent to you via WhatsApp'**
  String get otpCodeHintOther;

  /// No description provided for @otpCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Verification code'**
  String get otpCodeLabel;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @contactTitle.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactTitle;

  /// No description provided for @contactWelcome.
  ///
  /// In en, this message translates to:
  /// **'We\'re happy to hear from you'**
  String get contactWelcome;

  /// No description provided for @contactChannels.
  ///
  /// In en, this message translates to:
  /// **'You can reach us through the following channels or send a message'**
  String get contactChannels;

  /// No description provided for @contactPhoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get contactPhoneTitle;

  /// No description provided for @contactEmailTitle.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get contactEmailTitle;

  /// No description provided for @contactHoursTitle.
  ///
  /// In en, this message translates to:
  /// **'Working Hours'**
  String get contactHoursTitle;

  /// No description provided for @contactHoursValue.
  ///
  /// In en, this message translates to:
  /// **'Sat - Thu: 9 AM - 9 PM'**
  String get contactHoursValue;

  /// No description provided for @sendMessage.
  ///
  /// In en, this message translates to:
  /// **'Send a message'**
  String get sendMessage;

  /// No description provided for @subjectLabel.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get subjectLabel;

  /// No description provided for @messageLabel.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get messageLabel;

  /// No description provided for @continueToHomeTest.
  ///
  /// In en, this message translates to:
  /// **'Continue as a guest'**
  String get continueToHomeTest;

  /// No description provided for @otpSentToPhone.
  ///
  /// In en, this message translates to:
  /// **'Verification code sent to {phone}'**
  String otpSentToPhone(String phone);

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search for products, categories...'**
  String get searchHint;

  /// No description provided for @profilePhoto.
  ///
  /// In en, this message translates to:
  /// **'Profile Photo'**
  String get profilePhoto;

  /// No description provided for @enterFullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter full name'**
  String get enterFullNameHint;

  /// No description provided for @enterEmailShort.
  ///
  /// In en, this message translates to:
  /// **'Enter email'**
  String get enterEmailShort;

  /// No description provided for @enterAddressShort.
  ///
  /// In en, this message translates to:
  /// **'Enter address'**
  String get enterAddressShort;

  /// No description provided for @cityAreaStreet.
  ///
  /// In en, this message translates to:
  /// **'City, area, street'**
  String get cityAreaStreet;

  /// No description provided for @enterPostalCodeShort.
  ///
  /// In en, this message translates to:
  /// **'Enter postal code'**
  String get enterPostalCodeShort;

  /// No description provided for @saveAndContinue.
  ///
  /// In en, this message translates to:
  /// **'Save and continue'**
  String get saveAndContinue;

  /// No description provided for @associationLinkRequestTitle.
  ///
  /// In en, this message translates to:
  /// **'Association Linking Request'**
  String get associationLinkRequestTitle;

  /// No description provided for @associationLinkRequestHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your personal and membership details as you know them to request linking your account with the association.'**
  String get associationLinkRequestHint;

  /// No description provided for @associationLinkPersonalSection.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get associationLinkPersonalSection;

  /// No description provided for @associationLinkContactSection.
  ///
  /// In en, this message translates to:
  /// **'Contact and Address'**
  String get associationLinkContactSection;

  /// No description provided for @associationLinkMembershipSection.
  ///
  /// In en, this message translates to:
  /// **'Membership Information'**
  String get associationLinkMembershipSection;

  /// No description provided for @associationLinkAttachmentsSection.
  ///
  /// In en, this message translates to:
  /// **'Documents and Attachments'**
  String get associationLinkAttachmentsSection;

  /// No description provided for @associationLinkFirstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get associationLinkFirstName;

  /// No description provided for @associationLinkKunya.
  ///
  /// In en, this message translates to:
  /// **'Family / Kunya Name'**
  String get associationLinkKunya;

  /// No description provided for @associationLinkFatherName.
  ///
  /// In en, this message translates to:
  /// **'Father\'s Name'**
  String get associationLinkFatherName;

  /// No description provided for @associationLinkMotherName.
  ///
  /// In en, this message translates to:
  /// **'Mother\'s Name'**
  String get associationLinkMotherName;

  /// No description provided for @associationLinkGovernorate.
  ///
  /// In en, this message translates to:
  /// **'Governorate'**
  String get associationLinkGovernorate;

  /// No description provided for @associationLinkCity.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get associationLinkCity;

  /// No description provided for @associationLinkTown.
  ///
  /// In en, this message translates to:
  /// **'Town'**
  String get associationLinkTown;

  /// No description provided for @associationLinkVillage.
  ///
  /// In en, this message translates to:
  /// **'Village'**
  String get associationLinkVillage;

  /// No description provided for @associationLinkStreet.
  ///
  /// In en, this message translates to:
  /// **'Street'**
  String get associationLinkStreet;

  /// No description provided for @associationLinkBuilding.
  ///
  /// In en, this message translates to:
  /// **'Building'**
  String get associationLinkBuilding;

  /// No description provided for @associationLinkPermanentAddress.
  ///
  /// In en, this message translates to:
  /// **'Permanent Address'**
  String get associationLinkPermanentAddress;

  /// No description provided for @associationLinkMobile.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get associationLinkMobile;

  /// No description provided for @associationLinkWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp Number'**
  String get associationLinkWhatsApp;

  /// No description provided for @associationLinkEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get associationLinkEmail;

  /// No description provided for @associationLinkMembershipNumber.
  ///
  /// In en, this message translates to:
  /// **'Membership Number'**
  String get associationLinkMembershipNumber;

  /// No description provided for @associationLinkPriorityNumber.
  ///
  /// In en, this message translates to:
  /// **'Priority Number'**
  String get associationLinkPriorityNumber;

  /// No description provided for @associationLinkProjectName.
  ///
  /// In en, this message translates to:
  /// **'Project Name'**
  String get associationLinkProjectName;

  /// No description provided for @associationLinkHousingUnit.
  ///
  /// In en, this message translates to:
  /// **'Assigned Housing Unit'**
  String get associationLinkHousingUnit;

  /// No description provided for @associationLinkTotalPayments.
  ///
  /// In en, this message translates to:
  /// **'Total Payments'**
  String get associationLinkTotalPayments;

  /// No description provided for @associationLinkAttachmentDescription.
  ///
  /// In en, this message translates to:
  /// **'Document Name / Description'**
  String get associationLinkAttachmentDescription;

  /// No description provided for @associationLinkEnterFirstName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get associationLinkEnterFirstName;

  /// No description provided for @associationLinkUnsupportedFileType.
  ///
  /// In en, this message translates to:
  /// **'Unsupported file type'**
  String get associationLinkUnsupportedFileType;

  /// No description provided for @associationLinkFileTooLarge.
  ///
  /// In en, this message translates to:
  /// **'File is too large'**
  String get associationLinkFileTooLarge;

  /// No description provided for @associationLinkAddAttachment.
  ///
  /// In en, this message translates to:
  /// **'Add File'**
  String get associationLinkAddAttachment;

  /// No description provided for @associationLinkDeleteAttachment.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get associationLinkDeleteAttachment;

  /// No description provided for @associationLinkSaveDraft.
  ///
  /// In en, this message translates to:
  /// **'Save Draft'**
  String get associationLinkSaveDraft;

  /// No description provided for @associationLinkDraftSaved.
  ///
  /// In en, this message translates to:
  /// **'Draft saved'**
  String get associationLinkDraftSaved;

  /// No description provided for @associationLinkResubmit.
  ///
  /// In en, this message translates to:
  /// **'Resubmit'**
  String get associationLinkResubmit;

  /// No description provided for @associationLinkSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit Request'**
  String get associationLinkSubmit;

  /// No description provided for @associationLinkRequestSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Your request was submitted successfully'**
  String get associationLinkRequestSubmitted;

  /// No description provided for @associationLinkPhoneMustMatchAccount.
  ///
  /// In en, this message translates to:
  /// **'The phone number must match your account number'**
  String get associationLinkPhoneMustMatchAccount;

  /// No description provided for @associationLinkIncompleteWarning.
  ///
  /// In en, this message translates to:
  /// **'Some fields are incomplete. You can continue with the minimum required data.'**
  String get associationLinkIncompleteWarning;

  /// No description provided for @associationLinkSubmittedLocked.
  ///
  /// In en, this message translates to:
  /// **'The request was submitted and is under review. It can no longer be edited.'**
  String get associationLinkSubmittedLocked;

  /// No description provided for @associationLinkNoAttachments.
  ///
  /// In en, this message translates to:
  /// **'No attachments added yet. Supporting documents are recommended.'**
  String get associationLinkNoAttachments;

  /// No description provided for @verifyPhoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify phone number'**
  String get verifyPhoneTitle;

  /// No description provided for @codeSentViaWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'Verification code sent to {phone} via WhatsApp'**
  String codeSentViaWhatsApp(String phone);

  /// No description provided for @otpPhoneHintSignUp.
  ///
  /// In en, this message translates to:
  /// **'Enter phone number to receive verification code via WhatsApp'**
  String get otpPhoneHintSignUp;

  /// No description provided for @otpPhoneHintForgot.
  ///
  /// In en, this message translates to:
  /// **'Enter the phone number associated with your account to receive the verification code via WhatsApp'**
  String get otpPhoneHintForgot;

  /// No description provided for @otpPhoneHintChange.
  ///
  /// In en, this message translates to:
  /// **'Enter your new phone number to receive the verification code via WhatsApp'**
  String get otpPhoneHintChange;

  /// No description provided for @introDesc1.
  ///
  /// In en, this message translates to:
  /// **'Kalivra is your one-stop platform for building materials and decor. Browse brands, products, and offers, and order what you need with ease.'**
  String get introDesc1;

  /// No description provided for @introDesc2.
  ///
  /// In en, this message translates to:
  /// **'A wide range of paints, ceramics, iron, sanitary and electrical supplies. Regular offers, fast delivery, and 24/7 customer service.'**
  String get introDesc2;

  /// No description provided for @introDesc3.
  ///
  /// In en, this message translates to:
  /// **'Register now for a smooth shopping experience. Track orders, save favorites, and pay securely. Welcome to the Kalivra family.'**
  String get introDesc3;

  /// No description provided for @closeTooltip.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get closeTooltip;

  /// No description provided for @orderDetails.
  ///
  /// In en, this message translates to:
  /// **'Order details'**
  String get orderDetails;

  /// No description provided for @shippingAddress.
  ///
  /// In en, this message translates to:
  /// **'Shipping address'**
  String get shippingAddress;

  /// No description provided for @noBrands.
  ///
  /// In en, this message translates to:
  /// **'No brands yet'**
  String get noBrands;

  /// No description provided for @adsTitle.
  ///
  /// In en, this message translates to:
  /// **'Ads'**
  String get adsTitle;

  /// No description provided for @noAds.
  ///
  /// In en, this message translates to:
  /// **'No ads'**
  String get noAds;

  /// No description provided for @loginPromptNotifications.
  ///
  /// In en, this message translates to:
  /// **'Sign in or create an account to receive order and offer notifications.'**
  String get loginPromptNotifications;

  /// No description provided for @privacyPolicyContent.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy\n\nLast updated: January 2024\n\nAt Kalivra we respect your privacy and are committed to protecting your personal data. This policy explains how we collect, use, and share your information when you use our app.\n\n1. Information we collect\nWe collect information you provide when registering or placing orders, such as name, email, phone number, and address. We also automatically collect some technical data to improve app performance.\n\n2. Use of information\nWe use your information to process orders, communicate with you, improve our services, and send offers that may interest you (with your consent).\n\n3. Data protection\nWe apply appropriate security measures to protect your data from unauthorized access or disclosure.\n\n4. Sharing information\nWe do not sell your personal data. We may share information with service partners (e.g. shipping and payment) only as necessary to fulfill your order.\n\n5. Your rights\nYou can request access, correction, or deletion of your data by contacting us.\n\nFor any inquiry: support@kalivra.com'**
  String get privacyPolicyContent;

  /// No description provided for @allCategories.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allCategories;

  /// No description provided for @associationPersonalProfileButton.
  ///
  /// In en, this message translates to:
  /// **'Association Personal Profile'**
  String get associationPersonalProfileButton;

  /// No description provided for @associationMemberProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Association Member Profile'**
  String get associationMemberProfileTitle;

  /// No description provided for @associationMemberProfileEmpty.
  ///
  /// In en, this message translates to:
  /// **'No linked association profile is available yet. Submit a linking request to connect your account with the association.'**
  String get associationMemberProfileEmpty;

  /// No description provided for @associationMemberProfileLinkRequest.
  ///
  /// In en, this message translates to:
  /// **'Submit Linking Request'**
  String get associationMemberProfileLinkRequest;

  /// No description provided for @associationMemberCurrentAddress.
  ///
  /// In en, this message translates to:
  /// **'Current Address'**
  String get associationMemberCurrentAddress;

  /// No description provided for @associationMemberMembershipStatus.
  ///
  /// In en, this message translates to:
  /// **'Membership Status'**
  String get associationMemberMembershipStatus;

  /// No description provided for @associationMemberPaymentCommitment.
  ///
  /// In en, this message translates to:
  /// **'Payment Commitment'**
  String get associationMemberPaymentCommitment;

  /// No description provided for @associationMemberPaymentsByYear.
  ///
  /// In en, this message translates to:
  /// **'Payments by Year'**
  String get associationMemberPaymentsByYear;

  /// No description provided for @associationMemberFinancialSummary.
  ///
  /// In en, this message translates to:
  /// **'Financial Summary'**
  String get associationMemberFinancialSummary;

  /// No description provided for @associationMemberTotalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get associationMemberTotalAmount;

  /// No description provided for @associationMemberPaidAmount.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get associationMemberPaidAmount;

  /// No description provided for @associationMemberRemainingInstallments.
  ///
  /// In en, this message translates to:
  /// **'Remaining Installments'**
  String get associationMemberRemainingInstallments;

  /// No description provided for @associationMemberInstallments.
  ///
  /// In en, this message translates to:
  /// **'Installments'**
  String get associationMemberInstallments;

  /// No description provided for @associationMemberOtherPayments.
  ///
  /// In en, this message translates to:
  /// **'Other Payments'**
  String get associationMemberOtherPayments;

  /// No description provided for @associationMemberNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get associationMemberNotifications;

  /// No description provided for @associationMemberEvents.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get associationMemberEvents;

  /// No description provided for @associationMemberMeasurements.
  ///
  /// In en, this message translates to:
  /// **'Measurements'**
  String get associationMemberMeasurements;

  /// No description provided for @associationMemberAttachments.
  ///
  /// In en, this message translates to:
  /// **'Attachments'**
  String get associationMemberAttachments;

  /// No description provided for @associationMemberAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get associationMemberAmount;

  /// No description provided for @associationMemberDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get associationMemberDate;

  /// No description provided for @associationMemberStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get associationMemberStatus;

  /// No description provided for @associationMemberNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get associationMemberNotes;

  /// No description provided for @associationMemberMethod.
  ///
  /// In en, this message translates to:
  /// **'Method'**
  String get associationMemberMethod;

  /// No description provided for @associationMemberBank.
  ///
  /// In en, this message translates to:
  /// **'Bank'**
  String get associationMemberBank;

  /// No description provided for @associationMemberReceipt.
  ///
  /// In en, this message translates to:
  /// **'Receipt'**
  String get associationMemberReceipt;

  /// No description provided for @associationMemberType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get associationMemberType;

  /// No description provided for @associationMemberTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get associationMemberTitle;

  /// No description provided for @associationMemberRead.
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get associationMemberRead;

  /// No description provided for @associationMemberEvent.
  ///
  /// In en, this message translates to:
  /// **'Event'**
  String get associationMemberEvent;

  /// No description provided for @associationMemberLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get associationMemberLocation;

  /// No description provided for @associationMemberValue.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get associationMemberValue;

  /// No description provided for @associationMemberPayment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get associationMemberPayment;

  /// No description provided for @associationMemberUnread.
  ///
  /// In en, this message translates to:
  /// **'Unread'**
  String get associationMemberUnread;

  /// No description provided for @associationMemberReadStatus.
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get associationMemberReadStatus;

  /// No description provided for @associationMemberNoData.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get associationMemberNoData;

  /// No description provided for @associationMemberLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load association profile'**
  String get associationMemberLoadFailed;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @incorrectPassword.
  ///
  /// In en, this message translates to:
  /// **'Incorrect password. Please try again.'**
  String get incorrectPassword;

  /// No description provided for @accountNotFound.
  ///
  /// In en, this message translates to:
  /// **'Phone number was not found, Please check the phone number or create a new account.'**
  String get accountNotFound;

  /// No description provided for @signOutConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out?'**
  String get signOutConfirmation;

  /// No description provided for @areYouSureYouWantToSignIn.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign in?'**
  String get areYouSureYouWantToSignIn;

  /// No description provided for @exitAppConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Do you want to exit the app?'**
  String get exitAppConfirmation;

  /// No description provided for @exitAppTitle.
  ///
  /// In en, this message translates to:
  /// **'Exit app'**
  String get exitAppTitle;

  /// No description provided for @associationLinkDraftsTitle.
  ///
  /// In en, this message translates to:
  /// **'My Drafts'**
  String get associationLinkDraftsTitle;

  /// No description provided for @associationLinkNoDrafts.
  ///
  /// In en, this message translates to:
  /// **'You have no saved drafts yet.'**
  String get associationLinkNoDrafts;

  /// No description provided for @associationLinkNewDraft.
  ///
  /// In en, this message translates to:
  /// **'New Request'**
  String get associationLinkNewDraft;

  /// No description provided for @associationLinkDraftDeleted.
  ///
  /// In en, this message translates to:
  /// **'Draft deleted.'**
  String get associationLinkDraftDeleted;

  /// No description provided for @associationLinkDeleteDraftTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Draft'**
  String get associationLinkDeleteDraftTitle;

  /// No description provided for @associationLinkDeleteDraftConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this draft? This action cannot be undone.'**
  String get associationLinkDeleteDraftConfirm;

  /// No description provided for @associationLinkNoData.
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get associationLinkNoData;

  /// No description provided for @associationSubmittedRequestsTitle.
  ///
  /// In en, this message translates to:
  /// **'Submitted Requests'**
  String get associationSubmittedRequestsTitle;

  /// No description provided for @associationNoSubmittedRequests.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t submitted any requests yet.'**
  String get associationNoSubmittedRequests;

  /// No description provided for @associationRequestNumber.
  ///
  /// In en, this message translates to:
  /// **'Request'**
  String get associationRequestNumber;

  /// No description provided for @associationRequestCreatedAt.
  ///
  /// In en, this message translates to:
  /// **'Submitted'**
  String get associationRequestCreatedAt;

  /// No description provided for @associationRequestApprovedAt.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get associationRequestApprovedAt;

  /// No description provided for @associationRequestViewDocument.
  ///
  /// In en, this message translates to:
  /// **'View Document'**
  String get associationRequestViewDocument;

  /// No description provided for @associationRequestStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get associationRequestStatusPending;

  /// No description provided for @associationRequestStatusApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get associationRequestStatusApproved;

  /// No description provided for @associationRequestStatusRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get associationRequestStatusRejected;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @draftsScreen.
  ///
  /// In en, this message translates to:
  /// **'Drafts Screen'**
  String get draftsScreen;

  /// No description provided for @linkRequestsScreen.
  ///
  /// In en, this message translates to:
  /// **'Joining requests'**
  String get linkRequestsScreen;
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
