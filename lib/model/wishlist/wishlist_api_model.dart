/// GET /api/shop/v1/wishlist – wishlist item (product in wishlist).
class WishlistApiModel {
  const WishlistApiModel({
    required this.id,
    this.productId,
    this.customerId,
    this.product,
    this.createdAt,
  });

  final int id;
  final int? productId;
  final int? customerId;
  final Map<String, dynamic>? product;
  final String? createdAt;

  factory WishlistApiModel.fromJson(Map<String, dynamic> json) {
    return WishlistApiModel(
      id: json['id'] as int,
      productId: json['product_id'] as int?,
      customerId: json['customer_id'] as int?,
      product: json['product'] as Map<String, dynamic>?,
      createdAt: json['created_at'] as String?,
    );
  }
}
