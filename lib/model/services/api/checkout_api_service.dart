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

  Future<CheckoutSummaryModel> saveAddresses({
    required Map<String, dynamic> billing,
    required Map<String, dynamic> shipping,
  }) async {
    final res = await _client.post(
      'checkout/onepage/addresses',
      data: {
        'billing': billing,
        'shipping': shipping,
      },
    );
    final data = res.data;
    if (data is Map<String, dynamic>) {
      return CheckoutSummaryModel.fromJson(data);
    }
    return getSummary();
  }

  Future<CheckoutSummaryModel> saveShippingMethod(String shippingMethod) async {
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

  Future<CheckoutSummaryModel> savePaymentMethod(String paymentMethod) async {
    final res = await _client.post(
      'checkout/onepage/payment-methods',
      data: {'payment': paymentMethod},
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
