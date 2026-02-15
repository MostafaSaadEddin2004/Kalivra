import 'package:flutter/material.dart';

/// A color option for a product (e.g. "أحمر", Color(0xFF...)).
class ProductColorOption {
  const ProductColorOption({required this.name, required this.color});

  final String name;
  final Color color;
}

/// Represents a product displayed in the app.
/// [quantity] is the maximum orderable quantity (e.g. available stock).
class ProductModel {
  const ProductModel({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.price,
    this.imagePath,
    this.imageUrls,
    this.unit = 'قطعة',
    this.salePrice,
    this.quantity = 10,
    this.brandId,
    this.colors,
    this.sizes,
  });

  final String id;
  final String name;
  final String categoryId;
  final double price;
  /// Optional brand id; used to show products on brand details screen.
  final String? brandId;
  final String? imagePath;
  /// Multiple image URLs or asset paths for gallery. If null, [imagePath] is used as single image.
  final List<String>? imageUrls;
  final String unit;
  final double? salePrice;
  /// Maximum quantity that can be ordered (e.g. available stock). Defaults to 10.
  final int quantity;
  /// Available color options for this product.
  final List<ProductColorOption>? colors;
  /// Available size options (e.g. ['S', 'M', 'L']).
  final List<String>? sizes;

  /// Effective list of image URLs/paths for the gallery (imageUrls, or [imagePath] if set).
  List<String> get effectiveImageUrls {
    if (imageUrls != null && imageUrls!.isNotEmpty) return imageUrls!;
    if (imagePath != null && imagePath!.isNotEmpty) return [imagePath!];
    return [];
  }
}
