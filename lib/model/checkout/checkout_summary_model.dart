import 'package:kalivra/model/cart/cart_api_model.dart';

class CheckoutSummaryModel {
  const CheckoutSummaryModel({
    this.cart,
    this.shippingMethods = const [],
    this.paymentMethods = const [],
    this.raw = const {},
  });

  final CartApiModel? cart;
  final List<CheckoutShippingMethodModel> shippingMethods;
  final List<CheckoutPaymentMethodModel> paymentMethods;
  final Map<String, dynamic> raw;

  factory CheckoutSummaryModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    CartApiModel? cart;
    final cartJson = data['cart'];
    if (cartJson is Map<String, dynamic>) {
      cart = CartApiModel.fromJson(cartJson);
    }

    return CheckoutSummaryModel(
      cart: cart,
      shippingMethods: parseShippingMethods(data),
      paymentMethods: _parsePaymentMethods(data),
      raw: data,
    );
  }

  static List<CheckoutShippingMethodModel> parseShippingMethods(
    Map<String, dynamic> data,
  ) {
    final nestedData = data['data'];
    final methods =
        data['shipping_methods'] ??
        data['shippingMethods'] ??
        (nestedData is Map ? nestedData['shipping_methods'] : null) ??
        (nestedData is Map ? nestedData['shippingMethods'] : null);
    if (methods is! List) return const [];

    final result = <CheckoutShippingMethodModel>[];
    for (final item in methods.whereType<Map>()) {
      final methodGroup = Map<String, dynamic>.from(item);
      final rates = methodGroup['rates'];
      if (rates is List) {
        for (final rate in rates.whereType<Map>()) {
          result.add(
            CheckoutShippingMethodModel.fromJson(
              Map<String, dynamic>.from(rate),
            ),
          );
        }
      } else {
        result.add(CheckoutShippingMethodModel.fromJson(methodGroup));
      }
    }
    return result;
  }

  static List<CheckoutPaymentMethodModel> _parsePaymentMethods(
    Map<String, dynamic> data,
  ) {
    final methods = data['payment_methods'] ?? data['paymentMethods'];
    if (methods is! List) return const [];

    return methods
        .whereType<Map>()
        .map(
          (e) =>
              CheckoutPaymentMethodModel.fromJson(Map<String, dynamic>.from(e)),
        )
        .toList();
  }
}

class CheckoutShippingMethodModel {
  const CheckoutShippingMethodModel({
    required this.method,
    required this.title,
    this.description,
    this.formattedPrice,
    this.price,
  });

  final String method;
  final String title;
  final String? description;
  final String? formattedPrice;
  final double? price;

  factory CheckoutShippingMethodModel.fromJson(Map<String, dynamic> json) {
    return CheckoutShippingMethodModel(
      method: (json['method'] ?? json['code'] ?? '').toString(),
      title:
          (json['method_title'] ??
                  json['carrier_title'] ??
                  json['title'] ??
                  json['method'] ??
                  json['code'] ??
                  '')
              .toString(),
      description:
          json['method_description']?.toString() ??
          json['description']?.toString(),
      formattedPrice:
          json['formatted_price']?.toString() ??
          json['base_formatted_price']?.toString(),
      price:
          (json['price'] as num?)?.toDouble() ??
          (json['base_price'] as num?)?.toDouble(),
    );
  }
}

class CheckoutPaymentMethodModel {
  const CheckoutPaymentMethodModel({
    required this.method,
    required this.title,
    this.description,
  });

  final String method;
  final String title;
  final String? description;

  factory CheckoutPaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return CheckoutPaymentMethodModel(
      method: (json['method'] ?? json['code'] ?? '').toString(),
      title:
          (json['method_title'] ??
                  json['title'] ??
                  json['method'] ??
                  json['code'] ??
                  '')
              .toString(),
      description:
          json['method_description']?.toString() ??
          json['description']?.toString(),
    );
  }
}
