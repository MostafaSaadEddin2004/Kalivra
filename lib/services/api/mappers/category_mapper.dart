import 'package:flutter/material.dart';
import 'package:kalivra/models/category_model.dart';
import 'package:kalivra/models/api/category_api_model.dart';

/// Maps API category to app CategoryModel. Icon is default (API has no icon).
class CategoryMapper {
  CategoryMapper._();

  static const IconData _defaultIcon = Icons.category_rounded;

  static CategoryModel fromApi(CategoryApiModel api) {
    return CategoryModel(
      id: api.id.toString(),
      name: api.name,
      icon: _defaultIcon,
    );
  }
}
