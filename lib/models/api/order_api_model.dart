/// GET /api/shop/v1/orders, GET /api/shop/v1/orders/{id} – order list and detail.
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
      id: json['id'] as int,
      incrementId: json['increment_id'] as String?,
      status: json['status'] as String?,
      statusLabel: json['status_label'] as String?,
      channelName: json['channel_name'] as String?,
      isGuest: json['is_guest'] as bool?,
      customerEmail: json['customer_email'] as String?,
      customerFirstName: json['customer_first_name'] as String?,
      customerLastName: json['customer_last_name'] as String?,
      customerPhone: json['customer_phone'] as String?,
      shippingMethod: json['shipping_method'] as String?,
      shippingTitle: json['shipping_title'] as String?,
      paymentTitle: json['payment_title'] as String?,
      formattedGrandTotal: json['formatted_grand_total'] as String?,
      grandTotal: (json['grand_total'] as num?)?.toDouble(),
      subTotal: (json['sub_total'] as num?)?.toDouble(),
      taxAmount: (json['tax_amount'] as num?)?.toDouble(),
      discountAmount: (json['discount_amount'] as num?)?.toDouble(),
      shippingAmount: (json['shipping_amount'] as num?)?.toDouble(),
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => OrderItemApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      shippingAddress: json['shipping_address'] as Map<String, dynamic>?,
      billingAddress: json['billing_address'] as Map<String, dynamic>?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
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
      id: json['id'] as int,
      sku: json['sku'] as String?,
      name: json['name'] as String?,
      type: json['type'] as String?,
      quantity: json['quantity'] as int?,
      price: (json['price'] as num?)?.toDouble(),
      total: (json['total'] as num?)?.toDouble(),
      formattedPrice: json['formatted_price'] as String?,
      formattedTotal: json['formatted_total'] as String?,
      productId: json['product_id'] as int?,
      imageUrl: json['image_url'] as String?,
    );
  }
}
