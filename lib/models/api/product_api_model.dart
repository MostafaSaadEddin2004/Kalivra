/// GET /api/shop/v1/products, GET /api/shop/v1/products/{id} – product list and detail.
class ProductApiModel {
  const ProductApiModel({
    required this.id,
    required this.name,
    required this.type,
    this.sku,
    this.price,
    this.specialPrice,
    this.formattedPrice,
    this.shortDescription,
    this.description,
    this.urlKey,
    this.images,
    this.videos,
    this.inventories,
    this.quantity,
    this.categoryId,
    this.categoryName,
    this.attributes,
    this.attributeOptions,
    this.reviews,
  });

  final int id;
  final String name;
  final String type;
  final String? sku;
  final double? price;
  final double? specialPrice;
  final String? formattedPrice;
  final String? shortDescription;
  final String? description;
  final String? urlKey;
  final List<ProductImageApiModel>? images;
  final List<Map<String, dynamic>>? videos;
  final List<Map<String, dynamic>>? inventories;
  final int? quantity;
  final int? categoryId;
  final String? categoryName;
  final Map<String, dynamic>? attributes;
  final Map<String, dynamic>? attributeOptions;
  final List<Map<String, dynamic>>? reviews;

  factory ProductApiModel.fromJson(Map<String, dynamic> json) {
    return ProductApiModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      type: json['type'] as String? ?? 'simple',
      sku: json['sku'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      specialPrice: (json['special_price'] as num?)?.toDouble(),
      formattedPrice: json['formatted_price'] as String?,
      shortDescription: json['short_description'] as String?,
      description: json['description'] as String?,
      urlKey: json['url_key'] as String?,
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => ProductImageApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      videos: (json['videos'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      inventories: (json['inventories'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      quantity: json['quantity'] as int?,
      categoryId: json['category_id'] as int?,
      categoryName: json['category_name'] as String?,
      attributes: json['attributes'] as Map<String, dynamic>?,
      attributeOptions: json['attribute_options'] as Map<String, dynamic>?,
      reviews: (json['reviews'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
    );
  }
}

class ProductImageApiModel {
  const ProductImageApiModel({
    this.id,
    this.url,
    this.path,
    this.alt,
  });

  final int? id;
  final String? url;
  final String? path;
  final String? alt;

  factory ProductImageApiModel.fromJson(Map<String, dynamic> json) {
    return ProductImageApiModel(
      id: json['id'] as int?,
      url: json['url'] as String?,
      path: json['path'] as String?,
      alt: json['alt'] as String?,
    );
  }
}
