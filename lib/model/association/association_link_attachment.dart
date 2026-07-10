import 'dart:io';

class AssociationLinkAttachment {
  AssociationLinkAttachment({
    required this.id,
    required this.file,
    this.attachmentTypeId,
  });

  final String id;
  final File file;
  final String? attachmentTypeId;

  String get fileName {
    final normalized = file.path.replaceAll('\\', '/');
    final index = normalized.lastIndexOf('/');
    return index >= 0 ? normalized.substring(index + 1) : normalized;
  }

  AssociationLinkAttachment copyWith({String? attachmentTypeId}) {
    return AssociationLinkAttachment(
      id: id,
      file: file,
      attachmentTypeId: attachmentTypeId ?? this.attachmentTypeId,
    );
  }
}
