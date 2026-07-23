class AssociationAnnouncementModel {
  const AssociationAnnouncementModel({
    required this.id,
    required this.referenceNumber,
    required this.type,
    required this.typeLabel,
    required this.title,
    required this.attachments,
    this.announcementDate,
    this.category,
    this.content,
    this.legalDeadline,
    this.deliveredAt,
  });

  final int id;
  final String referenceNumber;
  final DateTime? announcementDate;
  final String type;
  final String typeLabel;
  final String? category;
  final String title;
  final String? content;
  final DateTime? legalDeadline;
  final DateTime? deliveredAt;
  final List<AssociationAnnouncementAttachment> attachments;

  bool get isDelivered => deliveredAt != null;

  factory AssociationAnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AssociationAnnouncementModel(
      id: _intValue(json['id']) ?? 0,
      referenceNumber: json['reference_number']?.toString() ?? '',
      announcementDate: _dateValue(json['announcement_date']),
      type: json['type']?.toString() ?? '',
      typeLabel: json['type_label']?.toString() ?? '',
      category: _stringOrNull(json['category']),
      title: json['title']?.toString() ?? '',
      content: _stringOrNull(json['content']),
      legalDeadline: _dateValue(json['legal_deadline']),
      deliveredAt: _dateValue(json['delivered_at']),
      attachments: _attachmentsValue(json['attachments']),
    );
  }
}

class AssociationAnnouncementAttachment {
  const AssociationAnnouncementAttachment({required this.name, this.url});

  final String name;
  final String? url;

  factory AssociationAnnouncementAttachment.fromJson(
    Map<String, dynamic> json,
  ) {
    final url =
        _stringOrNull(json['url']) ??
        _stringOrNull(json['file_url']) ??
        _stringOrNull(json['download_url']) ??
        _stringOrNull(json['full_url']) ??
        _stringOrNull(json['media_url']) ??
        _stringOrNull(json['src']) ??
        _stringOrNull(json['link']) ??
        _stringOrNull(json['path']) ??
        _stringOrNull(json['file']);

    return AssociationAnnouncementAttachment(
      name:
          json['name']?.toString() ??
          json['file_name']?.toString() ??
          json['filename']?.toString() ??
          json['original_name']?.toString() ??
          json['title']?.toString() ??
          _fileNameFromPath(url) ??
          '',
      url: url,
    );
  }
}

List<AssociationAnnouncementAttachment> _attachmentsValue(Object? value) {
  if (value is! List) return const [];

  return value
      .map((item) {
        if (item is String) {
          return AssociationAnnouncementAttachment(
            name: _fileNameFromPath(item) ?? item,
            url: item,
          );
        }

        if (item is Map) {
          return AssociationAnnouncementAttachment.fromJson(
            Map<String, dynamic>.from(item),
          );
        }

        return null;
      })
      .whereType<AssociationAnnouncementAttachment>()
      .where((item) => item.name.trim().isNotEmpty)
      .toList();
}

String? _stringOrNull(Object? value) {
  final text = value?.toString().trim();
  if (text == null || text.isEmpty) return null;
  return text;
}

String? _fileNameFromPath(String? value) {
  final text = value?.trim();
  if (text == null || text.isEmpty) return null;

  final uri = Uri.tryParse(text);
  final segments = uri?.pathSegments.where((segment) => segment.isNotEmpty);
  if (segments == null || segments.isEmpty) return null;
  return Uri.decodeComponent(segments.last);
}

DateTime? _dateValue(Object? value) {
  final text = value?.toString().trim();
  if (text == null || text.isEmpty) return null;
  return DateTime.tryParse(text);
}

int? _intValue(Object? value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString().trim() ?? '');
}
