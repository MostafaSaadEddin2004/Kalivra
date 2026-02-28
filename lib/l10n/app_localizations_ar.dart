// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get helloWorld => 'مرحباً';

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navCategories => 'التصنيفات';

  @override
  String get navNotifications => 'الإشعارات';

  @override
  String get navSearch => 'البحث';

  @override
  String get drawerMyAccount => 'حسابي';

  @override
  String get drawerMyOrders => 'طلباتي';

  @override
  String get drawerFavorites => 'المفضلة';

  @override
  String get drawerSettings => 'الإعدادات';

  @override
  String get drawerContactUs => 'تواصل معنا';

  @override
  String get drawerAboutApp => 'حول التطبيق';

  @override
  String get drawerPrivacyPolicy => 'سياسة الخصوصية';

  @override
  String get drawerShare => 'مشاركة';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get settingsAppearance => 'المظهر';

  @override
  String get settingsLanguage => 'اللغة';

  @override
  String get settingsAccountSecurity => 'الحساب والأمان';

  @override
  String get settingsChangePassword => 'تغيير كلمة المرور';

  @override
  String get settingsChangePhone => 'تغيير رقم الجوال';

  @override
  String get appearanceTitle => 'المظهر';

  @override
  String get themeDark => 'الوضع الليلي';

  @override
  String get themeDarkSubtitle => 'Dark mode';

  @override
  String get themeLight => 'الوضع النهاري';

  @override
  String get themeLightSubtitle => 'Light mode';

  @override
  String get themeSystem => 'نظام الجهاز';

  @override
  String get themeSystemSubtitle => 'System default';

  @override
  String get languageTitle => 'اللغة';

  @override
  String get languageArabic => 'العربية';

  @override
  String get languageArabicSubtitle => 'Arabic';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageEnglishSubtitle => 'الإنجليزية';

  @override
  String get languageFollowSystem => 'نظام الجهاز';

  @override
  String get languageFollowSystemSubtitle => 'استخدام لغة الجهاز';

  @override
  String get ok => 'حسناً';

  @override
  String get error => 'خطأ';

  @override
  String get version => 'الإصدار 1.0.0';

  @override
  String get menu => 'القائمة';

  @override
  String get cart => 'السلة';

  @override
  String get back => 'رجوع';

  @override
  String get loginRequiredForCart =>
      'يجب تسجيل الدخول لإضافة المنتجات إلى السلة';

  @override
  String addToCartSuccess(String productName) {
    return 'تمت إضافة \"$productName\" إلى السلة';
  }

  @override
  String get continueShopping => 'متابعة التسوق';

  @override
  String get emptyCart => 'تفريغ السلة';

  @override
  String get priceDetails => 'تفاصيل السعر';

  @override
  String get subtotal => 'المجموع الفرعي';

  @override
  String get discount => 'الخصم';

  @override
  String get tax => 'الضريبة';

  @override
  String get total => 'المجموع الكلي';

  @override
  String get deliveryCost => 'تكلفة التوصيل';

  @override
  String get productsTotal => 'إجمالي المنتجات';

  @override
  String get amountDue => 'المبلغ المستحق';

  @override
  String get proceed => 'متابعة';

  @override
  String get productDetails => 'تفاصيل المنتج';

  @override
  String get invalidProductId => 'معرّف المنتج غير صالح';

  @override
  String addToWishlistSuccess(String productName) {
    return 'تمت إضافة \"$productName\" إلى المفضلة';
  }

  @override
  String get addToWishlistFailed => 'فشل إضافة المنتج إلى المفضلة';

  @override
  String get unit => 'الوحدة';

  @override
  String get maxOrderLimit => 'الحد الأقصى للطلب';

  @override
  String get addToWishlist => 'إضافة إلى المفضلة';

  @override
  String get addToCart => 'إضافة إلى السلة';

  @override
  String get notificationsWelcomeTitle => 'مرحباً بك في Kalivra';

  @override
  String get notificationsWelcomeBody =>
      'اكتشف منتجات البناء والديكور بأسعار منافسة.';

  @override
  String get now => 'الآن';

  @override
  String get notificationsPaintOfferTitle => 'عرض خاص على الدهانات';

  @override
  String get notificationsPaintOfferBody =>
      'خصم حتى 20% على تشكيلة الدهانات هذا الأسبوع.';

  @override
  String get yesterday => 'أمس';

  @override
  String get notificationsOrderProcessingTitle => 'طلبك قيد التجهيز';

  @override
  String get notificationsOrderProcessingBody =>
      'تم استلام طلبك وسيتم الشحن خلال 24 ساعة.';

  @override
  String get twoDaysAgo => 'منذ يومين';

  @override
  String get loginRequiredForNotifications => 'يجب تسجيل الدخول لعرض الإشعارات';

  @override
  String get notificationsLoginPrompt =>
      'سجّل الدخول أو أنشئ حساباً لاستلام إشعارات الطلبات والعروض.';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get all => 'الكل';

  @override
  String get loadCategoriesFailed => 'فشل تحميل التصنيفات أو المنتجات';

  @override
  String get allProducts => 'جميع المنتجات';

  @override
  String get product => 'منتج';

  @override
  String get noProductsInCategory => 'لا توجد منتجات في هذا التصنيف';

  @override
  String get offers => 'العروض';

  @override
  String get loadOffersFailed => 'فشل تحميل العروض';

  @override
  String get noOffers => 'لا توجد عروض حالياً';

  @override
  String get allSaleProducts => 'جميع المنتجات المخفضة';

  @override
  String get products => 'المنتجات';

  @override
  String get loadProductsFailed => 'فشل تحميل المنتجات';

  @override
  String get noProducts => 'لا توجد منتجات';

  @override
  String get branchCount => 'عدد الفروع';

  @override
  String get locations => 'المواقع';

  @override
  String get phone => 'الهاتف';

  @override
  String get website => 'الموقع';

  @override
  String get noProductsForBrand => 'لا توجد منتجات لهذه العلامة حالياً';

  @override
  String get noOffersForBrand => 'لا توجد عروض لهذه العلامة حالياً';

  @override
  String get orderSummary => 'ملخص الطلب';

  @override
  String quantityLabel(int count) {
    return 'الكمية: $count';
  }

  @override
  String get shipping => 'الشحن';

  @override
  String get checkoutStepAddress => 'العنوان';

  @override
  String get checkoutStepShipping => 'الشحن';

  @override
  String get checkoutStepPayment => 'الدفع';

  @override
  String get checkoutStepComplete => 'إتمام الطلب';

  @override
  String get completeStepData => 'أكمل البيانات المطلوبة في هذه الخطوة';

  @override
  String get placeOrderFailed => 'فشل إتمام الطلب. جرّب مرة أخرى.';

  @override
  String get myAccount => 'حسابي';

  @override
  String get loginToViewProfile => 'سجّل الدخول لعرض الملف الشخصي';

  @override
  String get editProfile => 'تعديل الملف الشخصي';

  @override
  String get accountInfo => 'معلومات الحساب';

  @override
  String get name => 'الاسم';

  @override
  String get email => 'البريد';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get mobileNumber => 'رقم الجوال';

  @override
  String get joinDate => 'تاريخ التسجيل';

  @override
  String get address => 'العنوان';

  @override
  String get mainAddress => 'العنوان الرئيسي';

  @override
  String get postalCode => 'الرمز البريدي';

  @override
  String get stats => 'إحصائيات';

  @override
  String get ordersCount => 'عدد الطلبات';

  @override
  String get pendingOrders => 'طلبات قيد التنفيذ';

  @override
  String memberSince(int year) {
    return 'عميل منذ $year';
  }

  @override
  String get referralCode => 'كود الدعوة';

  @override
  String get referralCodeHint =>
      'شارك هذا الكود أو المسح مع الأصدقاء ليحصلوا على خصم عند التسجيل، وتستفيد أنت أيضاً';

  @override
  String customerSince(int year) {
    return 'عميل منذ $year';
  }

  @override
  String get myOrders => 'طلباتي';

  @override
  String get loadOrdersFailed => 'فشل تحميل الطلبات';

  @override
  String get noOrders => 'لا توجد طلبات بعد';

  @override
  String get ordersPrompt => 'طلباتك ستظهر هنا';

  @override
  String get viewDetails => 'عرض التفاصيل';

  @override
  String get statusComplete => 'مكتمل';

  @override
  String get statusShipping => 'توصيل';

  @override
  String get favorites => 'المفضلة';

  @override
  String get loadFavoritesFailed => 'فشل تحميل المفضلة';

  @override
  String get favoritesEmpty => 'قائمة المفضلة فارغة';

  @override
  String get favoritesPrompt =>
      'أضف المنتجات إلى المفضلة من خلال زر القلب في صفحة المنتج';

  @override
  String get shopNow => 'تسوق الآن';

  @override
  String get addressSaved => 'تم حفظ العنوان';

  @override
  String get saveAddress => 'حفظ العنوان';

  @override
  String get paymentMethod => 'طريقة الدفع';

  @override
  String get cashOnDelivery => 'الدفع عند الاستلام';

  @override
  String get cashOnDeliverySubtitle => 'ادفع نقداً عند استلام الطلب';

  @override
  String get onlinePayment => 'الدفع الإلكتروني';

  @override
  String get onlinePaymentSubtitle => 'شام كاش، سيرياتيل كاش، إم تي إن كاش';

  @override
  String get selectPaymentMethod => 'اختر طريقة الدفع الإلكتروني';

  @override
  String get walletDetails => 'بيانات المحفظة';

  @override
  String get required => 'مطلوب';

  @override
  String get invalidPhone => 'رقم هاتف غير صالح';

  @override
  String get walletPhoneLabel => 'رقم الهاتف المرتبط بالمحفظة*';

  @override
  String get walletNameLabel => 'الاسم كما في المحفظة (اختياري)';

  @override
  String get walletNameHint => 'للتحقق من صحة الدفع';

  @override
  String get paymentShamcash => 'شام كاش';

  @override
  String get paymentSyriatel => 'سيرياتيل كاش';

  @override
  String get paymentMtn => 'إم تي إن كاش';

  @override
  String get paymentShamcashDesc =>
      'محفظة إلكترونية سورية للتحويل والدفع عبر التطبيق';

  @override
  String get paymentSyriatelDesc =>
      'منصة الدفع الإلكتروني من سيرياتيل للتحويل والدفع';

  @override
  String get paymentMtnDesc => 'خدمة المحفظة المالية من إم تي إن سوريا';

  @override
  String get shippingMethod => 'طريقة الشحن';

  @override
  String get standardDelivery => 'توصيل عادي';

  @override
  String get standardDeliveryDesc => '5-7 أيام عمل';

  @override
  String get fastDelivery => 'توصيل سريع';

  @override
  String get fastDeliveryDesc => '2-3 أيام عمل';

  @override
  String get sameDayDelivery => 'نفس اليوم';

  @override
  String get sameDayDeliveryDesc => 'طلب قبل 12 ظهراً';

  @override
  String get preferredDeliveryDate => 'تاريخ التوصيل المفضل';

  @override
  String get chooseDate => 'اختر التاريخ';

  @override
  String get deliveryNotes => 'ملاحظات التوصيل (اختياري)';

  @override
  String get deliveryNotesHint => 'مثال: اترك عند الباب، اتصل عند الوصول...';

  @override
  String get firstName => 'الاسم الأول';

  @override
  String get lastName => 'الاسم الأخير';

  @override
  String get firstNameRequired => 'الاسم الأول*';

  @override
  String get lastNameRequired => 'الاسم الأخير*';

  @override
  String get emailRequired => 'البريد الإلكتروني*';

  @override
  String get emailHint => 'example@email.com';

  @override
  String get companyName => 'اسم الشركة';

  @override
  String get phoneRequired => 'الهاتف*';

  @override
  String get streetRequired => 'الشارع*';

  @override
  String get streetHint => 'عنوان الشارع';

  @override
  String get postalCodeRequired => 'الرمز البريدي*';

  @override
  String get stateRequired => 'المحافظة*';

  @override
  String get cityRequired => 'المدينة*';

  @override
  String get invalidEmail => 'أدخل بريداً إلكترونياً صالحاً';

  @override
  String get noOrder => 'لا يوجد طلب';

  @override
  String get errorMissingData => 'خطأ: لم يتم تمرير البيانات';

  @override
  String get productUnavailable => 'المنتج غير متوفر';

  @override
  String get brandUnavailable => 'العلامة غير متوفرة';

  @override
  String get adUnavailable => 'الإعلان غير متوفر';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get loginFailed => 'فشل تسجيل الدخول';

  @override
  String get loginTitle => 'تسجيل الدخول';

  @override
  String get loginHint => 'أدخل رقم الجوال وكلمة المرور للدخول إلى حسابك';

  @override
  String get enterPhone => 'أدخل رقم الجوال';

  @override
  String get invalidPhoneShort => 'رقم غير صالح';

  @override
  String get phoneLabel => 'رقم الجوال';

  @override
  String get enterPassword => 'أدخل كلمة المرور';

  @override
  String get passwordLabel => 'كلمة المرور';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get noAccount => 'ليس لديك حساب؟ ';

  @override
  String get registerNow => 'سجّل الآن';

  @override
  String get signUp => 'إنشاء حساب';

  @override
  String get signUpHint =>
      'أدخل بياناتك للتسجيل والتحقق من رقم الجوال عبر واتساب';

  @override
  String get enterName => 'أدخل اسمك';

  @override
  String get passwordMinLength => 'كلمة المرور 6 أحرف على الأقل';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get confirmPasswordRequired => 'أكد كلمة المرور';

  @override
  String get passwordsDoNotMatch => 'كلمة المرور غير متطابقة';

  @override
  String get continueVerification => 'متابعة التحقق';

  @override
  String get haveAccount => 'لديك حساب؟ ';

  @override
  String get unexpectedError => 'حدث خطأ غير متوقع';

  @override
  String get inviteCodeQuestion => 'لديك كود دعوة من صديق؟';

  @override
  String get inviteCodeLabel => 'كود الدعوة';

  @override
  String get inviteCodeHint =>
      'أدخل الكود أو اضغط للأيقونة لمسح أو اختيار صورة';

  @override
  String get codeCopied => 'تم نسخ الكود';

  @override
  String get changePasswordTitle => 'تغيير كلمة المرور';

  @override
  String get passwordUpdated => 'تم تحديث كلمة المرور';

  @override
  String get currentPassword => 'كلمة المرور الحالية';

  @override
  String get newPassword => 'كلمة المرور الجديدة';

  @override
  String get newPasswordConfirm => 'تأكيد كلمة المرور';

  @override
  String get passwordUpdatedSuccess => 'تم تحديث كلمة المرور بنجاح';

  @override
  String get completeProfileTitle => 'أكمل بياناتك';

  @override
  String get addressOrLocation => 'العنوان / الموقع';

  @override
  String get editProfileTitle => 'تعديل الملف الشخصي';

  @override
  String get profileSaved => 'تم حفظ التعديلات';

  @override
  String get personalInfo => 'معلومات شخصية';

  @override
  String get newPhoneSuccess => 'تم تغيير رقم الجوال بنجاح';

  @override
  String get changePhoneTitle => 'تغيير رقم الجوال';

  @override
  String get sendCodeViaWhatsApp => 'إرسال الرمز عبر واتساب';

  @override
  String get enterPhoneNumber => 'أدخل رقم الجوال';

  @override
  String get enterCode4To6 => 'أدخل الرمز المكون من 4-6 أرقام';

  @override
  String get rateTitle => 'تقييم';

  @override
  String get submitRating => 'إرسال التقييم';

  @override
  String get thanksForRating => 'شكراً لتقييمك';

  @override
  String get size => 'الحجم';

  @override
  String get color => 'اللون';

  @override
  String get dash => '—';

  @override
  String get confirmOrder => 'تأكيد الطلب';

  @override
  String get introTitle1 => 'ما هو كليفرا؟';

  @override
  String get introTitle2 => 'ماذا نقدم؟';

  @override
  String get introTitle3 => 'انضم إلينا';

  @override
  String get showAll => 'عرض الكل';

  @override
  String get emptyCartTitle => 'السلة فارغة';

  @override
  String get emptyCartBody => 'تصفح التصنيفات وأضف المنتجات هنا';

  @override
  String get brandsSection => 'العلامات التجارية';

  @override
  String get send => 'إرسال';

  @override
  String get remove => 'حذف';

  @override
  String get sizePlaceholder => 'الحجم — —';

  @override
  String get colorPlaceholder => 'اللون — —';

  @override
  String get currencySYP => 'ل.س';

  @override
  String get setNewPasswordTitle => 'كلمة المرور الجديدة';

  @override
  String get setNewPasswordBody => 'أدخل كلمة المرور الجديدة لحسابك';

  @override
  String get confirmPasswordMismatch => 'غير متطابقة مع كلمة المرور الجديدة';

  @override
  String get updatePasswordButton => 'تحديث كلمة المرور';

  @override
  String get verifyCodeTitle => 'التحقق من الرمز';

  @override
  String get recoverPasswordTitle => 'استعادة كلمة المرور';

  @override
  String get changePhoneOtpTitle => 'تغيير رقم الجوال';

  @override
  String get enterCodeHintSnack => 'أدخل الرمز المكون من 4-6 أرقام';

  @override
  String get otpCodeHintSignUp => 'أدخل رمز التحقق المرسل إليك على واتساب';

  @override
  String get otpCodeHintOther => 'أدخل الرمز المرسل إليك عبر واتساب';

  @override
  String get otpCodeLabel => 'رمز التحقق';

  @override
  String get verify => 'تحقق';

  @override
  String get contactTitle => 'تواصل معنا';

  @override
  String get contactWelcome => 'نسعد بتواصلك معنا';

  @override
  String get contactChannels =>
      'يمكنك التواصل معنا عبر القنوات التالية أو إرسال رسالة';

  @override
  String get contactPhoneTitle => 'الهاتف';

  @override
  String get contactEmailTitle => 'البريد الإلكتروني';

  @override
  String get contactHoursTitle => 'ساعات العمل';

  @override
  String get contactHoursValue => 'السبت - الخميس: 9 ص - 9 م';

  @override
  String get sendMessage => 'أرسل رسالة';

  @override
  String get subjectLabel => 'الموضوع';

  @override
  String get messageLabel => 'الرسالة';

  @override
  String get continueToHomeTest => 'المتابعة للرئيسية (تجربة)';

  @override
  String otpSentToPhone(String phone) {
    return 'تم إرسال رمز التحقق إلى $phone';
  }
}
