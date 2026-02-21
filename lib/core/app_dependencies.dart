import 'package:kalivra/controllers/blocs/cubit/auth_cubit/auth_cubit.dart';
import 'package:kalivra/controllers/blocs/cubit/cart_cubit/cart_cubit.dart';
import 'package:kalivra/controllers/blocs/cubit/checkout_cubit/checkout_cubit.dart';
import 'package:kalivra/controllers/blocs/cubit/orders_cubit/orders_cubit.dart';
import 'package:kalivra/controllers/blocs/cubit/products_cubit/products_cubit.dart';
import 'package:kalivra/controllers/blocs/cubit/notifications_cubit/notifications_cubit.dart';
import 'package:kalivra/controllers/blocs/cubit/wishlist_cubit/wishlist_cubit.dart';
import 'package:kalivra/core/network/dio_client.dart';
import 'package:kalivra/controllers/prefs/pref_keys.dart';
import 'package:kalivra/services/api/category_api_service.dart';
import 'package:kalivra/services/api/checkout_api_service.dart';
import 'package:kalivra/services/api/customer_api_service.dart';
import 'package:kalivra/services/api/order_api_service.dart';
import 'package:kalivra/services/api/product_api_service.dart';
import 'package:kalivra/services/api/wishlist_api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Holds DioClient, API services, and BLoCs. Create once in main.
class AppDependencies {
  AppDependencies._({
    required this.prefs,
    required this.dio,
    required this.customerApiService,
    required this.categoryApiService,
    required this.productApiService,
    required this.orderApiService,
    required this.wishlistApiService,
    required this.checkoutApiService,
    required this.authCubit,
    required this.cartCubit,
    required this.productsCubit,
    required this.ordersCubit,
    required this.wishlistCubit,
    required this.checkoutCubit,
    required this.notificationsCubit,
  });

  final SharedPreferences prefs;
  final DioClient dio;
  final CustomerApiService customerApiService;
  final CategoryApiService categoryApiService;
  final ProductApiService productApiService;
  final OrderApiService orderApiService;
  final WishlistApiService wishlistApiService;
  final CheckoutApiService checkoutApiService;
  final AuthCubit authCubit;
  final CartCubit cartCubit;
  final ProductsCubit productsCubit;
  final OrdersCubit ordersCubit;
  final WishlistCubit wishlistCubit;
  final CheckoutCubit checkoutCubit;
  final NotificationsCubit notificationsCubit;

  static Future<AppDependencies> create() async {
    final prefs = await SharedPreferences.getInstance();
    final dio = DioClient(
      getToken: () async => prefs.getString(PrefKeys.accessTokenKey),
    );
    final customerApiService = CustomerApiService(dio);
    final categoryApiService = CategoryApiService(dio);
    final productApiService = ProductApiService(dio);
    final orderApiService = OrderApiService(dio);
    final wishlistApiService = WishlistApiService(dio);
    final checkoutApiService = CheckoutApiService(dio);

    final authCubit = AuthCubit(customerApiService: customerApiService, prefs: prefs);
    final cartCubit = CartCubit(authCubit);
    final productsCubit = ProductsCubit(
      categoryApiService: categoryApiService,
      productApiService: productApiService,
    );
    final ordersCubit = OrdersCubit(orderApiService);
    final wishlistCubit = WishlistCubit(wishlistApiService);
    final checkoutCubit = CheckoutCubit(checkoutApiService);
    final notificationsCubit = NotificationsCubit(authCubit);

    return AppDependencies._(
      prefs: prefs,
      dio: dio,
      customerApiService: customerApiService,
      categoryApiService: categoryApiService,
      productApiService: productApiService,
      orderApiService: orderApiService,
      wishlistApiService: wishlistApiService,
      checkoutApiService: checkoutApiService,
      authCubit: authCubit,
      cartCubit: cartCubit,
      productsCubit: productsCubit,
      ordersCubit: ordersCubit,
      wishlistCubit: wishlistCubit,
      checkoutCubit: checkoutCubit,
      notificationsCubit: notificationsCubit,
    );
  }
}
