/// GET /api/shop/v1/categories – product categories.
class CategoryApiModel {
  const CategoryApiModel({
    required this.id,
    required this.name,
    this.slug,
    this.description,
    this.imageUrl,
    this.parentId,
    this.children,
    this.productCount,
  });

  final int id;
  final String name;
  final String? slug;
  final String? description;
  final String? imageUrl;
  final int? parentId;
  final List<CategoryApiModel>? children;
  final int? productCount;

  factory CategoryApiModel.fromJson(Map<String, dynamic> json) {
    return CategoryApiModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String?,
      description: json['description'] as String?,
      imageUrl: json['image_url'] as String? ?? json['logo_url'] as String?,
      parentId: json['parent_id'] as int?,
      children: (json['children'] as List<dynamic>?)
          ?.map((e) => CategoryApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      productCount: json['product_count'] as int?,
    );
  }
}
