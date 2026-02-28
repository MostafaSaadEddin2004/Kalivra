// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get helloWorld => 'Hello World!';

  @override
  String get navHome => 'Home';

  @override
  String get navCategories => 'Categories';

  @override
  String get navNotifications => 'Notifications';

  @override
  String get navSearch => 'Search';

  @override
  String get drawerMyAccount => 'My Account';

  @override
  String get drawerMyOrders => 'My Orders';

  @override
  String get drawerFavorites => 'Favorites';

  @override
  String get drawerSettings => 'Settings';

  @override
  String get drawerContactUs => 'Contact Us';

  @override
  String get drawerAboutApp => 'About';

  @override
  String get drawerPrivacyPolicy => 'Privacy Policy';

  @override
  String get drawerShare => 'Share';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsAccountSecurity => 'Account & Security';

  @override
  String get settingsChangePassword => 'Change Password';

  @override
  String get settingsChangePhone => 'Change Phone Number';

  @override
  String get appearanceTitle => 'Appearance';

  @override
  String get themeDark => 'Dark Mode';

  @override
  String get themeDarkSubtitle => 'Dark mode';

  @override
  String get themeLight => 'Light Mode';

  @override
  String get themeLightSubtitle => 'Light mode';

  @override
  String get themeSystem => 'System Default';

  @override
  String get themeSystemSubtitle => 'Follow device setting';

  @override
  String get languageTitle => 'Language';

  @override
  String get languageArabic => 'Arabic';

  @override
  String get languageArabicSubtitle => 'Arabic';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageEnglishSubtitle => 'English';

  @override
  String get languageFollowSystem => 'Follow system';

  @override
  String get languageFollowSystemSubtitle => 'Use device language';

  @override
  String get ok => 'OK';

  @override
  String get error => 'Error';

  @override
  String get version => 'Version 1.0.0';

  @override
  String get menu => 'Menu';

  @override
  String get cart => 'Cart';

  @override
  String get back => 'Back';

  @override
  String get loginRequiredForCart =>
      'Please sign in to add products to the cart';

  @override
  String addToCartSuccess(String productName) {
    return 'Added \"$productName\" to cart';
  }

  @override
  String get continueShopping => 'Continue Shopping';

  @override
  String get emptyCart => 'Empty Cart';

  @override
  String get priceDetails => 'Price Details';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get discount => 'Discount';

  @override
  String get tax => 'Tax';

  @override
  String get total => 'Total';

  @override
  String get deliveryCost => 'Delivery';

  @override
  String get productsTotal => 'Products Total';

  @override
  String get amountDue => 'Amount Due';

  @override
  String get proceed => 'Proceed';

  @override
  String get productDetails => 'Product Details';

  @override
  String get invalidProductId => 'Invalid product ID';

  @override
  String addToWishlistSuccess(String productName) {
    return 'Added \"$productName\" to favorites';
  }

  @override
  String get addToWishlistFailed => 'Failed to add product to favorites';

  @override
  String get unit => 'Unit';

  @override
  String get maxOrderLimit => 'Max order limit';

  @override
  String get addToWishlist => 'Add to Favorites';

  @override
  String get addToCart => 'Add to Cart';

  @override
  String get notificationsWelcomeTitle => 'Welcome to Kalivra';

  @override
  String get notificationsWelcomeBody =>
      'Discover building and decor products at competitive prices.';

  @override
  String get now => 'Now';

  @override
  String get notificationsPaintOfferTitle => 'Special offer on paints';

  @override
  String get notificationsPaintOfferBody =>
      'Up to 20% off on paint collection this week.';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get notificationsOrderProcessingTitle =>
      'Your order is being processed';

  @override
  String get notificationsOrderProcessingBody =>
      'We have received your order. Shipping within 24 hours.';

  @override
  String get twoDaysAgo => 'Two days ago';

  @override
  String get loginRequiredForNotifications => 'Sign in to view notifications';

  @override
  String get notificationsLoginPrompt =>
      'Sign in or create an account to receive order and offer notifications.';

  @override
  String get signIn => 'Sign In';

  @override
  String get all => 'All';

  @override
  String get loadCategoriesFailed => 'Failed to load categories or products';

  @override
  String get allProducts => 'All Products';

  @override
  String get product => 'Product';

  @override
  String get noProductsInCategory => 'No products in this category';

  @override
  String get offers => 'Offers';

  @override
  String get loadOffersFailed => 'Failed to load offers';

  @override
  String get noOffers => 'No offers at the moment';

  @override
  String get allSaleProducts => 'All Sale Products';

  @override
  String get products => 'Products';

  @override
  String get loadProductsFailed => 'Failed to load products';

  @override
  String get noProducts => 'No products';

  @override
  String get branchCount => 'Branches';

  @override
  String get locations => 'Locations';

  @override
  String get phone => 'Phone';

  @override
  String get website => 'Website';

  @override
  String get noProductsForBrand => 'No products for this brand at the moment';

  @override
  String get noOffersForBrand => 'No offers for this brand at the moment';

  @override
  String get orderSummary => 'Order Summary';

  @override
  String quantityLabel(int count) {
    return 'Quantity: $count';
  }

  @override
  String get shipping => 'Shipping';

  @override
  String get checkoutStepAddress => 'Address';

  @override
  String get checkoutStepShipping => 'Shipping';

  @override
  String get checkoutStepPayment => 'Payment';

  @override
  String get checkoutStepComplete => 'Complete Order';

  @override
  String get completeStepData =>
      'Please complete the required fields in this step';

  @override
  String get placeOrderFailed => 'Failed to place order. Please try again.';

  @override
  String get myAccount => 'My Account';

  @override
  String get loginToViewProfile => 'Sign in to view your profile';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get accountInfo => 'Account Information';

  @override
  String get name => 'Name';

  @override
  String get email => 'Email';

  @override
  String get fullName => 'Full Name';

  @override
  String get mobileNumber => 'Phone Number';

  @override
  String get joinDate => 'Join Date';

  @override
  String get address => 'Address';

  @override
  String get mainAddress => 'Main Address';

  @override
  String get postalCode => 'Postal Code';

  @override
  String get stats => 'Statistics';

  @override
  String get ordersCount => 'Orders';

  @override
  String get pendingOrders => 'Pending Orders';

  @override
  String memberSince(int year) {
    return 'Member since $year';
  }

  @override
  String get referralCode => 'Referral Code';

  @override
  String get referralCodeHint =>
      'Share this code or scan with friends to get a discount on sign-up. You benefit too.';

  @override
  String customerSince(int year) {
    return 'Customer since $year';
  }

  @override
  String get myOrders => 'My Orders';

  @override
  String get loadOrdersFailed => 'Failed to load orders';

  @override
  String get noOrders => 'No orders yet';

  @override
  String get ordersPrompt => 'Your orders will appear here';

  @override
  String get viewDetails => 'View Details';

  @override
  String get statusComplete => 'Complete';

  @override
  String get statusShipping => 'Shipping';

  @override
  String get favorites => 'Favorites';

  @override
  String get loadFavoritesFailed => 'Failed to load favorites';

  @override
  String get favoritesEmpty => 'Your favorites list is empty';

  @override
  String get favoritesPrompt =>
      'Add products to favorites using the heart button on the product page';

  @override
  String get shopNow => 'Shop Now';

  @override
  String get addressSaved => 'Address saved';

  @override
  String get saveAddress => 'Save Address';

  @override
  String get paymentMethod => 'Payment Method';

  @override
  String get cashOnDelivery => 'Cash on Delivery';

  @override
  String get cashOnDeliverySubtitle =>
      'Pay in cash when you receive your order';

  @override
  String get onlinePayment => 'Online Payment';

  @override
  String get onlinePaymentSubtitle => 'ShamCash, Syriatel Cash, MTN Cash';

  @override
  String get selectPaymentMethod => 'Select online payment method';

  @override
  String get walletDetails => 'Wallet Details';

  @override
  String get required => 'Required';

  @override
  String get invalidPhone => 'Invalid phone number';

  @override
  String get walletPhoneLabel => 'Wallet phone number *';

  @override
  String get walletNameLabel => 'Name as in wallet (optional)';

  @override
  String get walletNameHint => 'For payment verification';

  @override
  String get paymentShamcash => 'ShamCash';

  @override
  String get paymentSyriatel => 'Syriatel Cash';

  @override
  String get paymentMtn => 'MTN Cash';

  @override
  String get paymentShamcashDesc =>
      'Syrian e-wallet for transfer and payment via app';

  @override
  String get paymentSyriatelDesc =>
      'Syriatel e-payment platform for transfer and payment';

  @override
  String get paymentMtnDesc => 'MTN Syria mobile wallet service';

  @override
  String get shippingMethod => 'Shipping Method';

  @override
  String get standardDelivery => 'Standard delivery';

  @override
  String get standardDeliveryDesc => '5-7 business days';

  @override
  String get fastDelivery => 'Fast delivery';

  @override
  String get fastDeliveryDesc => '2-3 business days';

  @override
  String get sameDayDelivery => 'Same day';

  @override
  String get sameDayDeliveryDesc => 'Order before 12 noon';

  @override
  String get preferredDeliveryDate => 'Preferred delivery date';

  @override
  String get chooseDate => 'Choose date';

  @override
  String get deliveryNotes => 'Delivery notes (optional)';

  @override
  String get deliveryNotesHint => 'e.g. Leave at door, call on arrival...';

  @override
  String get firstName => 'First Name';

  @override
  String get lastName => 'Last Name';

  @override
  String get firstNameRequired => 'First Name *';

  @override
  String get lastNameRequired => 'Last Name *';

  @override
  String get emailRequired => 'Email *';

  @override
  String get emailHint => 'example@email.com';

  @override
  String get companyName => 'Company Name';

  @override
  String get phoneRequired => 'Phone *';

  @override
  String get streetRequired => 'Street *';

  @override
  String get streetHint => 'Street address';

  @override
  String get postalCodeRequired => 'Postal Code *';

  @override
  String get stateRequired => 'State *';

  @override
  String get cityRequired => 'City *';

  @override
  String get invalidEmail => 'Please enter a valid email address';

  @override
  String get noOrder => 'No order';

  @override
  String get errorMissingData => 'Error: Data was not passed';

  @override
  String get productUnavailable => 'Product unavailable';

  @override
  String get brandUnavailable => 'Brand unavailable';

  @override
  String get adUnavailable => 'Ad unavailable';

  @override
  String get login => 'Sign In';

  @override
  String get loginFailed => 'Sign in failed';

  @override
  String get loginTitle => 'Sign In';

  @override
  String get loginHint =>
      'Enter your phone number and password to access your account';

  @override
  String get enterPhone => 'Enter phone number';

  @override
  String get invalidPhoneShort => 'Invalid number';

  @override
  String get phoneLabel => 'Phone Number';

  @override
  String get enterPassword => 'Enter password';

  @override
  String get passwordLabel => 'Password';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get noAccount => 'Don\'t have an account? ';

  @override
  String get registerNow => 'Register now';

  @override
  String get signUp => 'Create Account';

  @override
  String get signUpHint =>
      'Enter your details to register and verify your phone via WhatsApp';

  @override
  String get enterName => 'Enter your name';

  @override
  String get passwordMinLength => 'Password must be at least 6 characters';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get confirmPasswordRequired => 'Enter confirmation password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get continueVerification => 'Continue to Verify';

  @override
  String get haveAccount => 'Already have an account? ';

  @override
  String get unexpectedError => 'An unexpected error occurred';

  @override
  String get inviteCodeQuestion => 'Have an invite code from a friend?';

  @override
  String get inviteCodeLabel => 'Invite Code';

  @override
  String get inviteCodeHint => 'Enter code or tap icon to scan or choose image';

  @override
  String get codeCopied => 'Code copied';

  @override
  String get changePasswordTitle => 'Change Password';

  @override
  String get passwordUpdated => 'Password updated';

  @override
  String get currentPassword => 'Current Password';

  @override
  String get newPassword => 'New Password';

  @override
  String get newPasswordConfirm => 'Confirm New Password';

  @override
  String get passwordUpdatedSuccess => 'Password updated successfully';

  @override
  String get completeProfileTitle => 'Complete Your Profile';

  @override
  String get addressOrLocation => 'Address / Location';

  @override
  String get editProfileTitle => 'Edit Profile';

  @override
  String get profileSaved => 'Changes saved';

  @override
  String get personalInfo => 'Personal Information';

  @override
  String get newPhoneSuccess => 'Phone number changed successfully';

  @override
  String get changePhoneTitle => 'Change Phone Number';

  @override
  String get sendCodeViaWhatsApp => 'Send code via WhatsApp';

  @override
  String get enterPhoneNumber => 'Enter phone number';

  @override
  String get enterCode4To6 => 'Enter the 4-6 digit code';

  @override
  String get rateTitle => 'Rate';

  @override
  String get submitRating => 'Submit Rating';

  @override
  String get thanksForRating => 'Thanks for your rating';

  @override
  String get size => 'Size';

  @override
  String get color => 'Color';

  @override
  String get dash => '—';

  @override
  String get confirmOrder => 'Confirm Order';

  @override
  String get introTitle1 => 'What is Kalivra?';

  @override
  String get introTitle2 => 'What we offer';

  @override
  String get introTitle3 => 'Join us';

  @override
  String get showAll => 'Show All';

  @override
  String get emptyCartTitle => 'Your cart is empty';

  @override
  String get emptyCartBody => 'Browse categories and add products here';

  @override
  String get brandsSection => 'Brands';

  @override
  String get send => 'Send';

  @override
  String get remove => 'Remove';

  @override
  String get sizePlaceholder => 'Size — —';

  @override
  String get colorPlaceholder => 'Color — —';

  @override
  String get currencySYP => 'SYP';

  @override
  String get setNewPasswordTitle => 'New Password';

  @override
  String get setNewPasswordBody => 'Enter your new account password';

  @override
  String get confirmPasswordMismatch => 'Does not match the new password';

  @override
  String get updatePasswordButton => 'Update Password';

  @override
  String get verifyCodeTitle => 'Verify Code';

  @override
  String get recoverPasswordTitle => 'Recover Password';

  @override
  String get changePhoneOtpTitle => 'Change Phone Number';

  @override
  String get enterCodeHintSnack => 'Enter the 4-6 digit code';

  @override
  String get otpCodeHintSignUp =>
      'Enter the verification code sent to you on WhatsApp';

  @override
  String get otpCodeHintOther => 'Enter the code sent to you via WhatsApp';

  @override
  String get otpCodeLabel => 'Verification code';

  @override
  String get verify => 'Verify';

  @override
  String get contactTitle => 'Contact Us';

  @override
  String get contactWelcome => 'We\'re happy to hear from you';

  @override
  String get contactChannels =>
      'You can reach us through the following channels or send a message';

  @override
  String get contactPhoneTitle => 'Phone';

  @override
  String get contactEmailTitle => 'Email';

  @override
  String get contactHoursTitle => 'Working Hours';

  @override
  String get contactHoursValue => 'Sat - Thu: 9 AM - 9 PM';

  @override
  String get sendMessage => 'Send a message';

  @override
  String get subjectLabel => 'Subject';

  @override
  String get messageLabel => 'Message';

  @override
  String get continueToHomeTest => 'Continue to Home (Test)';

  @override
  String otpSentToPhone(String phone) {
    return 'Verification code sent to $phone';
  }
}
