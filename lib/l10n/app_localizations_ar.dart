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
  String get drawerMyAccount => 'الحساب';

  @override
  String get drawerMyOrders => 'طلباتي';

  @override
  String get drawerFavorites => 'المفضلة';

  @override
  String get associationLinkRequest => 'طلب الربط بالجمعية';

  @override
  String get drawerSettings => 'الإعدادات';

  @override
  String get drawerContactUs => 'تواصل معنا';

  @override
  String get drawerAboutApp => 'حول التطبيق';

  @override
  String get drawerPrivacyPolicy => 'سياسة الخصوصية';

  @override
  String get drawerTermsConditions => 'الشروط والأحكام';

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
  String get settingsChangePhone => 'إعادة تعيين رقم واتساب';

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
  String get yes => 'نعم';

  @override
  String get no => 'لا';

  @override
  String get error => 'خطأ';

  @override
  String get version => 'الإصدار 1.0.0';

  @override
  String get aboutAppDescription =>
      'تطبيق كليفرة يوفر لك تجربة تسوق سهلة وآمنة لمنتجات البناء والتشطيبات. تصفح التصنيفات، اطلب ما تحتاجه، وتابع طلباتك من مكان واحد.';

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
  String get loginRequiredForCartView => 'يجب تسجيل الدخول لعرض السلة';

  @override
  String get cartLoginPrompt =>
      'سجّل الدخول أو أنشئ حساباً لعرض السلة وإدارتها.';

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
  String get cartItemsCount => 'العناصر';

  @override
  String get cartItemsQuantity => 'إجمالي الكمية';

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
  String get chooseCartOptions => 'اختيار الخيارات';

  @override
  String get editItem => 'تعديل المنتج';

  @override
  String get deleteItem => 'حذف المنتج';

  @override
  String get clearCart => 'إفراغ السلة';

  @override
  String get quantity => 'الكمية';

  @override
  String get colour => 'اللون';

  @override
  String get unitPrice => 'سعر الوحدة';

  @override
  String get cancel => 'إلغاء';

  @override
  String removeItemConfirmation(String productName) {
    return 'هل أنت متأكد أنك تريد إزالة \"$productName\" من السلة؟ سيتم حذف هذا المنتج من طلبك.';
  }

  @override
  String get clearCartConfirmation =>
      'هل تريد حذف جميع المنتجات من السلة؟ سيتم إفراغ السلة بالكامل.';

  @override
  String get itemUpdatedSuccessfully => 'تم تحديث المنتج في السلة بنجاح';

  @override
  String get itemDeletedSuccessfully => 'تم حذف المنتج من السلة بنجاح';

  @override
  String get cartClearedSuccessfully => 'تم إفراغ السلة بنجاح';

  @override
  String get coupon => 'القسيمة';

  @override
  String get couponCode => 'رمز القسيمة';

  @override
  String get applyCoupon => 'إضافة';

  @override
  String get applyCouponTitle => 'إضافة قسيمة';

  @override
  String get couponAppliedSuccessfully => 'تم تطبيق القسيمة بنجاح';

  @override
  String get couponRemovedSuccessfully => 'تم حذف القسيمة بنجاح';

  @override
  String get noChangesDetected => 'لا توجد تغييرات';

  @override
  String get invalidQuantity => 'أدخل كمية صالحة';

  @override
  String get selectRequiredOptions => 'اختر الخيارات المطلوبة';

  @override
  String get unableToAddItem => 'تعذر إضافة المنتج إلى السلة';

  @override
  String get unableToUpdateItem => 'تعذر تحديث المنتج';

  @override
  String get unableToDeleteItem => 'تعذر حذف المنتج';

  @override
  String get unableToClearCart => 'تعذر إفراغ السلة';

  @override
  String get quantityReadOnly => 'لا يمكن تعديل الكمية لهذا المنتج.';

  @override
  String availableQuantity(int count) {
    return 'المتوفر: $count';
  }

  @override
  String get quantityLimitTitle => 'حد الكمية';

  @override
  String quantityLimitMessage(int count) {
    return 'المتوفر لهذا الاختيار هو $count فقط.';
  }

  @override
  String get noSizeOptions => 'لا توجد خيارات حجم';

  @override
  String get noColourOptions => 'لا توجد خيارات لون';

  @override
  String get productDetails => 'تفاصيل المنتج';

  @override
  String get invalidProductId => 'معرّف المنتج غير صالح';

  @override
  String addToWishlistSuccess(String productName) {
    return 'تمت إضافة \"$productName\" إلى المفضلة بنجاح';
  }

  @override
  String get addToWishlistFailed => 'فشل إضافة المنتج إلى المفضلة';

  @override
  String get unit => 'عدد';

  @override
  String get residentialUnit => 'الوحدة السكنية';

  @override
  String get maxOrderLimit => 'الحد الأقصى للطلب';

  @override
  String get productOrderInfo => 'معلومات الطلب';

  @override
  String get unitPiece => 'قطعة';

  @override
  String maxOrderLimitValue(int count) {
    return 'حتى $count لكل طلب';
  }

  @override
  String get addToWishlist => 'إضافة إلى المفضلة';

  @override
  String get removeFromWishlist => 'إزالة من المفضلة';

  @override
  String removeFromWishlistSuccess(String productName) {
    return 'تمت إزالة \"$productName\" من المفضلة';
  }

  @override
  String get removeFromWishlistFailed => 'فشل إزالة المنتج من المفضلة';

  @override
  String get clearWishlist => 'هل أنت متأكد من إفراغ قائمة المفضلة؟';

  @override
  String get warning => 'تحذير!';

  @override
  String get addToCart => 'إضافة إلى السلة';

  @override
  String get productSku => 'رمز المنتج';

  @override
  String get productDescription => 'الوصف';

  @override
  String get productNew => 'جديد';

  @override
  String get productFeatured => 'مميز';

  @override
  String get productOnSale => 'تخفيض';

  @override
  String get productAvailability => 'التوفر';

  @override
  String get productAvailable => 'متوفر';

  @override
  String get productOutOfStock => 'غير متوفر';

  @override
  String get productRating => 'التقييم';

  @override
  String productRatingSummary(String rating, int count) {
    return '$rating / 5 ($count)';
  }

  @override
  String get productReviews => 'المراجعات';

  @override
  String productReviewsCount(int count) {
    return '$count مراجعة';
  }

  @override
  String get productMinPriceLabel => 'يبدأ من';

  @override
  String get productInfo => 'معلومات المنتج';

  @override
  String get productUrlKey => 'رابط المنتج';

  @override
  String get productStockQuantity => 'كمية المخزون';

  @override
  String get productMeasurementType => 'نوع القياس';

  @override
  String get productMeasurementTypes => 'أنواع القياس';

  @override
  String get brand => 'العلامة التجارية';

  @override
  String get activeBrand => 'علامة تجارية نشطة';

  @override
  String get inactiveBrand => 'علامة تجارية غير نشطة';

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
  String get noNotifications => 'لا توجد إشعارات بعد';

  @override
  String get notificationsEmptyPrompt =>
      'ستظهر هنا التحديثات وتنبيهات الطلبات والعروض الجديدة.';

  @override
  String get notificationRead => 'مقروء';

  @override
  String get notificationUnread => 'غير مقروء';

  @override
  String get notificationMandatory => 'إلزامي';

  @override
  String get loginRequiredForOrders => 'يجب تسجيل الدخول لعرض طلباتك';

  @override
  String get ordersLoginPrompt => 'سجّل الدخول أو أنشئ حساباً لمتابعة طلباتك.';

  @override
  String get loginRequiredForFavorites => 'يجب تسجيل الدخول لعرض المفضلة';

  @override
  String get favoritesLoginPrompt =>
      'سجّل الدخول أو أنشئ حساباً لحفظ المنتجات المفضلة وعرضها.';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get signOut => 'تسجيل الخروج';

  @override
  String get all => 'الكل';

  @override
  String get loadCategoriesFailed => 'فشل تحميل التصنيفات أو المنتجات';

  @override
  String get allProducts => 'جميع المنتجات';

  @override
  String get product => 'منتج';

  @override
  String get searchResultProduct => 'منتج';

  @override
  String get searchResultBrand => 'علامة تجارية';

  @override
  String get searchResultCategory => 'تصنيف';

  @override
  String get searchNoResults => 'لا توجد نتائج.';

  @override
  String get searchStartHint => 'ابحث واكتشف ما تحتاجه';

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
  String get email => 'البريد الإلكتروني';

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
  String get loginSuccess => 'تم تسجيل الدخول بنجاح';

  @override
  String get invalidLoginCredentials => 'رقم الواتساب أو كلمة المرور غير صحيحة';

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
  String get signUpWhatsAppLabel => 'رقم الواتساب';

  @override
  String get signUpWhatsAppHint => '9xx xxx xxx';

  @override
  String get enterWhatsAppNumber => 'أدخل رقم الواتساب';

  @override
  String get invalidWhatsAppShort => 'رقم واتساب غير صالح';

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
  String get enterFirstName => 'أدخل الاسم الأول';

  @override
  String get enterLastName => 'أدخل الاسم الأخير';

  @override
  String get enterEmail => 'أدخل البريد الإلكتروني';

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
  String get unexpectedError => 'خطأ غير متوقع';

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
  String get enterCurrentPassword => 'أدخل كلمة المرور الحالية';

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
  String get profileImageTooLarge => 'يجب أن يكون حجم الصورة 5 ميجابايت أو أقل';

  @override
  String get profileUnsupportedImageType =>
      'نوع الصورة غير مدعوم. يرجى اختيار صورة بصيغة PNG أو JPEG أو JPG أو SVG.';

  @override
  String get skipForNow => 'تخطي الآن';

  @override
  String get authOtpTitle => 'التحقق من الحساب';

  @override
  String authOtpSentTo(String destination) {
    return 'تم إرسال رمز التحقق إلى $destination';
  }

  @override
  String get authOtpVerifySuccess => 'تم التحقق من الحساب بنجاح';

  @override
  String get authOtpVerifyFailed => 'فشل التحقق. يرجى المحاولة مرة أخرى.';

  @override
  String get authOtpCodeLength => 'أدخل رمز التحقق المكوّن من 6 أرقام';

  @override
  String authOtpResendIn(String time) {
    return 'أعد الإرسال مجدداً خلال $time';
  }

  @override
  String get authOtpResendCode => 'إعادة إرسال الرمز';

  @override
  String get authOtpResendSuccess => 'تم إرسال رمز التحقق مجدداً';

  @override
  String get authOtpResendFailed =>
      'فشل إعادة إرسال الرمز. يرجى المحاولة مرة أخرى.';

  @override
  String get yourAccount => 'حسابك';

  @override
  String get profileCity => 'المدينة';

  @override
  String get profileCountry => 'الدولة';

  @override
  String get genderLabel => 'الجنس';

  @override
  String get dateOfBirthLabel => 'تاريخ الميلاد';

  @override
  String get dateOfBirthHint => 'YYYY-MM-DD (اختياري)';

  @override
  String get genderMale => 'ذكر';

  @override
  String get genderFemale => 'أنثى';

  @override
  String get changePhoto => 'تغيير الصورة';

  @override
  String get saveChanges => 'حفظ التعديلات';

  @override
  String get personalInfo => 'معلومات شخصية';

  @override
  String get newPhoneSuccess => 'تم تغيير رقم الجوال بنجاح';

  @override
  String get phoneVerifiedSuccess => 'تم التحقق من رقم الجوال بنجاح';

  @override
  String get confirmPhoneUpdateHint => 'اضغط تأكيد لتحديث رقم الجوال في حسابك';

  @override
  String get confirmChangePhone => 'تأكيد تغيير الرقم';

  @override
  String get changePhoneTitle => 'تغيير رقم الجوال';

  @override
  String get changePhoneIntro => 'أدخل رقم الجوال الجديد';

  @override
  String get changePasswordWithPhoneIntro =>
      'أدخل رقم الجوال للتحقق ثم كلمة المرور الجديدة';

  @override
  String get newPhoneNumber => 'رقم الجوال الجديد';

  @override
  String get enterNewPhoneNumber => 'أدخل رقم الجوال الجديد';

  @override
  String get enterPhoneNumber => 'أدخل رقم الجوال';

  @override
  String get sendCodeViaWhatsApp => 'إرسال الرمز عبر واتساب';

  @override
  String get enterCode4To6 => 'أدخل الرمز المكون من 4-6 أرقام';

  @override
  String get rateTitle => 'تقييم';

  @override
  String get rateQuestion => 'كيف تقيم تجربتك معنا؟';

  @override
  String get submitRating => 'تقييم';

  @override
  String get thanksForRating => 'شكراً لتقييمك';

  @override
  String get ratingComment => 'التعليق';

  @override
  String get ratingCommentHint => 'أخبرنا عن رأيك';

  @override
  String get selectRating => 'يرجى اختيار تقييم';

  @override
  String get loginRequiredForRating => 'يجب تسجيل الدخول لتقييم التطبيق';

  @override
  String get ratingLoginPrompt =>
      'سجّل الدخول أو أنشئ حساباً لمشاركة تجربتك مع التطبيق.';

  @override
  String get size => 'الحجم';

  @override
  String get color => 'اللون';

  @override
  String get dash => '—';

  @override
  String get submit => 'إرسال';

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
  String get continueToHomeTest => 'المتابعة كزائر';

  @override
  String otpSentToPhone(String phone) {
    return 'تم إرسال رمز التحقق إلى $phone';
  }

  @override
  String get searchHint => 'ابحث عن منتجات، تصنيفات...';

  @override
  String get profilePhoto => 'الصورة الشخصية';

  @override
  String get enterFullNameHint => 'أدخل الاسم الكامل';

  @override
  String get enterEmailShort => 'أدخل البريد';

  @override
  String get enterAddressShort => 'أدخل العنوان';

  @override
  String get cityAreaStreet => 'المدينة، الحي، الشارع';

  @override
  String get enterPostalCodeShort => 'أدخل الرمز البريدي';

  @override
  String get saveAndContinue => 'حفظ والدخول';

  @override
  String get associationLinkRequestTitle => 'طلب الربط بالجمعية';

  @override
  String get associationLinkRequestHint =>
      'أدخل بياناتك الشخصية ومعلومات العضوية كما تعرفها لإرسال طلب ربط حسابك بالجمعية.';

  @override
  String get associationLinkPersonalSection => 'البيانات الشخصية';

  @override
  String get associationLinkContactSection => 'معلومات الاتصال والعنوان';

  @override
  String get associationLinkMembershipSection => 'معلومات العضوية';

  @override
  String get associationLinkAttachmentsSection => 'الوثائق والمرفقات';

  @override
  String get associationLinkFirstName => 'اسم الشخص';

  @override
  String get associationLinkKunya => 'الكنية';

  @override
  String get associationLinkFatherName => 'اسم الأب';

  @override
  String get associationLinkMotherName => 'اسم الأم';

  @override
  String get associationLinkNationalId => 'الرقم الوطني';

  @override
  String get associationLinkGovernorate => 'المحافظة';

  @override
  String get associationLinkCity => 'المدينة';

  @override
  String get associationLinkTown => 'البلدة';

  @override
  String get associationLinkVillage => 'القرية';

  @override
  String get associationLinkStreet => 'الشارع';

  @override
  String get associationLinkBuilding => 'البناء';

  @override
  String get associationLinkPermanentAddress => 'العنوان الدائم';

  @override
  String get associationLinkMobile => 'رقم الخلوي المستخدم';

  @override
  String get associationLinkWhatsApp => 'رقم الواتساب';

  @override
  String get associationLinkEmail => 'البريد الإلكتروني';

  @override
  String get associationLinkMembershipNumber => 'رقم العضوية';

  @override
  String get associationLinkPriorityNumber => 'رقم الأفضلية';

  @override
  String get associationLinkProjectName => 'المشروع';

  @override
  String get associationLinkHousingUnit => 'الوحدة السكنية المخصصة';

  @override
  String get associationLinkTotalPayments => 'مجموع المدفوعات';

  @override
  String get associationLinkAttachmentDescription => 'اسم / وصف الوثيقة';

  @override
  String get associationLinkAttachmentType => 'نوع المرفق';

  @override
  String get associationLinkEnterFirstName => 'يرجى إدخال الاسم';

  @override
  String get associationLinkUnsupportedFileType => 'نوع الملف غير مدعوم';

  @override
  String get associationLinkFileTooLarge => 'حجم الملف كبير جداً';

  @override
  String get associationLinkAddAttachment => 'إضافة ملف';

  @override
  String get associationLinkDeleteAttachment => 'حذف';

  @override
  String get associationLinkResubmit => 'إعادة تقديم';

  @override
  String get associationLinkSubmit => 'إرسال الطلب';

  @override
  String get associationLinkRequestSubmitted => 'تم إرسال طلبك بنجاح';

  @override
  String get associationLinkPhoneMustMatchAccount =>
      'رقم الهاتف يجب أن يطابق رقم حسابك';

  @override
  String get associationLinkIncompleteWarning =>
      'بعض الحقول غير مكتملة. يمكنك المتابعة بالحد الأدنى من البيانات.';

  @override
  String get associationLinkSubmittedLocked =>
      'تم إرسال الطلب وهو قيد المعالجة ولا يمكن تعديله.';

  @override
  String get associationLinkNoAttachments =>
      'لم تتم إضافة مرفقات بعد. يُنصح بإرفاق وثائق داعمة.';

  @override
  String get associationRequestedMembershipType => 'نوع العضوية المطلوبة';

  @override
  String get associationMembershipTypeTourism => 'سياحية';

  @override
  String get associationMembershipTypeResidential => 'سكنية';

  @override
  String get associationAdditionalAddresses => 'العناوين الإضافية';

  @override
  String get associationAddress => 'العنوان';

  @override
  String get associationAdditionalAddress => 'عنوان إضافي';

  @override
  String get associationAddAddress => 'إضافة عنوان';

  @override
  String get associationAddCurrentAddress => 'إضافة العنوان الحالي';

  @override
  String get associationStreetNumber => 'رقم الشارع';

  @override
  String get associationAddressLabel => 'تسمية العنوان';

  @override
  String get associationAddressType => 'نوع العنوان';

  @override
  String get associationAddressRequired => 'أضف عنواناً';

  @override
  String get associationDeleteAddress => 'حذف العنوان';

  @override
  String get associationAddressLoadingRequestTypes => 'جاري التحميل';

  @override
  String get associationAddressSelectCapital => 'اختر المحافظة';

  @override
  String get associationAddressLoadingCapitals => 'جاري تحميل المحافظات';

  @override
  String get associationAddressSelectCity => 'اختر المدينة';

  @override
  String get associationAddressLoadingCities => 'جاري تحميل المدن';

  @override
  String get associationAddressSelectTown => 'اختر البلدة';

  @override
  String get associationAddressLoadingTowns => 'جاري تحميل البلدات';

  @override
  String get associationAddressLoadAgain => 'تحميل مرة أخرى';

  @override
  String get verifyPhoneTitle => 'التحقق من رقم الجوال';

  @override
  String codeSentViaWhatsApp(String phone) {
    return 'تم إرسال رمز التحقق إلى $phone عبر واتساب';
  }

  @override
  String get otpPhoneHintSignUp =>
      'أدخل رقم الجوال لاستلام رمز التحقق عبر واتساب';

  @override
  String get otpPhoneHintForgot =>
      'أدخل رقم الجوال المرتبط بحسابك لاستلام رمز التحقق عبر واتساب';

  @override
  String get otpPhoneHintChange =>
      'أدخل رقم الجوال الجديد لاستلام رمز التحقق عبر واتساب';

  @override
  String get introDesc1 =>
      'تطبيق كليفرا منصتك الموحدة لشراء مواد البناء والديكور. تصفح العلامات التجارية والمنتجات والعروض، واطلب ما تحتاجه بسهولة.';

  @override
  String get introDesc2 =>
      'تشكيلة واسعة من الدهانات والسيراميك والحديد والأدوات الصحية والكهربائيات. عروض دورية، توصيل سريع، وخدمة عملاء على مدار الساعة.';

  @override
  String get introDesc3 =>
      'سجّل الآن واحصل على تجربة تسوق مريحة. تتبع طلباتك، احفظ المفضلة، وادفع بكل أمان. نرحب بك في عائلة كليفرا.';

  @override
  String get closeTooltip => 'إغلاق';

  @override
  String get orderDetails => 'تفاصيل الطلب';

  @override
  String get shippingAddress => 'عنوان التوصيل';

  @override
  String get noBrands => 'لا توجد علامات تجارية';

  @override
  String get adsTitle => 'الإعلانات';

  @override
  String get noAds => 'لا توجد إعلانات';

  @override
  String get loginPromptNotifications =>
      'سجّل الدخول أو أنشئ حساباً لاستلام إشعارات الطلبات والعروض.';

  @override
  String get privacyPolicyContent =>
      'سياسة الخصوصية\n\nآخر تحديث: يناير 2024\n\nنحن في كليفرة نحترم خصوصيتك ونلتزم بحماية بياناتك الشخصية. توضح هذه السياسة كيفية جمع واستخدام ومشاركة معلوماتك عند استخدام تطبيقنا.\n\n1. المعلومات التي نجمعها\nنجمع المعلومات التي تقدمها عند التسجيل أو الطلب، مثل الاسم، البريد الإلكتروني، رقم الجوال، والعنوان. كما نجمع تلقائياً بعض البيانات التقنية لتحسين أداء التطبيق.\n\n2. استخدام المعلومات\nنستخدم معلوماتك لمعالجة الطلبات، التواصل معك، تحسين خدماتنا، وإرسال عروض قد تهمك (بموافقتك).\n\n3. حماية البيانات\nنطبق إجراءات أمنية مناسبة لحماية بياناتك من الوصول غير المصرح به أو التسريب.\n\n4. مشاركة المعلومات\nلا نبيع بياناتك الشخصية. قد نشارك معلومات مع شركاء الخدمة (مثل الشحن والدفع) فقط بما يلزم لتنفيذ طلبك.\n\n5. حقوقك\nيمكنك طلب الوصول أو التصحيح أو الحذف لبياناتك عبر التواصل معنا.\n\nلأي استفسار: support@kalivra.com';

  @override
  String get allCategories => 'الكل';

  @override
  String get associationPersonalProfileButton => 'ملف الجمعية الشخصي';

  @override
  String get associationMemberProfileTitle => 'ملف عضو الجمعية';

  @override
  String get associationMemberProfileEmpty =>
      'لا يوجد ملف جمعية مرتبط بعد. يمكنك إرسال طلب ربط لربط حسابك بالجمعية.';

  @override
  String get associationMemberProfileLinkRequest => 'إرسال طلب الربط';

  @override
  String get associationMemberCurrentAddress => 'العنوان الحالي';

  @override
  String get associationMemberMembershipStatus => 'حالة العضوية';

  @override
  String get associationMemberPaymentCommitment => 'التزام الدفع';

  @override
  String get associationMemberPaymentsByYear => 'المدفوعات حسب السنة';

  @override
  String get associationMemberFinancialSummary => 'الملخص المالي';

  @override
  String get associationMemberTotalAmount => 'المبلغ الإجمالي';

  @override
  String get associationMemberPaidAmount => 'المدفوع';

  @override
  String get associationMemberRemainingInstallments => 'الأقساط المتبقية';

  @override
  String get associationMemberInstallments => 'الأقساط';

  @override
  String get associationMemberOtherPayments => 'مدفوعات أخرى';

  @override
  String get associationMemberNotifications => 'الإشعارات';

  @override
  String get associationMemberEvents => 'الفعاليات';

  @override
  String get associationMemberMeasurements => 'القياسات';

  @override
  String get associationMemberAttachments => 'المرفقات';

  @override
  String get associationMemberAmount => 'المبلغ';

  @override
  String get associationMemberDate => 'التاريخ';

  @override
  String get associationMemberStatus => 'الحالة';

  @override
  String get associationMemberNotes => 'ملاحظات';

  @override
  String get associationMemberMethod => 'طريقة الدفع';

  @override
  String get associationMemberBank => 'البنك';

  @override
  String get associationMemberReceipt => 'الإيصال';

  @override
  String get associationMemberType => 'النوع';

  @override
  String get associationMemberTitle => 'العنوان';

  @override
  String get associationMemberRead => 'مقروء';

  @override
  String get associationMemberEvent => 'الفعالية';

  @override
  String get associationMemberLocation => 'الموقع';

  @override
  String get associationMemberValue => 'القيمة';

  @override
  String get associationMemberPayment => 'الدفعة';

  @override
  String get associationMemberUnread => 'غير مقروء';

  @override
  String get associationMemberReadStatus => 'مقروء';

  @override
  String get associationMemberNoData => 'لا توجد بيانات';

  @override
  String get associationMemberLoadFailed => 'تعذر تحميل ملف الجمعية';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get incorrectPassword => 'كلمة المرور خطأ. يرجى إعادة المحاولة.';

  @override
  String get accountNotFound =>
      'الرقم غير موجود، يرجى التأكد من الرقم أو قم بإنشاء حساب.';

  @override
  String get signOutConfirmation => 'هل أنت متأكد من أنك تريد تسجيل الخروج؟';

  @override
  String get loginRequiredTitle => 'تسجيل الدخول مطلوب';

  @override
  String get settingsLoginRequiredDescription =>
      'يرجى تسجيل الدخول لتغيير كلمة المرور أو إعادة تعيين رقم واتساب.';

  @override
  String get areYouSureYouWantToSignIn =>
      'هل أنت متأكد من أنك تريد تسجيل الدخول؟';

  @override
  String get exitAppConfirmation => 'هل تريد الخروج من التطبيق؟';

  @override
  String get exitAppTitle => 'الخروج من التطبيق';

  @override
  String get associationLinkNoData => 'لا توجد بيانات';

  @override
  String get associationSubmittedRequestsTitle => 'الطلبات المرسلة';

  @override
  String get associationNoSubmittedRequests => 'لم تقم بإرسال أي طلبات بعد.';

  @override
  String get associationRequestNumber => 'طلب';

  @override
  String get associationRequestCreatedAt => 'تاريخ الإرسال';

  @override
  String get associationRequestApprovedAt => 'تاريخ القبول';

  @override
  String get associationRequestViewDocument => 'عرض الوثيقة';

  @override
  String get associationRequestStatusPending => 'قيد المراجعة';

  @override
  String get associationRequestStatusApproved => 'مقبول';

  @override
  String get associationRequestStatusRejected => 'مرفوض';

  @override
  String get delete => 'حذف';

  @override
  String get linkRequestsScreen => 'طلبات الإنضمام';

  @override
  String get whatsappNumber => 'رقم الواتساب';

  @override
  String get contactInfo => 'معلومات الاتصال';

  @override
  String get userLocationInfo => 'معلومات العنوان';

  @override
  String get linkRequestSentSuccessfully => 'تم إرسال طلب الربط بالجمعية بنجاح';

  @override
  String get requestSentSuccessfully => 'تم إرسال الطلب بنجاح';

  @override
  String get frequentlyAskedQuestion => 'الأسئلة الأكثر شيوعاً';

  @override
  String get associationContactUs => 'تواصل مع الجمعية';

  @override
  String get associationChatMessageHint => 'اكتب رسالة';

  @override
  String get associationRequestsAndServices => 'طلبات وخدمات';

  @override
  String get associationNewsFeedTitle => 'شريط الأخبار';

  @override
  String get associationNewsFeedImportant => 'هام';

  @override
  String get associationNewsFeedSample1 =>
      'تحديث جدول الدفعات: يرجى مراجعة أحدث مواعيد الاستحقاق الخاصة بالمشروع السكني.';

  @override
  String get associationNewsFeedSample2 =>
      'يستقبل مكتب الجمعية استفسارات الأعضاء من الأحد إلى الخميس، من الساعة 9 صباحاً حتى 2 ظهراً.';

  @override
  String get associationNewsFeedSample3 =>
      'تم توفير ملخص جديد عن تقدم أعمال المرحلة الثانية من المشروع للاطلاع من قبل الأعضاء.';

  @override
  String get associationAnnouncementsTitle => 'البلاغات الرسمية';

  @override
  String get associationAnnouncementsSubtitle =>
      'تابع البلاغات الرسمية وحالة التبليغ والمهل والمرفقات.';

  @override
  String get associationAnnouncementsHint =>
      'اضغط على كارد البلاغ لعرض التفاصيل الرسمية كاملة.';

  @override
  String get associationAnnouncementTotal => 'الإجمالي';

  @override
  String get associationAnnouncementDelivered => 'تم التبليغ';

  @override
  String get associationAnnouncementPending => 'بانتظار التبليغ';

  @override
  String get associationAnnouncementCategory => 'الصنف';

  @override
  String get associationAnnouncementType => 'النوع';

  @override
  String get associationAnnouncementRecipients => 'المستلمون';

  @override
  String get associationAnnouncementDeadline => 'المهلة القانونية';

  @override
  String get associationAnnouncementRelatedEntity => 'الكيان المرتبط';

  @override
  String get associationAnnouncementChannels => 'قنوات التبليغ';

  @override
  String get associationAnnouncementContent => 'محتوى البلاغ';

  @override
  String get associationAnnouncementAttachments => 'المرفقات';

  @override
  String get associationAnnouncementNoAttachments => 'لا توجد مرفقات';

  @override
  String get associationAnnouncementShowDetails => 'عرض التفاصيل';

  @override
  String get associationAnnouncementDetailsTitle => 'تفاصيل البلاغ';

  @override
  String get associationAnnouncementReferenceNumber => 'رقم البلاغ';

  @override
  String get associationAnnouncementDate => 'تاريخ البلاغ';

  @override
  String get associationAnnouncementDeliveredAt => 'وقت التبليغ';

  @override
  String get associationAnnouncementEmptyTitle => 'لا توجد بلاغات';

  @override
  String get associationAnnouncementEmptyDescription =>
      'لا توجد بلاغات رسمية متاحة حالياً.';

  @override
  String get associationAnnouncementCategoryElectronic => 'بلاغ إلكتروني';

  @override
  String get associationAnnouncementCategoryOfficial => 'بلاغ رسمي موثق';

  @override
  String get associationAnnouncementTypePaymentNotice => 'إشعار استحقاق';

  @override
  String get associationAnnouncementTypeMeetingInvitation => 'دعوة اجتماع';

  @override
  String get associationAnnouncementTypeDecisionNotice => 'تبليغ قرار';

  @override
  String get associationAnnouncementChannelInApp => 'داخل التطبيق';

  @override
  String get associationAnnouncementChannelWhatsapp => 'واتساب';

  @override
  String get associationAnnouncementChannelSms => 'رسالة نصية';

  @override
  String get associationAnnouncementChannelEmail => 'البريد الإلكتروني';

  @override
  String get associationAnnouncementNoDeadline => 'لا توجد مهلة قانونية';

  @override
  String get associationAnnouncementSampleTitle1 => 'تذكير بمهلة الدفع';

  @override
  String get associationAnnouncementSampleRecipients1 => 'أعضاء المشروع السكني';

  @override
  String get associationAnnouncementSampleDeadline1 => 'متبقي 10 أيام';

  @override
  String get associationAnnouncementSampleRelated1 => 'مدفوعات المشروع';

  @override
  String get associationAnnouncementSampleContent1 =>
      'يرجى مراجعة جدول الدفعات المستحقة وإتمام الدفع المطلوب قبل انتهاء المهلة القانونية. هذا البلاغ مرتبط بالملف المالي للعضو.';

  @override
  String get associationAnnouncementSampleAttachment1 => 'جدول الدفعات.pdf';

  @override
  String get associationAnnouncementSampleAttachment2 =>
      'نص البلاغ الرسمي.docx';

  @override
  String get associationAnnouncementSampleTitle2 =>
      'دعوة لحضور اجتماع الهيئة العامة';

  @override
  String get associationAnnouncementSampleRecipients2 =>
      'جميع أعضاء الجمعية الفعالين';

  @override
  String get associationAnnouncementSampleDeadline2 =>
      'تاريخ الاجتماع: 2026-07-20';

  @override
  String get associationAnnouncementSampleRelated2 => 'جلسة الهيئة العامة';

  @override
  String get associationAnnouncementSampleContent2 =>
      'تدعوكم الجمعية لحضور اجتماع الهيئة العامة. تجدون جدول الأعمال وتعليمات الحضور ضمن مرفقات هذا البلاغ.';

  @override
  String get associationAnnouncementSampleAttachment3 =>
      'جدول أعمال الاجتماع.pdf';

  @override
  String get associationAnnouncementSampleTitle3 => 'تبليغ بقرار مجلس الإدارة';

  @override
  String get associationAnnouncementSampleRecipients3 =>
      'الأعضاء المرتبطون بالمرحلة الثانية';

  @override
  String get associationAnnouncementSampleRelated3 => 'قرار مجلس الإدارة';

  @override
  String get associationAnnouncementSampleContent3 =>
      'تم نشر قرار مجلس الإدارة للاطلاع عليه. يقدّم هذا البلاغ للتوثيق وإعلام الأعضاء.';

  @override
  String get associationRequestTypeHint => 'اختر نوع الطلب';

  @override
  String get associationRequestTypeOrMessageRequired => 'الحقل مطلوب';

  @override
  String get associationRequestMessageHint => 'أدخل رسالتك';

  @override
  String get chatHistory => 'قائمة المحادثات';

  @override
  String get newChat => 'محادثة جديدة';

  @override
  String get associationChats => 'محادثات الجمعية';

  @override
  String get associationChatsSubtitle =>
      'ابدأ جلسة جديدة أو تابع محادثة سابقة.';

  @override
  String get associationChatsTooltip => 'المحادثات';

  @override
  String get noChatsYet => 'لا توجد محادثات بعد';

  @override
  String chatTitle(int id) {
    return 'محادثة $id';
  }

  @override
  String chatSessionTitle(String id) {
    return 'جلسة $id';
  }

  @override
  String get askAssociation => 'اسأل الجمعية';

  @override
  String get chooseChatOrAskQuestion =>
      'اختر محادثة من السجل أو أرسل سؤالاً جديداً.';

  @override
  String get chatWaitingPreparing => 'يتم تحضير الرد';

  @override
  String get chatWaitingLongTime => 'نعتذر عن التأخير';

  @override
  String get chatWaitingChecking => 'نتحقق من أفضل إجابة';

  @override
  String get chatWaitingAlmostDone => 'شارفنا على الانتهاء، شكراً لانتظارك';

  @override
  String get signUpReadOur => 'اقرأ ';

  @override
  String get signUpAndThe => ' و ';

  @override
  String get phoneNumbers => 'أرقام الهاتف';

  @override
  String get workingHours => 'ساعات العمل';

  @override
  String get country => 'الدولة';

  @override
  String get city => 'المدينة';

  @override
  String get social => 'تواصل اجتماعي';

  @override
  String get status => 'الحالة';

  @override
  String get active => 'نشط';

  @override
  String get inactive => 'غير نشط';

  @override
  String get sortOrder => 'ترتيب العرض';

  @override
  String get about => 'حول';

  @override
  String get contact => 'التواصل';

  @override
  String get location => 'الموقع';

  @override
  String get onlinePresence => 'الحضور الإلكتروني';

  @override
  String get brandDetailsTitle => 'تفاصيل العلامة التجارية';

  @override
  String get gallery => 'المعرض';

  @override
  String get companyDetails => 'تفاصيل الشركة';

  @override
  String get whatCompanyOffers => 'ما تقدمه الشركة';

  @override
  String get additionalDescription => 'وصف إضافي';

  @override
  String get noAdditionalAdDetails => 'لا توجد تفاصيل إضافية لهذا الإعلان';

  @override
  String get sizeAndColor => 'المقاس واللون';

  @override
  String selectedColor(String color) {
    return 'اللون: $color';
  }

  @override
  String stockPieces(int count) {
    return 'المخزون: $count قطعة';
  }

  @override
  String get nothingToShow => 'لا يوجد محتوى للعرض.';

  @override
  String get userBalance => 'رصيد المستخدم';

  @override
  String get associaitionSendLinkRequest => 'إرسال طلب ربط';

  @override
  String get search => 'ابحث';

  @override
  String get fileActionCouldNotOpenFile => 'ØªØ¹Ø°Ø± ÙØªØ­ Ø§Ù„Ù…Ù„Ù';

  @override
  String get fileActionDownloadFile => 'تحميل الملف';

  @override
  String get fileActionDownloadPrompt => 'هل تريد تحميل الملف؟';

  @override
  String get fileActionOpenOnly => 'لا، فتح فقط';

  @override
  String get fileActionDownloadConfirm => 'نعم، تحميل';

  @override
  String get fileActionDownloading => 'جاري تحميل الملف...';

  @override
  String get fileActionSaveFile => 'حفظ الملف';

  @override
  String get fileActionDownloadFailedOpenInstead =>
      'تعذر تحميل الملف، سيتم فتحه فقط';

  @override
  String get noCategoriesAvailable => 'لا توجد تصنيفات متاحة';

  @override
  String get associationMemberRequestAcceptedTitle => 'تم قبول طلبك';

  @override
  String get associationMemberRequestAcceptedMessage =>
      'تم إنشاء ملف شخصي لك لدى الجمعية. ستقوم الجمعية قريباً بإنشاء عضوية لك، وبعدها ستظهر تفاصيل العضوية والمعلومات المالية هنا.';

  @override
  String get associationMemberNoMembershipTitle => 'لا توجد عضوية بعد';

  @override
  String get associationMemberNoMembershipMessage =>
      'لا توجد عضوية جمعية مفعّلة لهذا الحساب حالياً.';

  @override
  String get associationMemberFallbackPersonName => 'العضو';

  @override
  String get associationMemberLinkingRequestAcceptedTitle =>
      'تم قبول طلب الربط';

  @override
  String associationMemberLinkAcceptedMessage(String personName) {
    return 'تم قبول طلب الربط من السيد $personName، وسيتم عرض المعلومات الخاصة بالعضويات الخاصة بك عند الانتهاء من استكمالها.';
  }

  @override
  String associationMemberIndexedMembership(int number) {
    return 'عضوية $number';
  }

  @override
  String get associationMemberPriorityStatus => 'حالة الدور';

  @override
  String get associationMemberMembershipDecision => 'رقم قرار العضوية';

  @override
  String get associationMemberJoinDocuments => 'وثائق الانتساب';

  @override
  String get associationMemberJoinDocument => 'وثيقة انتساب';

  @override
  String get associationMemberClosedAt => 'تاريخ الإغلاق العضوية';

  @override
  String get associationMemberProfileStatus => 'حالة الملف';

  @override
  String get associationMemberStage => 'المرحلة';

  @override
  String get associationMemberMessage => 'الرسالة';

  @override
  String get associationMemberAvailableBalance => 'الرصيد المتاح';

  @override
  String get associationMemberOpenObligations => 'الالتزامات المفتوحة';

  @override
  String get associationMemberFinancialInformation => 'المعلومات المالية';

  @override
  String get associationMemberTotalPayments => 'إجمالي المدفوعات';

  @override
  String get associationMemberTotalObligations => 'إجمالي الالتزامات';

  @override
  String get associationMemberCoveredObligations => 'الالتزامات المغطاة';

  @override
  String get associationMemberUncoveredObligations => 'الالتزامات غير المغطاة';

  @override
  String get associationMemberOpenObligationsCount => 'عدد الالتزامات المفتوحة';

  @override
  String get associationMemberOverdueObligationsCount =>
      'عدد الالتزامات المتأخرة';

  @override
  String get associationMemberOverdueObligationsAmount => 'الالتزامات المتأخرة';

  @override
  String get associationMemberCurrentBalance => 'الرصيد الحالي';

  @override
  String get associationMemberFinancialStatus => 'الحالة المالية';

  @override
  String get associationMemberTotalPaid => 'إجمالي المدفوع';

  @override
  String get associationMemberRemainingAmount => 'المبلغ المتبقي';

  @override
  String get associationMemberPendingObligations => 'الالتزامات المعلقة';

  @override
  String get associationMemberPayments => 'المدفوعات';

  @override
  String get associationMemberNoRecordedPayments =>
      'لا توجد مدفوعات مسجلة حالياً.';

  @override
  String get associationMemberVoucher => 'رقم الإيصال';

  @override
  String get associationMemberFinancialObligations => 'الالتزامات المالية';

  @override
  String get associationMemberNoFinancialObligations =>
      'لا توجد التزامات مالية مسجلة حالياً.';

  @override
  String get associationMemberDue => 'تاريخ الاستحقاق';

  @override
  String get payDate => 'تاريخ الدفع';

  @override
  String get associationMemberDeadline => 'آخر مهلة للدفع';

  @override
  String get associationMemberProjectGallery => 'معرض المشروع';

  @override
  String get associationMemberCompletion => 'نسبة الإنجاز';

  @override
  String get associationMemberCompletionPercentage => 'نسبة الإنجاز';

  @override
  String get associationMemberSubtitle => 'الوصف';

  @override
  String get associationMemberProjectMasterPlan => 'مخطط المشروع';

  @override
  String get associationMemberProjectMasterPlanFile => 'مخطط المشروع';

  @override
  String get associationMemberBuildings => 'عدد الأبنية';

  @override
  String get associationMemberTotalUnits => 'إجمالي الوحدات';

  @override
  String get associationMemberAvailableUnits => 'الوحدات المتاحة';

  @override
  String get associationMemberAllocatedUnits => 'الوحدات المخصصة';

  @override
  String get associationMemberDeliveredUnits => 'الوحدات المسلمة';

  @override
  String get associationMemberRemainingUnits => 'الوحدات المتبقية';

  @override
  String get associationMemberEstimatedCost => 'الكلفة التقديرية';

  @override
  String get associationMemberEngineer => 'المهندس';

  @override
  String get associationMemberLandArea => 'مساحة الأرض';

  @override
  String get associationMemberProjectLocation => 'موقع المشروع';

  @override
  String get associationMemberOpenGoogleMaps => 'فتح في خرائط Google';

  @override
  String get associationMemberBuildingGallery => 'معرض البناء';

  @override
  String get associationMemberBuildingNumber => 'رقم البناء';

  @override
  String get associationMemberDescription => 'الوصف';

  @override
  String get associationMemberBuildingPlan => 'مخطط البناء';

  @override
  String get associationMemberBuildingPlanFile => 'مخطط البناء';

  @override
  String get associationMemberFloors => 'عدد الطوابق';

  @override
  String get associationMemberUnits => 'عدد الوحدات';

  @override
  String get associationMemberSpecifications => 'المواصفات';

  @override
  String get associationMemberUnitGallery => 'معرض الوحدة';

  @override
  String get associationMemberFloor => 'الطابق';

  @override
  String get associationMemberOrientation => 'الاتجاه';

  @override
  String get associationMemberArea => 'المساحة';

  @override
  String get associationMemberGardenTerraceArea => 'مساحة الحديقة / التراس';

  @override
  String get associationMemberUnitPlan => 'مخطط الوحدة';

  @override
  String get associationMemberUnitPlanFile => 'مخطط الوحدة';

  @override
  String get associationMemberStages => 'مراحل التنفيذ';

  @override
  String get associationMemberProjectBuildings => 'الأبنية ضمن المشروع';

  @override
  String get associationMemberProgress => 'الإنجاز';

  @override
  String get associationMemberAssignedToProject => 'مخصص لمشروع';

  @override
  String get associationMemberNoProjectAssignment => 'غير مخصص لمشروع';

  @override
  String get associationMemberAssignedToUnit => 'مخصص لوحدة';

  @override
  String get associationMemberNoUnitAssignment => 'غير مخصص لوحدة';

  @override
  String get associationMemberProjectLocationOpenFailed =>
      'تعذر فتح موقع المشروع';

  @override
  String get contactHelpTitle => 'كيف يمكننا مساعدتك؟';

  @override
  String contactAvailableNumbers(int count) {
    return '$count أرقام متاحة';
  }

  @override
  String get contactWhatsAppTitle => 'واتساب';

  @override
  String get contactSocialMediaTitle => 'وسائل التواصل';

  @override
  String contactAvailableLinks(int count) {
    return '$count روابط متاحة';
  }

  @override
  String contactWorkingDays(int count) {
    return '$count أيام';
  }

  @override
  String get contactLoadingInfo => 'جاري تحميل معلومات التواصل';

  @override
  String get contactOpenLinkFailed => 'تعذر فتح الرابط';
}
