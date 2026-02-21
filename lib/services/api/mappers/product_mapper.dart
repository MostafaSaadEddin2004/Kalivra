import 'package:kalivra/models/product_model.dart';
import 'package:kalivra/models/api/product_api_model.dart';

/// Maps API product models to app ProductModel.
class ProductMapper {
  ProductMapper._();

  static ProductModel fromApi(ProductApiModel api) {
    final imageUrls = api.images
        ?.map((img) => img.url ?? img.path ?? '')
        .where((s) => s.isNotEmpty)
        .toList();
    final firstUrl = imageUrls != null && imageUrls.isNotEmpty ? imageUrls.first : null;
    return ProductModel(
      id: api.id.toString(),
      name: api.name,
      categoryId: api.categoryId?.toString() ?? '',
      price: api.price ?? 0,
      imagePath: firstUrl,
      imageUrls: imageUrls,
      salePrice: api.specialPrice,
      quantity: api.quantity ?? 10,
      brandId: null,
      sizes: api.attributeOptions?['size'] != null
          ? _listFromDynamic(api.attributeOptions!['size'])
          : null,
      colors: null,
    );
  }

  static List<String>? _listFromDynamic(dynamic v) {
    if (v is List) return v.map((e) => e.toString()).toList();
    return null;
  }
}
