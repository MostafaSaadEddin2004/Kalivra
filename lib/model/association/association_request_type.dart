class AssociationRequestType {
  const AssociationRequestType({
    required this.value,
    required this.slug,
    required this.label,
    required this.requiresMembershipType,
    required this.memberOnly,
    required this.endpoint,
  });

  final String value;
  final String slug;
  final String label;
  final bool requiresMembershipType;
  final bool memberOnly;
  final String endpoint;

  factory AssociationRequestType.fromJson(Map<String, dynamic> json) {
    return AssociationRequestType(
      value: json['value']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      label: json['label']?.toString() ?? '',
      requiresMembershipType: json['requires_membership_type'] == true,
      memberOnly: json['member_only'] == true,
      endpoint: json['endpoint']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'value': value,
    'slug': slug,
    'label': label,
    'requires_membership_type': requiresMembershipType,
    'member_only': memberOnly,
    'endpoint': endpoint,
  };
}
