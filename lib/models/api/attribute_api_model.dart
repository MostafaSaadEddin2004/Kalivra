/// GET /api/shop/v1/attributes – product attribute.
class AttributeApiModel {
  const AttributeApiModel({
    required this.id,
    this.code,
    this.name,
    this.type,
    this.options,
    this.swatchType,
  });

  final int id;
  final String? code;
  final String? name;
  final String? type;
  final List<AttributeOptionApiModel>? options;
  final String? swatchType;

  factory AttributeApiModel.fromJson(Map<String, dynamic> json) {
    return AttributeApiModel(
      id: json['id'] as int,
      code: json['code'] as String?,
      name: json['name'] as String?,
      type: json['type'] as String?,
      options: (json['options'] as List<dynamic>?)
          ?.map((e) => AttributeOptionApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      swatchType: json['swatch_type'] as String?,
    );
  }
}

class AttributeOptionApiModel {
  const AttributeOptionApiModel({
    this.id,
    this.name,
    this.swatchValue,
    this.sortOrder,
  });

  final int? id;
  final String? name;
  final String? swatchValue;
  final int? sortOrder;

  factory AttributeOptionApiModel.fromJson(Map<String, dynamic> json) {
    return AttributeOptionApiModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      swatchValue: json['swatch_value'] as String?,
      sortOrder: json['sort_order'] as int?,
    );
  }
}
