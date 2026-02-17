/// GET /api/shop/v1/attribute-families – product attribute family.
class AttributeFamilyApiModel {
  const AttributeFamilyApiModel({
    required this.id,
    this.code,
    this.name,
    this.status,
    this.groups,
  });

  final int id;
  final String? code;
  final String? name;
  final int? status;
  final List<Map<String, dynamic>>? groups;

  factory AttributeFamilyApiModel.fromJson(Map<String, dynamic> json) {
    return AttributeFamilyApiModel(
      id: json['id'] as int,
      code: json['code'] as String?,
      name: json['name'] as String?,
      status: json['status'] as int?,
      groups: (json['groups'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
    );
  }
}
