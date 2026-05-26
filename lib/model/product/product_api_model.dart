class Product {
  final int id;
  final String sku;
  final String name;
  final String? description;
  final String urlKey;
  final ProductImage? baseImage;
  final List<ProductImage> images;
  final bool isNew;
  final bool isFeatured;
  final bool onSale;
  final bool isSaleable;
  final bool isWishlist;
  final String? minPrice;
  final ProductPrices? prices;
  final ProductRatings ratings;
  final ProductReviews reviews;

  Product({
    required this.id,
    required this.sku,
    required this.name,
    this.description,
    required this.urlKey,
    this.baseImage,
    required this.images,
    required this.isNew,
    required this.isFeatured,
    required this.onSale,
    required this.isSaleable,
    required this.isWishlist,
    this.minPrice,
    this.prices,
    required this.ratings,
    required this.reviews,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      sku: json['sku'] as String,
      name: json['name'] as String,
      description: json['description'],
      urlKey: json['url_key'],
      baseImage: ProductImage.fromJson(
        json['base_image']
      ),
      images: (json['images'] as List)
          .map((e) => ProductImage.fromJson(e))
          .toList(),
      isNew: json['is_new'] as bool? ?? false,
      isFeatured: json['is_featured'] as bool? ?? false,
      onSale: json['on_sale'] as bool? ?? false,
      isSaleable: json['is_saleable'] as bool? ?? false,
      isWishlist: json['is_wishlist'] as bool? ?? false,
      minPrice: json['min_price'] as String?,
      prices: ProductPrices.fromJson(json['prices']),
      ratings: ProductRatings.fromJson(
        json['ratings']
      ),
      reviews: ProductReviews.fromJson(
        json['reviews']
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'sku': sku,
    'name': name,
    'description': description,
    'url_key': urlKey,
    'base_image': baseImage?.toJson(),
    'images': images.map((e) => e.toJson()).toList(),
    'is_new': isNew,
    'is_featured': isFeatured,
    'on_sale': onSale,
    'is_saleable': isSaleable,
    'is_wishlist': isWishlist,
    'min_price': minPrice,
    'prices': prices?.toJson(),
    'ratings': ratings.toJson(),
    'reviews': reviews.toJson(),
  };
}

class ProductImage {
  final String? smallImageUrl;
  final String? mediumImageUrl;
  final String? largeImageUrl;
  final String? originalImageUrl;

  ProductImage({
    this.smallImageUrl,
    this.mediumImageUrl,
    this.largeImageUrl,
    this.originalImageUrl,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      smallImageUrl: json['small_image_url'],
      mediumImageUrl: json['medium_image_url'],
      largeImageUrl: json['large_image_url'],
      originalImageUrl: json['original_image_url'],
    );
  }

  Map<String, dynamic> toJson() => {
    'small_image_url': smallImageUrl,
    'medium_image_url': mediumImageUrl,
    'large_image_url': largeImageUrl,
    'original_image_url': originalImageUrl,
  };
}

class ProductPrices {
  final PriceDetail? regular;
  final PriceDetail? final_;

  ProductPrices({this.regular, this.final_});

  factory ProductPrices.fromJson(Map<String, dynamic> json) {
    return ProductPrices(
      regular: PriceDetail.fromJson(json['regular']),
      final_: PriceDetail.fromJson(json['final']),
    );
  }

  Map<String, dynamic> toJson() => {
    'regular': regular?.toJson(),
    'final': final_?.toJson(),
  };
}

class PriceDetail {
  final String? price;
  final String? formattedPrice;

  PriceDetail({this.price, this.formattedPrice});

  factory PriceDetail.fromJson(Map<String, dynamic> json) {
    return PriceDetail(
      price: json['price'],
      formattedPrice: json['formatted_price'],
    );
  }

  Map<String, dynamic> toJson() => {
    'price': price,
    'formatted_price': formattedPrice,
  };
}

class ProductRatings {
  final String average;
  final int total;

  ProductRatings({required this.average, required this.total});

  factory ProductRatings.fromJson(Map<String, dynamic> json) {
    return ProductRatings(
      average: json['average'] ?? '0.0',
      total: json['total']?? 0,
    );
  }

  Map<String, dynamic> toJson() => {'average': average, 'total': total};
}

class ProductReviews {
  final int total;

  ProductReviews({required this.total});

  factory ProductReviews.fromJson(Map<String, dynamic> json) {
    return ProductReviews(total: json['total']?? 0);
  }

  Map<String, dynamic> toJson() => {'total': total};
}
