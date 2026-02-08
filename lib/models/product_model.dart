/// Represents a product displayed in the categories product grid.
class ProductModel {
  const ProductModel({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.price,
    this.imagePath,
    this.unit = 'قطعة',
  });

  final String id;
  final String name;
  final String categoryId;
  final double price;
  final String? imagePath;
  final String unit;
}
