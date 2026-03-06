/// GET /api/shop/v1/themes – theme config (optional).
class ThemeApiModel {
  const ThemeApiModel({
    this.code,
    this.name,
    this.previewImage,
    this.default_,
  });

  final String? code;
  final String? name;
  final String? previewImage;
  final bool? default_;

  factory ThemeApiModel.fromJson(Map<String, dynamic> json) {
    return ThemeApiModel(
      code: json['code'] as String?,
      name: json['name'] as String?,
      previewImage: json['preview_image'] as String?,
      default_: json['default'] as bool?,
    );
  }
}
