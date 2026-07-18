import 'package:kalivra/model/product/product_model.dart';

class WishlistApiModel {
  const WishlistApiModel({
    required this.id,
    required this.product,
    required this.options,
  });

  final int id;
  final ProductModel product;
  final List<Map<String, dynamic>> options;

  factory WishlistApiModel.fromJson(Map<String, dynamic> json) {
    return WishlistApiModel(
      id: json['id'] as int,
      product: ProductModel.fromJson(json['product'] as Map<String, dynamic>),
      options: (json['options'] as List? ?? [])
          .whereType<Map<String, dynamic>>()
          .toList(),
    );
  }
}
