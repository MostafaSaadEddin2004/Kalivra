class AssociationNewsModel {
  const AssociationNewsModel({
    required this.id,
    required this.text,
    required this.sortOrder,
  });

  final int id;
  final String text;
  final int sortOrder;

  factory AssociationNewsModel.fromJson(Map<String, dynamic> json) {
    return AssociationNewsModel(
      id: _intValue(json['id']) ?? 0,
      text: json['text']?.toString().trim() ?? '',
      sortOrder: _intValue(json['sort_order']) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'text': text, 'sort_order': sortOrder};
  }
}

int? _intValue(Object? value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString().trim() ?? '');
}
