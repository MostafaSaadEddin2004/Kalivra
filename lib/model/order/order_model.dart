class OrderLineItem {
  const OrderLineItem({
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    this.sku,
    this.lineTotal,
    this.formattedPrice,
    this.formattedTotal,
    this.imageUrl,
  });

  final String productName;
  final int quantity;
  final double unitPrice;
  final String? sku;
  final double? lineTotal;
  final String? formattedPrice;
  final String? formattedTotal;
  final String? imageUrl;

  double get total => lineTotal ?? quantity * unitPrice;

  factory OrderLineItem.fromJson(Map<String, dynamic> json) {
    return OrderLineItem(
      productName: _text(json['productName'] ?? json['name']),
      quantity: _asInt(json['quantity'] ?? json['qty_ordered']) ?? 0,
      unitPrice: _asDouble(json['unitPrice'] ?? json['price']) ?? 0,
      sku: _nullableText(json['sku']),
      lineTotal: _asDouble(json['total']),
      formattedPrice: _nullableText(json['formatted_price']),
      formattedTotal: _nullableText(json['formatted_total']),
      imageUrl: _nullableText(json['imageUrl'] ?? json['image_url']),
    );
  }
}

class OrderAddressModel {
  const OrderAddressModel({
    this.firstName,
    this.lastName,
    this.companyName,
    this.address,
    this.city,
    this.state,
    this.country,
    this.postcode,
    this.email,
    this.phone,
    this.vatId,
  });

  final String? firstName;
  final String? lastName;
  final String? companyName;
  final String? address;
  final String? city;
  final String? state;
  final String? country;
  final String? postcode;
  final String? email;
  final String? phone;
  final String? vatId;

  String get fullName => [
    firstName,
    lastName,
  ].where((part) => part != null && part.isNotEmpty).join(' ');

  String get locationLine => [
    address,
    city,
    state,
    postcode,
    country,
  ].where((part) => part != null && part.isNotEmpty).join(', ');

  bool get hasData =>
      fullName.isNotEmpty ||
      locationLine.isNotEmpty ||
      (email?.isNotEmpty ?? false) ||
      (phone?.isNotEmpty ?? false) ||
      (companyName?.isNotEmpty ?? false) ||
      (vatId?.isNotEmpty ?? false);

  factory OrderAddressModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const OrderAddressModel();
    return OrderAddressModel(
      firstName: _nullableText(json['first_name'] ?? json['firstName']),
      lastName: _nullableText(json['last_name'] ?? json['lastName']),
      companyName: _nullableText(json['company_name'] ?? json['companyName']),
      address: _nullableText(json['address']),
      city: _nullableText(json['city']),
      state: _nullableText(json['state']),
      country: _nullableText(json['country']),
      postcode: _nullableText(json['postcode']),
      email: _nullableText(json['email']),
      phone: _nullableText(json['phone']),
      vatId: _nullableText(json['vat_id'] ?? json['vatId']),
    );
  }
}

class OrderModel {
  const OrderModel({
    required this.id,
    required this.date,
    required this.status,
    required this.subtotal,
    required this.deliveryCost,
    required this.total,
    required this.items,
    this.orderId,
    this.incrementId = '',
    this.statusLabel = '',
    this.formattedGrandTotal = '',
    this.currencyCode = '',
    this.createdAt,
    this.shippingAddress,
    this.billingAddress,
    this.paymentMethod,
  });

  final int? orderId;
  final String id;
  final String incrementId;
  final String date;
  final String status;
  final String statusLabel;
  final double subtotal;
  final double deliveryCost;
  final double total;
  final String formattedGrandTotal;
  final String currencyCode;
  final DateTime? createdAt;
  final List<OrderLineItem> items;
  final OrderAddressModel? shippingAddress;
  final OrderAddressModel? billingAddress;
  final String? paymentMethod;

  String get displayId => incrementId.isNotEmpty ? incrementId : id;

  String get displayStatus => statusLabel.isNotEmpty ? statusLabel : status;

  double get itemSubtotal => items.fold(0, (sum, item) => sum + item.total);

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final orderId = _asInt(json['id']);
    final incrementId = _text(json['increment_id']);
    final rawCreatedAt = _text(json['created_at'] ?? json['date']);
    final grandTotal = _asDouble(json['grand_total'] ?? json['total']) ?? 0;
    final items = json['items'];

    return OrderModel(
      orderId: orderId,
      id: incrementId.isNotEmpty ? incrementId : _text(json['id']),
      incrementId: incrementId,
      date: rawCreatedAt,
      status: _text(json['status']),
      statusLabel: _text(json['status_label']),
      subtotal: _asDouble(json['subtotal'] ?? json['sub_total']) ?? grandTotal,
      deliveryCost:
          _asDouble(json['deliveryCost'] ?? json['shipping_amount']) ?? 0,
      total: grandTotal,
      formattedGrandTotal: _text(json['formatted_grand_total']),
      currencyCode: _text(json['order_currency_code']),
      createdAt: DateTime.tryParse(rawCreatedAt),
      items: items is List
          ? items
                .whereType<Map>()
                .map(
                  (e) => OrderLineItem.fromJson(Map<String, dynamic>.from(e)),
                )
                .toList()
          : const [],
      shippingAddress: OrderAddressModel.fromJson(
        _asMap(json['shipping_address'] ?? json['shippingAddress']),
      ),
      billingAddress: OrderAddressModel.fromJson(
        _asMap(json['billing_address'] ?? json['billingAddress']),
      ),
      paymentMethod: _nullableText(
        json['payment_title'] ??
            json['payment_method_title'] ??
            json['paymentMethod'],
      ),
    );
  }
}

String _text(dynamic value) {
  if (value == null) return '';
  return value.toString().trim();
}

String? _nullableText(dynamic value) {
  final text = _text(value);
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

Map<String, dynamic>? _asMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return null;
}
