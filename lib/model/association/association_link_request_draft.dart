class AssociationLinkRequestDraft {
  const AssociationLinkRequestDraft({
    this.firstName = '',
    this.kunya = '',
    this.fatherName = '',
    this.motherName = '',
    this.governorate = '',
    this.city = '',
    this.town = '',
    this.municipality = '',
    this.street = '',
    this.building = '',
    this.permanentAddress = '',
    this.mobile = '',
    this.whatsApp = '',
    this.email = '',
    this.membershipNumber = '',
    this.priorityNumber = '',
    this.projectName = '',
    this.housingUnit = '',
    this.totalPayments = '',
  });

  final String firstName;
  final String kunya;
  final String fatherName;
  final String motherName;
  final String governorate;
  final String city;
  final String town;
  final String municipality;
  final String street;
  final String building;
  final String permanentAddress;
  final String mobile;
  final String whatsApp;
  final String email;
  final String membershipNumber;
  final String priorityNumber;
  final String projectName;
  final String housingUnit;
  final String totalPayments;

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'kunya': kunya,
      'father_name': fatherName,
      'mother_name': motherName,
      'governorate': governorate,
      'city': city,
      'town': town,
      'municipality': municipality,
      'street': street,
      'building': building,
      'permanent_address': permanentAddress,
      'mobile': mobile,
      'whatsapp': whatsApp,
      'email': email,
      'membership_number': membershipNumber,
      'priority_number': priorityNumber,
      'project_name': projectName,
      'housing_unit': housingUnit,
      'total_payments': totalPayments,
    };
  }

  factory AssociationLinkRequestDraft.fromJson(Map<String, dynamic> json) {
    return AssociationLinkRequestDraft(
      firstName: json['first_name'] as String? ?? '',
      kunya: json['kunya'] as String? ?? '',
      fatherName: json['father_name'] as String? ?? '',
      motherName: json['mother_name'] as String? ?? '',
      governorate: json['governorate'] as String? ?? '',
      city: json['city'] as String? ?? '',
      town: json['town'] as String? ?? '',
      municipality: json['municipality'] as String? ?? '',
      street: json['street'] as String? ?? '',
      building: json['building'] as String? ?? '',
      permanentAddress: json['permanent_address'] as String? ?? '',
      mobile: json['mobile'] as String? ?? '',
      whatsApp: json['whatsapp'] as String? ?? '',
      email: json['email'] as String? ?? '',
      membershipNumber: json['membership_number'] as String? ?? '',
      priorityNumber: json['priority_number'] as String? ?? '',
      projectName: json['project_name'] as String? ?? '',
      housingUnit: json['housing_unit'] as String? ?? '',
      totalPayments: json['total_payments'] as String? ?? '',
    );
  }
}
