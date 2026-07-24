/// GET /api/shop/v1/cart response wrapper and cart data.
class CartApiResponseModel {
  const CartApiResponseModel({required this.success, this.cart});

  final bool success;
  final CartApiModel? cart;

  factory CartApiResponseModel.fromJson(Map<String, dynamic> json) {
    final data = _asMap(json['data']);
    return CartApiResponseModel(
      success: _asBool(json['success']) ?? false,
      cart: data == null
          ? null
          : CartApiModel.fromJson(data, success: json['success']),
    );
  }
}

class CartApiModel {
  const CartApiModel({
    this.success,
    this.id,
    this.customerId,
    this.guestCheckout,
    this.items = const [],
    this.itemsCount,
    this.itemQuantity,
    this.appliedTaxes,
    this.taxTotal,
    this.formattedTaxTotal,
    this.subTotalInclTax,
    this.subTotal,
    this.formattedSubTotalInclTax,
    this.formattedSubTotal,
    this.couponCode,
    this.discountAmount,
    this.formattedDiscountAmount,
    this.shippingMethod,
    this.shippingAmount,
    this.formattedShippingAmount,
    this.shippingAmountInclTax,
    this.formattedShippingAmountInclTax,
    this.grandTotal,
    this.formattedGrandTotal,
    this.billingAddress,
    this.shippingAddress,
    this.haveStockableItems,
    this.paymentMethod,
    this.paymentMethodTitle,
  });

  final bool? success;
  final int? id;
  final int? customerId;
  final bool? guestCheckout;
  final List<CartItemApiModel> items;
  final int? itemsCount;
  final int? itemQuantity;
  final Map<String, String>? appliedTaxes;
  final double? taxTotal;
  final String? formattedTaxTotal;
  final double? subTotalInclTax;
  final double? subTotal;
  final String? formattedSubTotalInclTax;
  final String? formattedSubTotal;
  final String? couponCode;
  final double? discountAmount;
  final String? formattedDiscountAmount;
  final String? shippingMethod;
  final double? shippingAmount;
  final String? formattedShippingAmount;
  final double? shippingAmountInclTax;
  final String? formattedShippingAmountInclTax;
  final double? grandTotal;
  final String? formattedGrandTotal;
  final Map<String, dynamic>? billingAddress;
  final Map<String, dynamic>? shippingAddress;
  final bool? haveStockableItems;
  final String? paymentMethod;
  final String? paymentMethodTitle;

  factory CartApiModel.fromJson(Map<String, dynamic> json, {dynamic success}) {
    return CartApiModel(
      success: _asBool(success),
      id: _asInt(json['id']),
      customerId: _asInt(json['customer_id']),
      guestCheckout:
          _asBool(json['guest_checkout']) ?? _asBool(json['is_guest']),
      items: (json['items'] as List? ?? const [])
          .whereType<Map>()
          .map((e) => CartItemApiModel.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      itemsCount: _asInt(json['items_count']),
      itemQuantity: _asInt(json['item_quantity'] ?? json['items_qty']),
      appliedTaxes: _asStringMap(json['applied_taxes']),
      taxTotal: _asDouble(json['tax_total']),
      formattedTaxTotal: json['formatted_tax_total'] as String?,
      subTotalInclTax: _asDouble(json['sub_total_incl_tax']),
      subTotal: _asDouble(json['sub_total']),
      formattedSubTotalInclTax: json['formatted_sub_total_incl_tax'] as String?,
      formattedSubTotal: json['formatted_sub_total'] as String?,
      couponCode: json['coupon_code'] as String?,
      discountAmount: _asDouble(json['discount_amount']),
      formattedDiscountAmount: json['formatted_discount_amount'] as String?,
      shippingMethod: json['shipping_method'] as String?,
      shippingAmount: _asDouble(json['shipping_amount']),
      formattedShippingAmount: json['formatted_shipping_amount'] as String?,
      shippingAmountInclTax: _asDouble(json['shipping_amount_incl_tax']),
      formattedShippingAmountInclTax:
          json['formatted_shipping_amount_incl_tax'] as String?,
      grandTotal: _asDouble(json['grand_total']),
      formattedGrandTotal: json['formatted_grand_total'] as String?,
      billingAddress: _asMap(json['billing_address']),
      shippingAddress: _asMap(json['shipping_address']),
      haveStockableItems: _asBool(json['have_stockable_items']),
      paymentMethod: json['payment_method'] as String?,
      paymentMethodTitle: json['payment_method_title'] as String?,
    );
  }
}

class CartItemApiModel {
  const CartItemApiModel({
    required this.id,
    this.quantity,
    this.type,
    this.sku,
    this.name,
    this.price,
    this.priceInclTax,
    this.total,
    this.totalInclTax,
    this.discountAmount,
    this.formattedPrice,
    this.formattedPriceInclTax,
    this.formattedTotal,
    this.formattedTotalInclTax,
    this.formattedDiscountAmount,
    this.baseImage,
    this.productUrlKey,
    this.productId,
    this.product,
    this.options = const [],
    this.canChangeQty,
  });

  final int id;
  final int? quantity;
  final String? type;
  final String? sku;
  final String? name;
  final double? price;
  final double? priceInclTax;
  final double? total;
  final double? totalInclTax;
  final double? discountAmount;
  final String? formattedPrice;
  final String? formattedPriceInclTax;
  final String? formattedTotal;
  final String? formattedTotalInclTax;
  final String? formattedDiscountAmount;
  final CartItemImageApiModel? baseImage;
  final String? productUrlKey;
  final int? productId;
  final Map<String, dynamic>? product;
  final List<CartItemOptionApiModel> options;
  final bool? canChangeQty;

  String? get imageUrl =>
      baseImage?.largeImageUrl ??
      baseImage?.mediumImageUrl ??
      baseImage?.smallImageUrl ??
      baseImage?.originalImageUrl;

  CartItemOptionApiModel? get colorOption => _findOption(_isColorAttribute);

  CartItemOptionApiModel? get sizeOption => _findOption(_isSizeAttribute);

  CartItemOptionApiModel? _findOption(bool Function(String value) test) {
    for (final option in options) {
      final name = option.attributeName?.trim();
      if (name != null && test(name)) return option;
    }
    return null;
  }

  factory CartItemApiModel.fromJson(Map<String, dynamic> json) {
    final baseImage = CartItemImageApiModel.fromJson(
      _asMap(json['base_image']),
    );
    final productId =
        _asInt(json['product_id']) ?? _extractProductIdFromImage(baseImage);
    final product =
        _asMap(json['product']) ??
        _productFromCartItem(json, productId: productId, baseImage: baseImage);

    return CartItemApiModel(
      id: _asInt(json['id']) ?? 0,
      quantity: _asInt(json['quantity']),
      type: json['type'] as String?,
      sku: json['sku'] as String?,
      name: json['name'] as String?,
      price: _asDouble(json['price']),
      priceInclTax: _asDouble(json['price_incl_tax']),
      total: _asDouble(json['total']),
      totalInclTax: _asDouble(json['total_incl_tax']),
      discountAmount: _asDouble(json['discount_amount']),
      formattedPrice: json['formatted_price'] as String?,
      formattedPriceInclTax: json['formatted_price_incl_tax'] as String?,
      formattedTotal: json['formatted_total'] as String?,
      formattedTotalInclTax: json['formatted_total_incl_tax'] as String?,
      formattedDiscountAmount: json['formatted_discount_amount'] as String?,
      baseImage: baseImage,
      productUrlKey: json['product_url_key'] as String?,
      productId: productId ?? _asInt(product['id']),
      product: product,
      options: (json['options'] as List? ?? const [])
          .whereType<Map>()
          .map(
            (e) =>
                CartItemOptionApiModel.fromJson(Map<String, dynamic>.from(e)),
          )
          .toList(),
      canChangeQty: _asBool(json['can_change_qty']),
    );
  }
}

class CartItemImageApiModel {
  const CartItemImageApiModel({
    this.smallImageUrl,
    this.mediumImageUrl,
    this.largeImageUrl,
    this.originalImageUrl,
  });

  final String? smallImageUrl;
  final String? mediumImageUrl;
  final String? largeImageUrl;
  final String? originalImageUrl;

  factory CartItemImageApiModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const CartItemImageApiModel();
    return CartItemImageApiModel(
      smallImageUrl: json['small_image_url'] as String?,
      mediumImageUrl: json['medium_image_url'] as String?,
      largeImageUrl: json['large_image_url'] as String?,
      originalImageUrl: json['original_image_url'] as String?,
    );
  }

  Map<String, dynamic> toProductImageJson() => {
    'small_image_url': smallImageUrl,
    'medium_image_url': mediumImageUrl,
    'large_image_url': largeImageUrl,
    'original_image_url': originalImageUrl,
  };
}

class CartItemOptionApiModel {
  const CartItemOptionApiModel({
    this.attributeName,
    this.optionId,
    this.optionLabel,
  });

  final String? attributeName;
  final int? optionId;
  final String? optionLabel;

  factory CartItemOptionApiModel.fromJson(Map<String, dynamic> json) {
    return CartItemOptionApiModel(
      attributeName: json['attribute_name'] as String?,
      optionId: _asInt(json['option_id']),
      optionLabel: json['option_label'] as String?,
    );
  }
}

int? _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

double? _asDouble(dynamic value) {
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
  if (value is Map) return Map<String, dynamic>.from(value);
  return null;
}

Map<String, String>? _asStringMap(dynamic value) {
  if (value is! Map) return null;
  return value.map((key, value) => MapEntry(key.toString(), value.toString()));
}

bool _isColorAttribute(String value) {
  final normalized = value.toLowerCase().trim();
  return normalized == 'color' ||
      normalized == 'colour' ||
      normalized.contains('color') ||
      normalized.contains('colour') ||
      normalized.contains('اللون');
}

bool _isSizeAttribute(String value) {
  final normalized = value.toLowerCase().trim();
  return normalized == 'size' ||
      normalized.contains('size') ||
      normalized.contains('الحجم') ||
      normalized.contains('المقاس');
}

int? _extractProductIdFromImage(CartItemImageApiModel image) {
  final url =
      image.originalImageUrl ??
      image.largeImageUrl ??
      image.mediumImageUrl ??
      image.smallImageUrl;
  if (url == null) return null;
  final match = RegExp(r'/product/(\d+)/').firstMatch(url);
  return match == null ? null : int.tryParse(match.group(1)!);
}

Map<String, dynamic> _productFromCartItem(
  Map<String, dynamic> json, {
  int? productId,
  required CartItemImageApiModel baseImage,
}) {
  final name = json['name']?.toString() ?? '';
  final price = json['price']?.toString() ?? '0';
  final formattedPrice = json['formatted_price'] as String?;
  final imageJson = baseImage.toProductImageJson();

  return {
    'id': productId ?? _asInt(json['id']) ?? 0,
    'sku': json['sku']?.toString() ?? '',
    'name': name,
    'url_key': json['product_url_key']?.toString() ?? name,
    'base_image': imageJson,
    'images': [imageJson],
    'prices': {
      'regular': {'price': price, 'formatted_price': formattedPrice},
    },
    'ratings': const {'average': '0.0', 'total': 0},
    'reviews': const {'total': 0},
  };
}
