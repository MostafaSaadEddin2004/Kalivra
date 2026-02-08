import 'package:flutter/material.dart';

/// Represents a product category for the categories tab bar and filtering.
class CategoryModel {
  const CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
  });

  final String id;
  final String name;
  final IconData icon;
}
