/// GET /api/shop/v1/cart – cart and cart items.
class CartApiModel {
  const CartApiModel({
    this.id,
    this.customerId,
    this.guestCheckout,
    this.items,
    this.itemsCount,
    this.itemQuantity,
    this.subTotal,
    this.taxTotal,
    this.discountAmount,
    this.grandTotal,
    this.formattedSubTotal,
    this.formattedTaxTotal,
    this.formattedDiscountAmount,
    this.formattedGrandTotal,
    this.couponCode,
  });

  final String? id;
  final int? customerId;
  final bool? guestCheckout;
  final List<CartItemApiModel>? items;
  final int? itemsCount;
  final int? itemQuantity;
  final double? subTotal;
  final double? taxTotal;
  final double? discountAmount;
  final double? grandTotal;
  final String? formattedSubTotal;
  final String? formattedTaxTotal;
  final String? formattedDiscountAmount;
  final String? formattedGrandTotal;
  final String? couponCode;

  factory CartApiModel.fromJson(Map<String, dynamic> json) {
    return CartApiModel(
      id: json['id'] as String?,
      customerId: json['customer_id'] as int?,
      guestCheckout: json['guest_checkout'] as bool?,
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => CartItemApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      itemsCount: json['items_count'] as int?,
      itemQuantity: json['item_quantity'] as int?,
      subTotal: (json['sub_total'] as num?)?.toDouble(),
      taxTotal: (json['tax_total'] as num?)?.toDouble(),
      discountAmount: (json['discount_amount'] as num?)?.toDouble(),
      grandTotal: (json['grand_total'] as num?)?.toDouble(),
      formattedSubTotal: json['formatted_sub_total'] as String?,
      formattedTaxTotal: json['formatted_tax_total'] as String?,
      formattedDiscountAmount: json['formatted_discount_amount'] as String?,
      formattedGrandTotal: json['formatted_grand_total'] as String?,
      couponCode: json['coupon_code'] as String?,
    );
  }
}

class CartItemApiModel {
  const CartItemApiModel({
    required this.id,
    this.quantity,
    this.sku,
    this.name,
    this.price,
    this.total,
    this.formattedPrice,
    this.formattedTotal,
    this.productId,
    this.product,
    this.options,
  });

  final int id;
  final int? quantity;
  final String? sku;
  final String? name;
  final double? price;
  final double? total;
  final String? formattedPrice;
  final String? formattedTotal;
  final int? productId;
  final Map<String, dynamic>? product;
  final List<Map<String, dynamic>>? options;

  factory CartItemApiModel.fromJson(Map<String, dynamic> json) {
    return CartItemApiModel(
      id: json['id'] as int,
      quantity: json['quantity'] as int?,
      sku: json['sku'] as String?,
      name: json['name'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      total: (json['total'] as num?)?.toDouble(),
      formattedPrice: json['formatted_price'] as String?,
      formattedTotal: json['formatted_total'] as String?,
      productId: json['product_id'] as int?,
      product: json['product'] as Map<String, dynamic>?,
      options: (json['options'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
    );
  }
}
