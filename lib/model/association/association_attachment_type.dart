class AssociationAttachmentType {
  const AssociationAttachmentType({required this.id, required this.label});

  final String id;
  final String label;

  factory AssociationAttachmentType.fromJson(Map<String, dynamic> json) {
    final id = json['id'] ?? json['value'] ?? json['attachment_type_id'];
    final label =
        json['label'] ?? json['name'] ?? json['title'] ?? json['description'];

    return AssociationAttachmentType(
      id: id?.toString() ?? '',
      label: label?.toString() ?? id?.toString() ?? '',
    );
  }
}
