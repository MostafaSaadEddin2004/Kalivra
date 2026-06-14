class AssociationRequestSummary {
  const AssociationRequestSummary({
    required this.id,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.documentDefinition,
    this.documentUrl,
    this.approvedAt,
  });

  final int id;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? documentDefinition;
  final String? documentUrl;
  final DateTime? approvedAt;

  factory AssociationRequestSummary.fromJson(Map<String, dynamic> json) {
    return AssociationRequestSummary(
      id: (json['id'] as num).toInt(),
      status: json['status']?.toString() ?? '',
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? '') ??
          DateTime.now(),
      documentDefinition: json['document_definition']?.toString(),
      documentUrl: json['document_url']?.toString(),
      approvedAt: json['approved_at'] != null
          ? DateTime.tryParse(json['approved_at'].toString())
          : null,
    );
  }

  String get normalizedStatus => status.toLowerCase().trim();

  bool get isPending => normalizedStatus == 'pending';
  bool get isApproved =>
      normalizedStatus == 'approved' || normalizedStatus == 'accepted';
  bool get isRejected =>
      normalizedStatus == 'rejected' || normalizedStatus == 'refused';
}
