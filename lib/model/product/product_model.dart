import 'package:flutter/material.dart';

class ProductColorOption {
  const ProductColorOption({required this.name, required this.color});

  final String name;
  final Color color;
}

class ProductModel {
  const ProductModel({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.price,
    this.imagePath,
    this.imageUrls,
    required this.unit,
    this.salePrice,
    required this.quantity,
    this.brandId,
    this.colors,
    this.sizes,
  });

  final String id;
  final String name;
  final String categoryId;
  final double price;
  final String? brandId;
  final String? imagePath;
  final List<String>? imageUrls;
  final String unit;
  final double? salePrice;
  final int quantity;
  final List<ProductColorOption>? colors;
  final List<String>? sizes;

  List<String> get effectiveImageUrls {
    if (imageUrls != null && imageUrls!.isNotEmpty) return imageUrls!;
    if (imagePath != null && imagePath!.isNotEmpty) return [imagePath!];
    return [];
  }
}
