/// Represents a brand with shops and locations.
class BrandModel {
  const BrandModel({
    required this.id,
    required this.name,
    required this.shopCount,
    required this.locations,
    this.description,
    this.imagePath,
    this.phone,
    this.website,
  });

  final String id;
  final String name;
  /// Number of shops/stores for this brand.
  final int shopCount;
  /// List of location names (cities, addresses, or branch names).
  final List<String> locations;
  final String? description;
  final String? imagePath;
  final String? phone;
  final String? website;
}
