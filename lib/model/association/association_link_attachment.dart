import 'dart:io';

class AssociationLinkAttachment {
  AssociationLinkAttachment({
    required this.id,
    required this.file,
    this.description = '',
  });

  final String id;
  final File file;
  final String description;

  String get fileName {
    final normalized = file.path.replaceAll('\\', '/');
    final index = normalized.lastIndexOf('/');
    return index >= 0 ? normalized.substring(index + 1) : normalized;
  }

  AssociationLinkAttachment copyWith({
    String? description,
  }) {
    return AssociationLinkAttachment(
      id: id,
      file: file,
      description: description ?? this.description,
    );
  }
}
