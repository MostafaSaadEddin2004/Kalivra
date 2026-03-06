/// GET /api/shop/v1/countries – countries (and optionally states).
class CountryApiModel {
  const CountryApiModel({
    required this.id,
    required this.code,
    this.name,
    this.states,
  });

  final int id;
  final String code;
  final String? name;
  final List<CountryStateApiModel>? states;

  factory CountryApiModel.fromJson(Map<String, dynamic> json) {
    return CountryApiModel(
      id: json['id'] as int,
      code: json['code'] as String,
      name: json['name'] as String?,
      states: (json['states'] as List<dynamic>?)
          ?.map((e) => CountryStateApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class CountryStateApiModel {
  const CountryStateApiModel({
    required this.id,
    required this.code,
    this.name,
    this.countryCode,
  });

  final int id;
  final String code;
  final String? name;
  final String? countryCode;

  factory CountryStateApiModel.fromJson(Map<String, dynamic> json) {
    return CountryStateApiModel(
      id: json['id'] as int,
      code: json['code'] as String,
      name: json['name'] as String?,
      countryCode: json['country_code'] as String?,
    );
  }
}
