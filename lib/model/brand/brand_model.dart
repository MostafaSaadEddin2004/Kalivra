class BrandModel {
  final int id;
  final String name;
  // final int shopCount;
  // final List<String> locations;
  // final String? description;
  // final String? imagePath;
  // final String? phone;
  // final String? website;
  
   BrandModel({
    required this.id,
    required this.name,
    // required this.shopCount,
    // required this.locations,
    // this.description,
    // this.imagePath,
    // this.phone,
    // this.website,
  });

  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      id: json['id'],
      name: json['name'] as String,
      // shopCount: json['shop_count'] as int,
      // locations: List<String>.from(json['locations'] ?? []),
      // description: json['description'],
      // imagePath: json['image_path'],
      // phone: json['phone'],
      // website: json['website'],
    );
  }
}
