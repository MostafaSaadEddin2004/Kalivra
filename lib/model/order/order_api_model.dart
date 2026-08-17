/// GET /api/customer/orders, GET /api/shop/v1/orders/{id} - order list and detail.
class OrderApiModel {
  const OrderApiModel({
    required this.id,
    this.incrementId,
    this.status,
    this.statusLabel,
    this.channelName,
    this.isGuest,
    this.customerEmail,
    this.customerFirstName,
    this.customerLastName,
    this.customerPhone,
    this.shippingMethod,
    this.shippingTitle,
    this.paymentTitle,
    this.formattedGrandTotal,
    this.grandTotal,
    this.subTotal,
    this.taxAmount,
    this.discountAmount,
    this.shippingAmount,
    this.items,
    this.shippingAddress,
    this.billingAddress,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final String? incrementId;
  final String? status;
  final String? statusLabel;
  final String? channelName;
  final bool? isGuest;
  final String? customerEmail;
  final String? customerFirstName;
  final String? customerLastName;
  final String? customerPhone;
  final String? shippingMethod;
  final String? shippingTitle;
  final String? paymentTitle;
  final String? formattedGrandTotal;
  final double? grandTotal;
  final double? subTotal;
  final double? taxAmount;
  final double? discountAmount;
  final double? shippingAmount;
  final List<OrderItemApiModel>? items;
  final Map<String, dynamic>? shippingAddress;
  final Map<String, dynamic>? billingAddress;
  final String? createdAt;
  final String? updatedAt;

  factory OrderApiModel.fromJson(Map<String, dynamic> json) {
    return OrderApiModel(
      id: _asInt(json['id']) ?? 0,
      incrementId: _nullableText(json['increment_id']),
      status: _nullableText(json['status']),
      statusLabel: _nullableText(json['status_label']),
      channelName: _nullableText(json['channel_name']),
      isGuest: _asBool(json['is_guest']),
      customerEmail: _nullableText(json['customer_email']),
      customerFirstName: _nullableText(json['customer_first_name']),
      customerLastName: _nullableText(json['customer_last_name']),
      customerPhone: _nullableText(json['customer_phone']),
      shippingMethod: _nullableText(json['shipping_method']),
      shippingTitle: _nullableText(json['shipping_title']),
      paymentTitle: _nullableText(json['payment_title']),
      formattedGrandTotal: _nullableText(json['formatted_grand_total']),
      grandTotal: _asDouble(json['grand_total']),
      subTotal: _asDouble(json['sub_total']),
      taxAmount: _asDouble(json['tax_amount']),
      discountAmount: _asDouble(json['discount_amount']),
      shippingAmount: _asDouble(json['shipping_amount']),
      items: (json['items'] as List<dynamic>?)
          ?.whereType<Map>()
          .map((e) => OrderItemApiModel.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      shippingAddress: _asMap(json['shipping_address']),
      billingAddress: _asMap(json['billing_address']),
      createdAt: _nullableText(json['created_at']),
      updatedAt: _nullableText(json['updated_at']),
    );
  }
}

class OrderItemApiModel {
  const OrderItemApiModel({
    required this.id,
    this.sku,
    this.name,
    this.type,
    this.quantity,
    this.price,
    this.total,
    this.formattedPrice,
    this.formattedTotal,
    this.productId,
    this.imageUrl,
  });

  final int id;
  final String? sku;
  final String? name;
  final String? type;
  final int? quantity;
  final double? price;
  final double? total;
  final String? formattedPrice;
  final String? formattedTotal;
  final int? productId;
  final String? imageUrl;

  factory OrderItemApiModel.fromJson(Map<String, dynamic> json) {
    return OrderItemApiModel(
      id: _asInt(json['id']) ?? 0,
      sku: _nullableText(json['sku']),
      name: _nullableText(json['name']),
      type: _nullableText(json['type']),
      quantity: _asInt(json['quantity']),
      price: _asDouble(json['price']),
      total: _asDouble(json['total']),
      formattedPrice: _nullableText(json['formatted_price']),
      formattedTotal: _nullableText(json['formatted_total']),
      productId: _asInt(json['product_id']),
      imageUrl: _nullableText(json['image_url']),
    );
  }
}

String? _nullableText(dynamic value) {
  if (value == null) return null;
  final text = value.toString().trim();
  return text.isEmpty ? null : text;
}

int? _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

double? _asDouble(dynamic value) {
  if (value is double) return value;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

bool? _asBool(dynamic value) {
  if (value is bool) return value;
  if (value is num) return value != 0;
  if (value is String) {
    final normalized = value.toLowerCase().trim();
    if (normalized == 'true' || normalized == '1') return true;
    if (normalized == 'false' || normalized == '0') return false;
  }
  return null;
}

Map<String, dynamic>? _asMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return null;
}
