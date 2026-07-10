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
  String get drawerMyAccount => 'Profile';

  @override
  String get drawerMyOrders => 'My Orders';

  @override
  String get drawerFavorites => 'Favorites';

  @override
  String get associationLinkRequest => 'Association Link Request';

  @override
  String get drawerSettings => 'Settings';

  @override
  String get drawerContactUs => 'Contact Us';

  @override
  String get drawerAboutApp => 'About';

  @override
  String get drawerPrivacyPolicy => 'Privacy Policy';

  @override
  String get drawerTermsConditions => 'Terms and Conditions';

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
  String get settingsChangePhone => 'Reset WhatsApp Number';

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
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get error => 'Error';

  @override
  String get version => 'Version 1.0.0';

  @override
  String get aboutAppDescription =>
      'Kalivra gives you an easy and secure shopping experience for building and finishing products. Browse categories, order what you need, and track your orders in one place.';

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
  String get loginRequiredForCartView => 'Sign in to view your cart';

  @override
  String get cartLoginPrompt =>
      'Sign in or create an account to view and manage your cart.';

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
  String get productOrderInfo => 'Order information';

  @override
  String get unitPiece => 'Piece';

  @override
  String maxOrderLimitValue(int count) {
    return 'Up to $count per order';
  }

  @override
  String get addToWishlist => 'Add to Favorites';

  @override
  String get removeFromWishlist => 'Remove from Favorites';

  @override
  String removeFromWishlistSuccess(String productName) {
    return 'Removed \"$productName\" from favorites';
  }

  @override
  String get removeFromWishlistFailed =>
      'Failed to remove product from favorites';

  @override
  String get addToCart => 'Add to Cart';

  @override
  String get productSku => 'SKU';

  @override
  String get productDescription => 'Description';

  @override
  String get productNew => 'New';

  @override
  String get productFeatured => 'Featured';

  @override
  String get productOnSale => 'On Sale';

  @override
  String get productAvailability => 'Availability';

  @override
  String get productAvailable => 'In stock';

  @override
  String get productOutOfStock => 'Out of stock';

  @override
  String get productRating => 'Rating';

  @override
  String productRatingSummary(String rating, int count) {
    return '$rating / 5 ($count)';
  }

  @override
  String get productReviews => 'Reviews';

  @override
  String productReviewsCount(int count) {
    return '$count reviews';
  }

  @override
  String get productMinPriceLabel => 'Starting from';

  @override
  String get productInfo => 'Product information';

  @override
  String get productUrlKey => 'Product link';

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
  String get noNotifications => 'No notifications yet';

  @override
  String get notificationsEmptyPrompt =>
      'New updates, order alerts, and offers will appear here.';

  @override
  String get notificationRead => 'Read';

  @override
  String get notificationUnread => 'Unread';

  @override
  String get notificationMandatory => 'Mandatory';

  @override
  String get loginRequiredForOrders => 'Sign in to view your orders';

  @override
  String get ordersLoginPrompt =>
      'Sign in or create an account to track your orders.';

  @override
  String get loginRequiredForFavorites => 'Sign in to view your favorites';

  @override
  String get favoritesLoginPrompt =>
      'Sign in or create an account to save and view favorite products.';

  @override
  String get signIn => 'Sign In';

  @override
  String get signOut => 'Sign Out';

  @override
  String get all => 'All';

  @override
  String get loadCategoriesFailed => 'Failed to load categories or products';

  @override
  String get allProducts => 'All Products';

  @override
  String get product => 'Product';

  @override
  String get searchResultProduct => 'Product';

  @override
  String get searchResultBrand => 'Brand';

  @override
  String get searchResultCategory => 'Category';

  @override
  String get searchNoResults => 'No results found.';

  @override
  String get searchStartHint => 'Search and discover what you need';

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
  String get loginSuccess => 'Signed in successfully';

  @override
  String get invalidLoginCredentials => 'Incorrect WhatsApp number or password';

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
  String get signUpWhatsAppLabel => 'WhatsApp Number';

  @override
  String get signUpWhatsAppHint => '9xx xxx xxx';

  @override
  String get enterWhatsAppNumber => 'Enter WhatsApp number';

  @override
  String get invalidWhatsAppShort => 'Invalid WhatsApp number';

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
  String get enterFirstName => 'Enter first name';

  @override
  String get enterLastName => 'Enter last name';

  @override
  String get enterEmail => 'Enter email';

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
  String get enterCurrentPassword => 'Enter current password';

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
  String get profileImageTooLarge => 'Image must be 5 MB or smaller';

  @override
  String get profileUnsupportedImageType =>
      'Unsupported image type. Please choose a PNG, JPEG, JPG, or SVG image.';

  @override
  String get skipForNow => 'Skip for now';

  @override
  String get authOtpTitle => 'Verify account';

  @override
  String authOtpSentTo(String destination) {
    return 'Verification code sent to $destination';
  }

  @override
  String get authOtpVerifySuccess => 'Account verified successfully';

  @override
  String get authOtpVerifyFailed => 'Verification failed. Please try again.';

  @override
  String get authOtpCodeLength => 'Enter the 6-digit verification code';

  @override
  String authOtpResendIn(String time) {
    return 'Resend again in $time';
  }

  @override
  String get authOtpResendCode => 'Resend code';

  @override
  String get authOtpResendSuccess => 'Verification code sent again';

  @override
  String get authOtpResendFailed => 'Failed to resend code. Please try again.';

  @override
  String get yourAccount => 'your account';

  @override
  String get profileCity => 'City';

  @override
  String get profileCountry => 'Country';

  @override
  String get genderLabel => 'Gender';

  @override
  String get dateOfBirthLabel => 'Date of birth';

  @override
  String get dateOfBirthHint => 'YYYY-MM-DD (optional)';

  @override
  String get genderMale => 'Male';

  @override
  String get genderFemale => 'Female';

  @override
  String get changePhoto => 'Change photo';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get personalInfo => 'Personal Information';

  @override
  String get newPhoneSuccess => 'Phone number changed successfully';

  @override
  String get phoneVerifiedSuccess => 'Phone number verified successfully';

  @override
  String get confirmPhoneUpdateHint =>
      'Tap confirm to update the phone number in your account';

  @override
  String get confirmChangePhone => 'Confirm change';

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
  String get rateQuestion => 'How would you rate your experience with us?';

  @override
  String get submitRating => 'Submit Rating';

  @override
  String get thanksForRating => 'Thanks for your rating';

  @override
  String get ratingComment => 'Comment';

  @override
  String get ratingCommentHint => 'Tell us more about your experience';

  @override
  String get selectRating => 'Please select a rating';

  @override
  String get loginRequiredForRating => 'Sign in to rate the app';

  @override
  String get ratingLoginPrompt =>
      'Sign in or create an account to share your app experience.';

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
  String get continueToHomeTest => 'Continue as a guest';

  @override
  String otpSentToPhone(String phone) {
    return 'Verification code sent to $phone';
  }

  @override
  String get searchHint => 'Search for products, categories...';

  @override
  String get profilePhoto => 'Profile Photo';

  @override
  String get enterFullNameHint => 'Enter full name';

  @override
  String get enterEmailShort => 'Enter email';

  @override
  String get enterAddressShort => 'Enter address';

  @override
  String get cityAreaStreet => 'City, area, street';

  @override
  String get enterPostalCodeShort => 'Enter postal code';

  @override
  String get saveAndContinue => 'Save and continue';

  @override
  String get associationLinkRequestTitle => 'Association Linking Request';

  @override
  String get associationLinkRequestHint =>
      'Enter your personal and membership details as you know them to request linking your account with the association.';

  @override
  String get associationLinkPersonalSection => 'Personal Information';

  @override
  String get associationLinkContactSection => 'Contact and Address';

  @override
  String get associationLinkMembershipSection => 'Membership Information';

  @override
  String get associationLinkAttachmentsSection => 'Documents and Attachments';

  @override
  String get associationLinkFirstName => 'First Name';

  @override
  String get associationLinkKunya => 'Family / Kunya Name';

  @override
  String get associationLinkFatherName => 'Father\'s Name';

  @override
  String get associationLinkMotherName => 'Mother\'s Name';

  @override
  String get associationLinkNationalId => 'National ID';

  @override
  String get associationLinkGovernorate => 'Governorate';

  @override
  String get associationLinkCity => 'City';

  @override
  String get associationLinkTown => 'Town';

  @override
  String get associationLinkVillage => 'Village';

  @override
  String get associationLinkStreet => 'Street';

  @override
  String get associationLinkBuilding => 'Building';

  @override
  String get associationLinkPermanentAddress => 'Permanent Address';

  @override
  String get associationLinkMobile => 'Mobile Number';

  @override
  String get associationLinkWhatsApp => 'WhatsApp Number';

  @override
  String get associationLinkEmail => 'Email';

  @override
  String get associationLinkMembershipNumber => 'Membership Number';

  @override
  String get associationLinkPriorityNumber => 'Priority Number';

  @override
  String get associationLinkProjectName => 'Project Name';

  @override
  String get associationLinkHousingUnit => 'Assigned Housing Unit';

  @override
  String get associationLinkTotalPayments => 'Total Payments';

  @override
  String get associationLinkAttachmentDescription =>
      'Document Name / Description';

  @override
  String get associationLinkAttachmentType => 'Attachment Type';

  @override
  String get associationLinkEnterFirstName => 'Please enter your name';

  @override
  String get associationLinkUnsupportedFileType => 'Unsupported file type';

  @override
  String get associationLinkFileTooLarge => 'File is too large';

  @override
  String get associationLinkAddAttachment => 'Add File';

  @override
  String get associationLinkDeleteAttachment => 'Delete';

  @override
  String get associationLinkResubmit => 'Resubmit';

  @override
  String get associationLinkSubmit => 'Submit Request';

  @override
  String get associationLinkRequestSubmitted =>
      'Your request was submitted successfully';

  @override
  String get associationLinkPhoneMustMatchAccount =>
      'The phone number must match your account number';

  @override
  String get associationLinkIncompleteWarning =>
      'Some fields are incomplete. You can continue with the minimum required data.';

  @override
  String get associationLinkSubmittedLocked =>
      'The request was submitted and is under review. It can no longer be edited.';

  @override
  String get associationLinkNoAttachments =>
      'No attachments added yet. Supporting documents are recommended.';

  @override
  String get associationRequestedMembershipType => 'Requested membership type';

  @override
  String get associationMembershipTypeTourism => 'Tourism';

  @override
  String get associationMembershipTypeResidential => 'Residential';

  @override
  String get associationAdditionalAddresses => 'Additional addresses';

  @override
  String get associationAddress => 'Address';

  @override
  String get associationAdditionalAddress => 'Additional address';

  @override
  String get associationAddAddress => 'Add address';

  @override
  String get associationAddCurrentAddress => 'Add current address';

  @override
  String get associationStreetNumber => 'Street number';

  @override
  String get associationAddressLabel => 'Address label';

  @override
  String get associationAddressType => 'Address type';

  @override
  String get associationAddressRequired => 'Add address';

  @override
  String get associationDeleteAddress => 'Delete address';

  @override
  String get associationAddressLoadingRequestTypes => 'Loading';

  @override
  String get associationAddressSelectCapital => 'Select capital';

  @override
  String get associationAddressLoadingCapitals => 'Loading the capitals';

  @override
  String get associationAddressSelectCity => 'Select city';

  @override
  String get associationAddressLoadingCities => 'Loading the cities';

  @override
  String get associationAddressSelectTown => 'Select town';

  @override
  String get associationAddressLoadingTowns => 'Loading the towns';

  @override
  String get associationAddressLoadAgain => 'Load again';

  @override
  String get verifyPhoneTitle => 'Verify phone number';

  @override
  String codeSentViaWhatsApp(String phone) {
    return 'Verification code sent to $phone via WhatsApp';
  }

  @override
  String get otpPhoneHintSignUp =>
      'Enter phone number to receive verification code via WhatsApp';

  @override
  String get otpPhoneHintForgot =>
      'Enter the phone number associated with your account to receive the verification code via WhatsApp';

  @override
  String get otpPhoneHintChange =>
      'Enter your new phone number to receive the verification code via WhatsApp';

  @override
  String get introDesc1 =>
      'Kalivra is your one-stop platform for building materials and decor. Browse brands, products, and offers, and order what you need with ease.';

  @override
  String get introDesc2 =>
      'A wide range of paints, ceramics, iron, sanitary and electrical supplies. Regular offers, fast delivery, and 24/7 customer service.';

  @override
  String get introDesc3 =>
      'Register now for a smooth shopping experience. Track orders, save favorites, and pay securely. Welcome to the Kalivra family.';

  @override
  String get closeTooltip => 'Close';

  @override
  String get orderDetails => 'Order details';

  @override
  String get shippingAddress => 'Shipping address';

  @override
  String get noBrands => 'No brands yet';

  @override
  String get adsTitle => 'Ads';

  @override
  String get noAds => 'No ads';

  @override
  String get loginPromptNotifications =>
      'Sign in or create an account to receive order and offer notifications.';

  @override
  String get privacyPolicyContent =>
      'Privacy Policy\n\nLast updated: January 2024\n\nAt Kalivra we respect your privacy and are committed to protecting your personal data. This policy explains how we collect, use, and share your information when you use our app.\n\n1. Information we collect\nWe collect information you provide when registering or placing orders, such as name, email, phone number, and address. We also automatically collect some technical data to improve app performance.\n\n2. Use of information\nWe use your information to process orders, communicate with you, improve our services, and send offers that may interest you (with your consent).\n\n3. Data protection\nWe apply appropriate security measures to protect your data from unauthorized access or disclosure.\n\n4. Sharing information\nWe do not sell your personal data. We may share information with service partners (e.g. shipping and payment) only as necessary to fulfill your order.\n\n5. Your rights\nYou can request access, correction, or deletion of your data by contacting us.\n\nFor any inquiry: support@kalivra.com';

  @override
  String get allCategories => 'All';

  @override
  String get associationPersonalProfileButton => 'Association Profile';

  @override
  String get associationMemberProfileTitle => 'Association Profile';

  @override
  String get associationMemberProfileEmpty =>
      'No linked association profile is available yet. Submit a linking request to connect your account with the association.';

  @override
  String get associationMemberProfileLinkRequest => 'Submit Linking Request';

  @override
  String get associationMemberCurrentAddress => 'Current Address';

  @override
  String get associationMemberMembershipStatus => 'Membership Status';

  @override
  String get associationMemberPaymentCommitment => 'Payment Commitment';

  @override
  String get associationMemberPaymentsByYear => 'Payments by Year';

  @override
  String get associationMemberFinancialSummary => 'Financial Summary';

  @override
  String get associationMemberTotalAmount => 'Total Amount';

  @override
  String get associationMemberPaidAmount => 'Paid';

  @override
  String get associationMemberRemainingInstallments => 'Remaining Installments';

  @override
  String get associationMemberInstallments => 'Installments';

  @override
  String get associationMemberOtherPayments => 'Other Payments';

  @override
  String get associationMemberNotifications => 'Notifications';

  @override
  String get associationMemberEvents => 'Events';

  @override
  String get associationMemberMeasurements => 'Measurements';

  @override
  String get associationMemberAttachments => 'Attachments';

  @override
  String get associationMemberAmount => 'Amount';

  @override
  String get associationMemberDate => 'Date';

  @override
  String get associationMemberStatus => 'Status';

  @override
  String get associationMemberNotes => 'Notes';

  @override
  String get associationMemberMethod => 'Method';

  @override
  String get associationMemberBank => 'Bank';

  @override
  String get associationMemberReceipt => 'Receipt';

  @override
  String get associationMemberType => 'Type';

  @override
  String get associationMemberTitle => 'Title';

  @override
  String get associationMemberRead => 'Read';

  @override
  String get associationMemberEvent => 'Event';

  @override
  String get associationMemberLocation => 'Location';

  @override
  String get associationMemberValue => 'Value';

  @override
  String get associationMemberPayment => 'Payment';

  @override
  String get associationMemberUnread => 'Unread';

  @override
  String get associationMemberReadStatus => 'Read';

  @override
  String get associationMemberNoData => 'No data available';

  @override
  String get associationMemberLoadFailed =>
      'Failed to load association profile';

  @override
  String get retry => 'Retry';

  @override
  String get incorrectPassword => 'Incorrect password. Please try again.';

  @override
  String get accountNotFound =>
      'Phone number was not found, Please check the phone number or create a new account.';

  @override
  String get signOutConfirmation => 'Are you sure you want to sign out?';

  @override
  String get loginRequiredTitle => 'Sign in required';

  @override
  String get settingsLoginRequiredDescription =>
      'Please sign in to change your password or reset your WhatsApp number.';

  @override
  String get areYouSureYouWantToSignIn => 'Are you sure you want to sign in?';

  @override
  String get exitAppConfirmation => 'Do you want to exit the app?';

  @override
  String get exitAppTitle => 'Exit app';

  @override
  String get associationLinkNoData => 'No data';

  @override
  String get associationSubmittedRequestsTitle => 'Submitted Requests';

  @override
  String get associationNoSubmittedRequests =>
      'You haven\'t submitted any requests yet.';

  @override
  String get associationRequestNumber => 'Request';

  @override
  String get associationRequestCreatedAt => 'Submitted';

  @override
  String get associationRequestApprovedAt => 'Approved';

  @override
  String get associationRequestViewDocument => 'View Document';

  @override
  String get associationRequestStatusPending => 'Pending';

  @override
  String get associationRequestStatusApproved => 'Approved';

  @override
  String get associationRequestStatusRejected => 'Rejected';

  @override
  String get delete => 'Delete';

  @override
  String get linkRequestsScreen => 'Joining requests';

  @override
  String get whatsappNumber => 'Whatsapp number';

  @override
  String get contactInfo => 'Contact info';

  @override
  String get userLocationInfo => 'Address info';

  @override
  String get linkRequestSentSuccessfully =>
      'Association link request has been sent successfully';

  @override
  String get requestSentSuccessfully =>
      'Your request has been sent successfully';

  @override
  String get frequentlyAskedQuestion => 'Frequently asked questions';

  @override
  String get associationContactUs => 'Contact the association';

  @override
  String get associationChatMessageHint => 'ُWrite a message';

  @override
  String get associationRequestsAndServices => 'Requests and services';

  @override
  String get associationNewsFeedTitle => 'News feed';

  @override
  String get associationNewsFeedImportant => 'Important';

  @override
  String get associationNewsFeedSample1 =>
      'Payment schedule update: please review the latest due dates for the residential project.';

  @override
  String get associationNewsFeedSample2 =>
      'The association office will receive member inquiries from Sunday to Thursday, 9 AM to 2 PM.';

  @override
  String get associationNewsFeedSample3 =>
      'A new progress summary for the second project phase is available for members to review.';

  @override
  String get associationAnnouncementsTitle => 'Official announcements';

  @override
  String get associationAnnouncementsSubtitle =>
      'Track official notices, delivery status, deadlines, and attachments.';

  @override
  String get associationAnnouncementsHint =>
      'Tap an announcement card to view its full official details.';

  @override
  String get associationAnnouncementTotal => 'Total';

  @override
  String get associationAnnouncementDelivered => 'Delivered';

  @override
  String get associationAnnouncementPending => 'Pending';

  @override
  String get associationAnnouncementCategory => 'Category';

  @override
  String get associationAnnouncementType => 'Type';

  @override
  String get associationAnnouncementRecipients => 'Recipients';

  @override
  String get associationAnnouncementDeadline => 'Legal deadline';

  @override
  String get associationAnnouncementRelatedEntity => 'Related entity';

  @override
  String get associationAnnouncementChannels => 'Delivery channels';

  @override
  String get associationAnnouncementContent => 'Announcement content';

  @override
  String get associationAnnouncementAttachments => 'Attachments';

  @override
  String get associationAnnouncementNoAttachments => 'No attachments';

  @override
  String get associationAnnouncementCategoryElectronic =>
      'Electronic announcement';

  @override
  String get associationAnnouncementCategoryOfficial =>
      'Documented official announcement';

  @override
  String get associationAnnouncementTypePaymentNotice => 'Payment due notice';

  @override
  String get associationAnnouncementTypeMeetingInvitation =>
      'Meeting invitation';

  @override
  String get associationAnnouncementTypeDecisionNotice => 'Decision notice';

  @override
  String get associationAnnouncementChannelInApp => 'In-app';

  @override
  String get associationAnnouncementChannelWhatsapp => 'WhatsApp';

  @override
  String get associationAnnouncementChannelSms => 'SMS';

  @override
  String get associationAnnouncementChannelEmail => 'Email';

  @override
  String get associationAnnouncementNoDeadline => 'No legal deadline';

  @override
  String get associationAnnouncementSampleTitle1 => 'Payment deadline reminder';

  @override
  String get associationAnnouncementSampleRecipients1 =>
      'Members of the residential project';

  @override
  String get associationAnnouncementSampleDeadline1 => '10 days remaining';

  @override
  String get associationAnnouncementSampleRelated1 => 'Project payments';

  @override
  String get associationAnnouncementSampleContent1 =>
      'Please review the due payment schedule and complete the required payment before the legal deadline. This announcement is linked to the member financial file.';

  @override
  String get associationAnnouncementSampleAttachment1 => 'Payment schedule.pdf';

  @override
  String get associationAnnouncementSampleAttachment2 => 'Official notice.docx';

  @override
  String get associationAnnouncementSampleTitle2 =>
      'General assembly meeting invitation';

  @override
  String get associationAnnouncementSampleRecipients2 =>
      'All active association members';

  @override
  String get associationAnnouncementSampleDeadline2 =>
      'Meeting date: 2026-07-20';

  @override
  String get associationAnnouncementSampleRelated2 =>
      'General assembly session';

  @override
  String get associationAnnouncementSampleContent2 =>
      'You are invited to attend the general assembly meeting. The meeting agenda and attendance instructions are attached to this announcement.';

  @override
  String get associationAnnouncementSampleAttachment3 => 'Meeting agenda.pdf';

  @override
  String get associationAnnouncementSampleTitle3 =>
      'Board decision notification';

  @override
  String get associationAnnouncementSampleRecipients3 =>
      'Members linked to phase two';

  @override
  String get associationAnnouncementSampleRelated3 => 'Board decision';

  @override
  String get associationAnnouncementSampleContent3 =>
      'The association board decision has been published for review. This notice is provided for documentation and member awareness.';

  @override
  String get associationRequestTypeHint => 'select request type';

  @override
  String get associationRequestTypeOrMessageRequired =>
      'This field is required';

  @override
  String get associationRequestMessageHint => 'Enter message';
}
