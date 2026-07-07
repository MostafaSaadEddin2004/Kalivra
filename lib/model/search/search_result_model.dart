import 'package:kalivra/model/brand/brand_model.dart';
import 'package:kalivra/model/category/category_api_model.dart';
import 'package:kalivra/model/product/product_model.dart';

class SearchResultModel {
  const SearchResultModel({
    required this.products,
    required this.brands,
    required this.categories,
  });

  final List<ProductModel> products;
  final List<BrandModel> brands;
  final List<CategoryApiModel> categories;

  bool get isEmpty => products.isEmpty && brands.isEmpty && categories.isEmpty;

  factory SearchResultModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};

    return SearchResultModel(
      products: _sectionItems(
        data['products'],
      ).map((e) => ProductModel.fromJson(e)).toList(),
      brands: _sectionItems(
        data['brands'],
      ).map((e) => BrandModel.fromJson(e)).toList(),
      categories: _sectionItems(
        data['categories'],
      ).map((e) => CategoryApiModel.fromJson(e)).toList(),
    );
  }

  static List<Map<String, dynamic>> _sectionItems(dynamic section) {
    if (section is! Map<String, dynamic>) {
      return [];
    }

    final data = section['data'];
    if (data is! List) {
      return [];
    }

    return data
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }
}
