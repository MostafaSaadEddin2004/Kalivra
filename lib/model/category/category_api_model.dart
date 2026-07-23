class CategoryApiModel {
  const CategoryApiModel({
    required this.id,
    required this.name,
    this.slug,
    this.description,
    this.imageUrl,
    this.logo,
    this.banner,
    this.parentId,
    this.children,
    this.productCount,
  });

  final int id;
  final String name;
  final String? slug;
  final String? description;
  final String? imageUrl;
  final CategoryImageModel? logo;
  final CategoryImageModel? banner;
  final int? parentId;
  final List<CategoryApiModel>? children;
  final int? productCount;

  factory CategoryApiModel.fromJson(Map<String, dynamic> json) {
    final logo = CategoryImageModel.fromJsonOrNull(json['logo']);
    final banner = CategoryImageModel.fromJsonOrNull(json['banner']);

    return CategoryApiModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String?,
      description: json['description'] as String?,
      imageUrl:
          json['image_url'] as String? ??
          json['logo_url'] as String? ??
          logo?.preferredUrl,
      logo: logo,
      banner: banner,
      parentId: (json['parent_id'] as num?)?.toInt(),
      children: (json['children'] as List<dynamic>?)
          ?.map((e) => CategoryApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      productCount: (json['product_count'] as num?)?.toInt(),
    );
  }
}

class CategoryImageModel {
  const CategoryImageModel({
    this.smallImageUrl,
    this.mediumImageUrl,
    this.largeImageUrl,
    this.originalImageUrl,
  });

  final String? smallImageUrl;
  final String? mediumImageUrl;
  final String? largeImageUrl;
  final String? originalImageUrl;

  String? get preferredUrl =>
      mediumImageUrl ?? smallImageUrl ?? originalImageUrl ?? largeImageUrl;

  static CategoryImageModel? fromJsonOrNull(dynamic json) {
    if (json is! Map<String, dynamic>) {
      return null;
    }

    return CategoryImageModel(
      smallImageUrl: json['small_image_url'] as String?,
      mediumImageUrl: json['medium_image_url'] as String?,
      largeImageUrl: json['large_image_url'] as String?,
      originalImageUrl: json['original_image_url'] as String?,
    );
  }
}
