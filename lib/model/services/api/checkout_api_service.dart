import 'package:kalivra/core/network/dio_client.dart';
import 'package:kalivra/model/checkout/checkout_summary_model.dart';

class CheckoutApiService {
  CheckoutApiService();

  final DioClient _client = DioClient();

  Future<CheckoutSummaryModel> getSummary() async {
    final res = await _client.get('checkout/onepage/summary');
    final data = res.data;
    if (data is Map<String, dynamic>) {
      return CheckoutSummaryModel.fromJson(data);
    }
    return const CheckoutSummaryModel();
  }

  Future<CheckoutSummaryModel> storeAddresses({
    required String firstName,
    required String lasttName,
    required String email,
    required String address,
    required String country,
    required String state,
    required String city,
    required String postcode,
    required String phone,
  }) async {
    final addressLines = [address];
    final res = await _client.post(
      'checkout/onepage/addresses',
      data: {
        'billing': {
          'first_name': firstName,
          'last_name': lasttName,
          'email': email,
          'address': addressLines,
          'country': country,
          'state': state,
          'city': city,
          'postcode': postcode,
          'phone': phone,
        },
        'shipping': {
          'first_name': firstName,
          'last_name': lasttName,
          'email': email,
          'address': addressLines,
          'country': country,
          'state': state,
          'city': city,
          'postcode': postcode,
          'phone': phone,
        },
      },
    );
    final data = res.data;
    if (data is Map<String, dynamic>) {
      return CheckoutSummaryModel.fromJson(data);
    }
    return getSummary();
  }

  Future<CheckoutSummaryModel> storeShippingMethod(
    String shippingMethod,
  ) async {
    final res = await _client.post(
      'checkout/onepage/shipping-methods',
      data: {'shipping_method': shippingMethod},
    );
    final data = res.data;
    if (data is Map<String, dynamic>) {
      return CheckoutSummaryModel.fromJson(data);
    }
    return getSummary();
  }

  Future<List<CheckoutShippingMethodModel>> getShippingMethods() async {
    final res = await _client.get('checkout/onepage/shipping-methods');
    final data = res.data;
    if (data is Map<String, dynamic>) {
      return CheckoutSummaryModel.parseShippingMethods(data);
    }
    return const [];
  }

  Future<CheckoutSummaryModel> storePaymentMethod(String paymentMethod) async {
    final res = await _client.post(
      'checkout/onepage/payment-methods',
      data: {
        'payment': {'method': paymentMethod},
      },
    );
    final data = res.data;
    if (data is Map<String, dynamic>) {
      return CheckoutSummaryModel.fromJson(data);
    }
    return getSummary();
  }

  Future<Map<String, dynamic>?> placeOrder() async {
    final res = await _client.post('checkout/onepage/orders');
    final data = res.data;
    if (data is Map<String, dynamic>) {
      return data;
    }
    return null;
  }
}
