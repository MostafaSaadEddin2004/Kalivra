/// GET /api/shop/v1/locales – supported locales.
class LocaleApiModel {
  const LocaleApiModel({
    required this.id,
    required this.code,
    this.name,
  });

  final int id;
  final String code;
  final String? name;

  factory LocaleApiModel.fromJson(Map<String, dynamic> json) {
    return LocaleApiModel(
      id: json['id'] as int,
      code: json['code'] as String,
      name: json['name'] as String?,
    );
  }
}
