class OrderLineItem {
  const OrderLineItem({
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    this.imageUrl,
  });

  final String productName;
  final int quantity;
  final double unitPrice;
  final String? imageUrl;

  double get total => quantity * unitPrice;

  factory OrderLineItem.fromJson(Map<String, dynamic> json) {
    return OrderLineItem(
      productName: _text(json['productName'] ?? json['name']),
      quantity: _asInt(json['quantity'] ?? json['qty_ordered']) ?? 0,
      unitPrice: _asDouble(json['unitPrice'] ?? json['price']) ?? 0,
      imageUrl: _nullableText(json['imageUrl'] ?? json['image_url']),
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
  final String? shippingAddress;
  final String? paymentMethod;

  String get displayId => incrementId.isNotEmpty ? incrementId : id;

  String get displayStatus => statusLabel.isNotEmpty ? statusLabel : status;

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
      shippingAddress: _nullableText(json['shippingAddress']),
      paymentMethod: _nullableText(json['paymentMethod']),
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
