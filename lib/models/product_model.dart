/// Represents a product displayed in the categories product grid.
class ProductModel {
  const ProductModel({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.price,
    this.imagePath,
    this.unit = 'قطعة',
    this.salePrice,
  });

  final String id;
  final String name;
  final String categoryId;
  final double price;
  final String? imagePath;
  final String unit;
  /// Price when on sale (must be less than [price]). When null, product is not on sale.
  final double? salePrice;
}
