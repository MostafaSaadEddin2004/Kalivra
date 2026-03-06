import 'package:kalivra/core/auth/token_service.dart';
import 'package:kalivra/core/network/dio_client.dart';
import 'package:kalivra/model/services/api/category_api_service.dart';
import 'package:kalivra/model/services/api/checkout_api_service.dart';
import 'package:kalivra/model/services/api/customer_api_service.dart';
import 'package:kalivra/model/services/api/order_api_service.dart';
import 'package:kalivra/model/services/api/product_api_service.dart';
import 'package:kalivra/model/services/api/wishlist_api_service.dart';

/// Global access to the single [DioClient] and API services. Set once at startup.
class AppLocator {
  AppLocator._();

  static DioClient? _dio;
  static CustomerApiService? _customerApiService;
  static CategoryApiService? _categoryApiService;
  static ProductApiService? _productApiService;
  static OrderApiService? _orderApiService;
  static WishlistApiService? _wishlistApiService;
  static CheckoutApiService? _checkoutApiService;

  static void init({
    required DioClient dio,
    required CustomerApiService customerApiService,
    required CategoryApiService categoryApiService,
    required ProductApiService productApiService,
    required OrderApiService orderApiService,
    required WishlistApiService wishlistApiService,
    required CheckoutApiService checkoutApiService,
  }) {
    _dio = dio;
    _customerApiService = customerApiService;
    _categoryApiService = categoryApiService;
    _productApiService = productApiService;
    _orderApiService = orderApiService;
    _wishlistApiService = wishlistApiService;
    _checkoutApiService = checkoutApiService;
  }

  /// Creates [DioClient] (using [TokenService.getToken]) and all API services,
  /// then registers them. Call after [TokenService.init] in main.
  static Future<void> initAsync() async {
    final dio = DioClient(getToken: TokenService.getToken);
    init(
      dio: dio,
      customerApiService: CustomerApiService(dio),
      categoryApiService: CategoryApiService(dio),
      productApiService: ProductApiService(dio),
      orderApiService: OrderApiService(dio),
      wishlistApiService: WishlistApiService(dio),
      checkoutApiService: CheckoutApiService(dio),
    );
  }

  static DioClient get dio =>
      _dio ?? (throw StateError('AppLocator not initialized. Call init() in main.'));
  static CustomerApiService get customerApiService =>
      _customerApiService ?? (throw StateError('AppLocator not initialized.'));
  static CategoryApiService get categoryApiService =>
      _categoryApiService ?? (throw StateError('AppLocator not initialized.'));
  static ProductApiService get productApiService =>
      _productApiService ?? (throw StateError('AppLocator not initialized.'));
  static OrderApiService get orderApiService =>
      _orderApiService ?? (throw StateError('AppLocator not initialized.'));
  static WishlistApiService get wishlistApiService =>
      _wishlistApiService ?? (throw StateError('AppLocator not initialized.'));
  static CheckoutApiService get checkoutApiService =>
      _checkoutApiService ?? (throw StateError('AppLocator not initialized.'));
}
