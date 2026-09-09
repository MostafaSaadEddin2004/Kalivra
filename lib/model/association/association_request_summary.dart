class AssociationRequestSummary {
  const AssociationRequestSummary({
    required this.id,
    required this.requestNumber,
    required this.type,
    required this.typeLabel,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.documents,
    this.customerNote,
    this.documentDefinition,
    this.documentUrl,
    this.adminNotes,
    this.adminReply,
    this.adminRepliedAt,
    this.replyMessage,
    this.replyAt,
    this.requestedMembershipType,
    this.requestedMembershipTypeLabel,
    this.claimedMembershipNumber,
    this.claimedPriorityNumber,
    this.claimedBuildingNumber,
    this.claimedUnitNumber,
    this.membershipId,
    this.paymentId,
    this.financialObligationId,
    this.reviewedAt,
    this.approvedAt,
    this.isReviewed = false,
  });

  final int id;
  final String requestNumber;
  final String type;
  final String typeLabel;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? customerNote;
  final String? documentDefinition;
  final String? documentUrl;
  final String? adminNotes;
  final String? adminReply;
  final DateTime? adminRepliedAt;
  final String? replyMessage;
  final DateTime? replyAt;
  final String? requestedMembershipType;
  final String? requestedMembershipTypeLabel;
  final String? claimedMembershipNumber;
  final String? claimedPriorityNumber;
  final String? claimedBuildingNumber;
  final String? claimedUnitNumber;
  final int? membershipId;
  final int? paymentId;
  final int? financialObligationId;
  final List<AssociationRequestDocument> documents;
  final DateTime? reviewedAt;
  final DateTime? approvedAt;
  final bool isReviewed;

  factory AssociationRequestSummary.fromJson(Map<String, dynamic> json) {
    return AssociationRequestSummary(
      id: _intValue(json['id']) ?? 0,
      requestNumber: _stringValue(json['request_number']),
      type: _stringValue(json['type']),
      typeLabel: _stringValue(json['type_label']),
      status: json['status']?.toString() ?? '',
      createdAt: _dateValue(json['created_at']) ?? DateTime.now(),
      updatedAt: _dateValue(json['updated_at']) ?? DateTime.now(),
      customerNote: _stringOrNull(json['customer_note']),
      documentDefinition: _stringOrNull(json['document_definition']),
      documentUrl: _stringOrNull(json['document_url']),
      adminNotes: _stringOrNull(json['admin_notes']),
      adminReply: _stringOrNull(json['admin_reply']),
      adminRepliedAt: _dateValue(json['admin_replied_at']),
      replyMessage: _stringOrNull(json['reply_message']),
      replyAt: _dateValue(json['reply_at']),
      requestedMembershipType: _stringOrNull(json['requested_membership_type']),
      requestedMembershipTypeLabel: _stringOrNull(
        json['requested_membership_type_label'],
      ),
      claimedMembershipNumber: _stringOrNull(json['claimed_membership_number']),
      claimedPriorityNumber: _stringOrNull(json['claimed_priority_number']),
      claimedBuildingNumber: _stringOrNull(json['claimed_building_number']),
      claimedUnitNumber: _stringOrNull(json['claimed_unit_number']),
      membershipId: _intValue(json['membership_id']),
      paymentId: _intValue(json['payment_id']),
      financialObligationId: _intValue(json['financial_obligation_id']),
      documents: _documentsValue(json['documents']),
      reviewedAt: _dateValue(json['reviewed_at']),
      approvedAt: _dateValue(json['approved_at']),
      isReviewed: _boolValue(json['is_reviewed']),
    );
  }

  String get displayNumber => requestNumber.isNotEmpty ? requestNumber : '$id';

  String get displayType => typeLabel.isNotEmpty
      ? typeLabel
      : type.isNotEmpty
      ? type
      : '';

  String? get effectiveReplyMessage => replyMessage ?? adminReply;

  DateTime? get effectiveReplyAt => replyAt ?? adminRepliedAt;

  String get normalizedStatus => status.toLowerCase().trim();

  bool get isPending => normalizedStatus == 'pending';
  bool get isApproved =>
      normalizedStatus == 'approved' || normalizedStatus == 'accepted';
  bool get isRejected =>
      normalizedStatus == 'rejected' || normalizedStatus == 'refused';
}

class AssociationRequestDocument {
  const AssociationRequestDocument({
    required this.id,
    required this.documentDefinitionId,
    required this.originalFileName,
    required this.fileUrl,
    required this.mimeType,
    required this.fileSize,
    required this.definition,
    this.uploadedAt,
    this.createdAt,
  });

  final int id;
  final int documentDefinitionId;
  final String originalFileName;
  final String fileUrl;
  final String mimeType;
  final int fileSize;
  final AssociationRequestDocumentDefinition? definition;
  final DateTime? uploadedAt;
  final DateTime? createdAt;

  factory AssociationRequestDocument.fromJson(Map<String, dynamic> json) {
    return AssociationRequestDocument(
      id: _intValue(json['id']) ?? 0,
      documentDefinitionId: _intValue(json['document_definition_id']) ?? 0,
      originalFileName: _stringValue(json['original_file_name']),
      fileUrl: _stringValue(json['file_url']),
      mimeType: _stringValue(json['mime_type']),
      fileSize: _intValue(json['file_size']) ?? 0,
      definition: _documentDefinitionValue(json['document_definition']),
      uploadedAt: _dateValue(json['uploaded_at']),
      createdAt: _dateValue(json['created_at']),
    );
  }

  String get displayName {
    if (originalFileName.trim().isNotEmpty) return originalFileName;
    final name = definition?.displayName.trim();
    if (name?.isNotEmpty == true) return name!;
    return fileUrl.trim().isNotEmpty ? fileUrl : 'file';
  }
}

class AssociationRequestDocumentDefinition {
  const AssociationRequestDocumentDefinition({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.nameEn,
    required this.isRequired,
  });

  final int id;
  final String name;
  final String nameAr;
  final String nameEn;
  final bool isRequired;

  factory AssociationRequestDocumentDefinition.fromJson(
    Map<String, dynamic> json,
  ) {
    return AssociationRequestDocumentDefinition(
      id: _intValue(json['id']) ?? 0,
      name: _stringValue(json['name']),
      nameAr: _stringValue(json['name_ar']),
      nameEn: _stringValue(json['name_en']),
      isRequired: _boolValue(json['is_required']),
    );
  }

  String get displayName {
    if (name.trim().isNotEmpty) return name;
    if (nameAr.trim().isNotEmpty) return nameAr;
    return nameEn;
  }
}

List<AssociationRequestDocument> _documentsValue(Object? value) {
  if (value is! List) return const [];

  return value
      .whereType<Map>()
      .map(
        (item) => AssociationRequestDocument.fromJson(
          Map<String, dynamic>.from(item),
        ),
      )
      .toList();
}

AssociationRequestDocumentDefinition? _documentDefinitionValue(Object? value) {
  if (value is! Map) return null;

  return AssociationRequestDocumentDefinition.fromJson(
    Map<String, dynamic>.from(value),
  );
}

String _stringValue(Object? value) => value?.toString().trim() ?? '';

String? _stringOrNull(Object? value) {
  final text = _stringValue(value);
  if (text.isEmpty) return null;
  return text;
}

DateTime? _dateValue(Object? value) {
  final text = _stringValue(value);
  if (text.isEmpty) return null;
  return DateTime.tryParse(text);
}

int? _intValue(Object? value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(_stringValue(value));
}

bool _boolValue(Object? value) {
  if (value is bool) return value;
  final text = _stringValue(value).toLowerCase();
  return text == 'true' || text == '1' || text == 'yes';
}
