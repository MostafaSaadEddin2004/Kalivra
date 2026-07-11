class AssociationAttachmentType {
  const AssociationAttachmentType({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.nameEn,
    required this.description,
    required this.isRequired,
  });

  final int id;
  final String name;
  final String nameAr;
  final String nameEn;
  final String? description;
  final bool isRequired;

  factory AssociationAttachmentType.fromJson(Map<String, dynamic> json) {
    return AssociationAttachmentType(
      id: json['id'] as int,
      name: json['name'] as String,
      nameAr: json['name_ar'] as String,
      nameEn: json['name_en'] as String,
      description: json['description'] as String?,
      isRequired: json['is_required'] as bool? ?? false,
    );
  }
}
