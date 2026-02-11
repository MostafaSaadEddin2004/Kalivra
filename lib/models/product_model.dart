/// Represents a product displayed in the app.
/// [quantity] is the maximum orderable quantity (e.g. available stock).
class ProductModel {
  const ProductModel({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.price,
    this.imagePath,
    this.unit = 'قطعة',
    this.salePrice,
    this.quantity = 10,
    this.brandId,
  });

  final String id;
  final String name;
  final String categoryId;
  final double price;
  /// Optional brand id; used to show products on brand details screen.
  final String? brandId;
  final String? imagePath;
  final String unit;
  final double? salePrice;
  /// Maximum quantity that can be ordered (e.g. available stock). Defaults to 10.
  final int quantity;
}
