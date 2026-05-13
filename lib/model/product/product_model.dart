import 'package:flutter/material.dart';

/// Swatch + label for the color selector UI.
class ProductColorOption {
  const ProductColorOption({
    required this.name,
    required this.color,
    this.optionId,
  });

  final String name;
  final Color color;
  final int? optionId;
}

class ProductModel {
  const ProductModel({
    required this.id,
    required this.sku,
    required this.type,
    required this.name,
    this.urlKey,
    this.price,
    this.formattedPrice,
    this.shortDescription,
    this.description,
    this.images,
    this.videos,
    this.baseImage,
    this.reviews,
    this.inStock,
    this.isSaved,
    this.isItemInCart,
    this.showQuantityChanger,
    this.currencyOptions,
    this.specialPrice,
    this.formattedSpecialPrice,
    this.regularPrice,
    this.formattedRegularPrice,
    this.createdAt,
    this.updatedAt,
    this.variants,
    this.superAttributes = const <SuperAttributeLite>[],
  });

  final int id;
  final String sku;
  final String type;
  final String name;
  final String? urlKey;

  final double? price;
  final String? formattedPrice;
  final String? shortDescription;
  final String? description;

  /// Primary gallery block (API returns a single object here).
  final ProductImageBlock? images;
  final ProductVideoBlock? videos;
  final ProductBaseImageBlock? baseImage;

  final ProductReviewsSummary? reviews;

  final bool? inStock;
  final bool? isSaved;
  final bool? isItemInCart;
  final bool? showQuantityChanger;

  final CurrencyOptions? currencyOptions;

  final double? specialPrice;
  final String? formattedSpecialPrice;
  final double? regularPrice;
  final String? formattedRegularPrice;

  final String? createdAt;
  final String? updatedAt;

  final ProductVariantLite? variants;

  /// Parsed from `super_attributes` (single object or list).
  final List<SuperAttributeLite> superAttributes;

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int,
      sku: json['sku'] as String? ?? '',
      type: json['type'] as String? ?? 'simple',
      name: json['name'] as String? ?? '',
      urlKey: json['url_key'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      formattedPrice: json['formatted_price'] as String?,
      shortDescription: json['short_description'] as String?,
      description: json['description'] as String?,
      images: _mapOrNull(json['images'], ProductImageBlock.fromJson),
      videos: _mapOrNull(json['videos'], ProductVideoBlock.fromJson),
      baseImage: _mapOrNull(json['base_image'], ProductBaseImageBlock.fromJson),
      reviews: _mapOrNull(json['reviews'], ProductReviewsSummary.fromJson),
      inStock: json['in_stock'] as bool?,
      isSaved: json['is_saved'] as bool?,
      isItemInCart: json['is_item_in_cart'] as bool?,
      showQuantityChanger: json['show_quantity_changer'] as bool?,
      currencyOptions: _mapOrNull(json['currency_options'], CurrencyOptions.fromJson),
      specialPrice: (json['special_price'] as num?)?.toDouble(),
      formattedSpecialPrice: json['formatted_special_price'] as String?,
      regularPrice: (json['regular_price'] as num?)?.toDouble(),
      formattedRegularPrice: json['formatted_regular_price'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      variants: _mapOrNull(json['variants'], ProductVariantLite.fromJson),
      superAttributes: _parseSuperAttributesList(json['super_attributes']),
    );
  }

  /// Colors from the super attribute whose `code` is color-like (or name hints).
  List<ProductColorOption> get selectableColors {
    final opts = _optionsForColorAttribute();
    final out = <ProductColorOption>[];
    for (final o in opts) {
      final label = (o.label ?? o.adminName ?? '').trim();
      if (label.isEmpty) continue;
      out.add(ProductColorOption(
        name: label,
        color: _colorForOption(o),
        optionId: o.id,
      ));
    }
    return out;
  }

  /// Size labels from the super attribute whose `code` is size-like.
  List<String> get selectableSizes {
    final opts = _optionsForSizeAttribute();
    final labels = opts
        .map((o) => (o.label ?? o.adminName ?? '').trim())
        .where((s) => s.isNotEmpty)
        .toList();
    if (labels.isNotEmpty) return labels;
    final sid = variants?.size;
    if (sid != null) return ['$sid'];
    return const [];
  }

  bool get hasSelectableColors => selectableColors.isNotEmpty;
  bool get hasSelectableSizes => selectableSizes.isNotEmpty;

  List<SuperAttributeOptionLite> _optionsForColorAttribute() {
    for (final a in superAttributes) {
      if (_isColorAttribute(a)) return a.options;
    }
    return const [];
  }

  List<SuperAttributeOptionLite> _optionsForSizeAttribute() {
    for (final a in superAttributes) {
      if (_isSizeAttribute(a)) return a.options;
    }
    return const [];
  }

  static bool _isColorAttribute(SuperAttributeLite a) {
    final c = (a.code ?? '').toLowerCase();
    final n = (a.name ?? '').toLowerCase();
    return c == 'color' ||
        c == 'colour' ||
        n.contains('color') ||
        n.contains('لون');
  }

  static bool _isSizeAttribute(SuperAttributeLite a) {
    final c = (a.code ?? '').toLowerCase();
    final n = (a.name ?? '').toLowerCase();
    return c == 'size' || n.contains('size') || n.contains('مقاس');
  }

  Color _colorForOption(SuperAttributeOptionLite o) {
    final hex = _parseHexColor(o.swatchValue);
    if (hex != null) return hex;
    return _colorFromName(o.label ?? o.adminName ?? '');
  }

  static Color? _parseHexColor(String? raw) {
    if (raw == null) return null;
    var s = raw.trim();
    if (s.isEmpty) return null;
    if (s.startsWith('#')) s = s.substring(1);
    if (s.length == 6) {
      final v = int.tryParse(s, radix: 16);
      if (v != null) return Color(0xFF000000 | v);
    }
    if (s.length == 8) {
      final v = int.tryParse(s, radix: 16);
      if (v != null) return Color(v);
    }
    return null;
  }

  static Color _colorFromName(String label) {
    final k = label.toLowerCase().trim();
    const map = <String, Color>{
      'red': Colors.red,
      'black': Colors.black,
      'white': Colors.white,
      'blue': Colors.blue,
      'green': Colors.green,
      'yellow': Colors.amber,
      'orange': Colors.orange,
      'pink': Colors.pink,
      'purple': Colors.purple,
      'grey': Colors.grey,
      'gray': Colors.grey,
      'brown': Colors.brown,
    };
    return map[k] ?? Colors.grey.shade400;
  }

  static List<SuperAttributeLite> _parseSuperAttributesList(dynamic raw) {
    if (raw == null) return const [];
    if (raw is List) {
      return raw
          .whereType<Map>()
          .map((e) => SuperAttributeLite.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
    if (raw is Map<String, dynamic>) {
      return [SuperAttributeLite.fromJson(raw)];
    }
    return const [];
  }

  /// Effective line to show in the gallery (prefer explicit image URLs, else base).
  List<String> get displayImageUrls {
    final urls = <String?>[
      images?.largeImageUrl ?? images?.originalImageUrl ?? images?.url,
      baseImage?.largeImageUrl ?? baseImage?.originalImageUrl,
    ].whereType<String>().where((u) => u.isNotEmpty).toList();
    return urls.toSet().toList();
  }

  static T? _mapOrNull<T>(
    dynamic raw,
    T Function(Map<String, dynamic>) f,
  ) {
    if (raw is Map<String, dynamic>) return f(raw);
    return null;
  }
}

class ProductImageBlock {
  const ProductImageBlock({
    this.id,
    this.url,
    this.originalImageUrl,
    this.smallImageUrl,
    this.mediumImageUrl,
    this.largeImageUrl,
    this.productId,
    this.position,
  });

  final int? id;
  final String? url;
  final String? originalImageUrl;
  final String? smallImageUrl;
  final String? mediumImageUrl;
  final String? largeImageUrl;
  final int? productId;
  final int? position;

  factory ProductImageBlock.fromJson(Map<String, dynamic> json) {
    return ProductImageBlock(
      id: json['id'] as int?,
      url: json['url'] as String?,
      originalImageUrl: json['original_image_url'] as String?,
      smallImageUrl: json['small_image_url'] as String?,
      mediumImageUrl: json['medium_image_url'] as String?,
      largeImageUrl: json['large_image_url'] as String?,
      productId: json['product_id'] as int?,
      position: json['position'] as int?,
    );
  }
}

class ProductVideoBlock {
  const ProductVideoBlock({this.id, this.url});

  final int? id;
  final String? url;

  factory ProductVideoBlock.fromJson(Map<String, dynamic> json) {
    return ProductVideoBlock(
      id: json['id'] as int?,
      url: json['url'] as String?,
    );
  }
}

class ProductBaseImageBlock {
  const ProductBaseImageBlock({
    this.smallImageUrl,
    this.mediumImageUrl,
    this.largeImageUrl,
    this.originalImageUrl,
  });

  final String? smallImageUrl;
  final String? mediumImageUrl;
  final String? largeImageUrl;
  final String? originalImageUrl;

  factory ProductBaseImageBlock.fromJson(Map<String, dynamic> json) {
    return ProductBaseImageBlock(
      smallImageUrl: json['small_image_url'] as String?,
      mediumImageUrl: json['medium_image_url'] as String?,
      largeImageUrl: json['large_image_url'] as String?,
      originalImageUrl: json['original_image_url'] as String?,
    );
  }
}

class ProductReviewsSummary {
  const ProductReviewsSummary({
    this.total,
    this.totalRating,
    this.averageRating,
    this.percentage,
  });

  final int? total;
  final String? totalRating;
  final String? averageRating;
  final Map<String, int>? percentage;

  factory ProductReviewsSummary.fromJson(Map<String, dynamic> json) {
    Map<String, int>? pct;
    final p = json['percentage'];
    if (p is Map) {
      pct = p.map((k, v) => MapEntry(k.toString(), (v as num).toInt()));
    }
    return ProductReviewsSummary(
      total: json['total'] as int?,
      totalRating: json['total_rating']?.toString(),
      averageRating: json['average_rating']?.toString(),
      percentage: pct,
    );
  }

  double? get averageRatingAsDouble => double.tryParse(averageRating ?? '');
}

class CurrencyOptions {
  const CurrencyOptions({this.symbol, this.decimal, this.format});

  final String? symbol;
  final String? decimal;
  final String? format;

  factory CurrencyOptions.fromJson(Map<String, dynamic> json) {
    return CurrencyOptions(
      symbol: json['symbol'] as String?,
      decimal: json['decimal'] as String?,
      format: json['format'] as String?,
    );
  }
}

class ProductVariantLite {
  const ProductVariantLite({
    this.id,
    this.sku,
    this.name,
    this.price,
    this.specialPrice,
    this.formattedPrice,
    this.qty,
    this.isSaleable,
    this.showQuantityChanger,
    this.parentId,
    this.color,
    this.size,
  });

  final int? id;
  final String? sku;
  final String? name;
  final double? price;
  final double? specialPrice;
  final String? formattedPrice;
  final int? qty;
  final bool? isSaleable;
  final bool? showQuantityChanger;
  final int? parentId;
  final int? color;
  final int? size;

  factory ProductVariantLite.fromJson(Map<String, dynamic> json) {
    return ProductVariantLite(
      id: json['id'] as int?,
      sku: json['sku'] as String?,
      name: json['name'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      specialPrice: (json['special_price'] as num?)?.toDouble(),
      formattedPrice: json['formatted_price'] as String?,
      qty: json['qty'] as int?,
      isSaleable: json['isSaleable'] as bool?,
      showQuantityChanger: json['show_quantity_changer'] as bool?,
      parentId: json['parent_id'] as int?,
      color: json['color'] as int?,
      size: json['size'] as int?,
    );
  }
}

class SuperAttributeLite {
  const SuperAttributeLite({
    this.id,
    this.name,
    this.code,
    this.type,
    this.swatchType,
    this.options = const <SuperAttributeOptionLite>[],
  });

  final int? id;
  final String? name;
  final String? code;
  final String? type;
  final String? swatchType;
  final List<SuperAttributeOptionLite> options;

  factory SuperAttributeLite.fromJson(Map<String, dynamic> json) {
    return SuperAttributeLite(
      id: json['id'] as int?,
      name: json['name'] as String?,
      code: json['code'] as String?,
      type: json['type'] as String?,
      swatchType: json['swatch_type'] as String?,
      options: _parseOptionsList(json['options']),
    );
  }

  static List<SuperAttributeOptionLite> _parseOptionsList(dynamic raw) {
    if (raw == null) return const [];
    if (raw is List) {
      return raw
          .whereType<Map>()
          .map((e) => SuperAttributeOptionLite.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
    if (raw is Map<String, dynamic>) {
      return [SuperAttributeOptionLite.fromJson(raw)];
    }
    return const [];
  }
}

class SuperAttributeOptionLite {
  const SuperAttributeOptionLite({
    this.id,
    this.adminName,
    this.label,
    this.swatchValue,
  });

  final int? id;
  final String? adminName;
  final String? label;
  final String? swatchValue;

  factory SuperAttributeOptionLite.fromJson(Map<String, dynamic> json) {
    return SuperAttributeOptionLite(
      id: json['id'] as int?,
      adminName: json['admin_name'] as String?,
      label: json['label'] as String?,
      swatchValue: json['swatch_value'] as String?,
    );
  }
}