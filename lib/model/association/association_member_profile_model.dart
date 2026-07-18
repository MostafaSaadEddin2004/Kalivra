class AssociationMemberProfileModel {
  const AssociationMemberProfileModel({
    required this.isLinkedPerson,
    required this.isAssociationMember,
    required this.hasPendingAssociationMembershipRequest,
    required this.isAssignedToProjects,
    required this.isAssignedToUnits,
    required this.hasActiveMemberships,
    this.registrationProfile,
    this.bindingProfile,
    required this.person,
    this.associationMember,
    required this.memberships,
    required this.projects,
    this.latestAssociationMembershipRequest,
    this.membershipLifecycle,
  });

  final bool isLinkedPerson;
  final bool isAssociationMember;
  final bool hasPendingAssociationMembershipRequest;
  final bool isAssignedToProjects;
  final bool isAssignedToUnits;
  final bool hasActiveMemberships;
  final ProfileCompletion? registrationProfile;
  final BindingProfile? bindingProfile;
  final AssociationPerson person;
  final AssociationCoreMember? associationMember;
  final List<AssociationMembership> memberships;
  final List<AssociationProject> projects;
  final Object? latestAssociationMembershipRequest;
  final MembershipLifecycle? membershipLifecycle;

  factory AssociationMemberProfileModel.fromJson(Map<String, dynamic> json) {
    return AssociationMemberProfileModel(
      isLinkedPerson: _boolValue(json['is_linked_person']),
      isAssociationMember: _boolValue(json['is_association_member']),
      hasPendingAssociationMembershipRequest: _boolValue(
        json['has_pending_association_membership_request'],
      ),
      isAssignedToProjects: _boolValue(json['is_assigned_to_projects']),
      isAssignedToUnits: _boolValue(json['is_assigned_to_units']),
      hasActiveMemberships: _boolValue(json['has_active_memberships']),
      registrationProfile: _mapOrNull(
        json['registration_profile'],
        ProfileCompletion.fromJson,
      ),
      bindingProfile: _mapOrNull(
        json['binding_profile'],
        BindingProfile.fromJson,
      ),
      person:
          _mapOrNull(json['person'], AssociationPerson.fromJson) ??
          const AssociationPerson(),
      associationMember: _mapOrNull(
        json['association_member'],
        AssociationCoreMember.fromJson,
      ),
      memberships: _listOf(json['memberships'], AssociationMembership.fromJson),
      projects: _listOf(json['projects'], AssociationProject.fromJson),
      latestAssociationMembershipRequest:
          json['latest_association_membership_request'],
      membershipLifecycle: _mapOrNull(
        json['membership_lifecycle'],
        MembershipLifecycle.fromJson,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'is_linked_person': isLinkedPerson,
      'is_association_member': isAssociationMember,
      'has_pending_association_membership_request':
          hasPendingAssociationMembershipRequest,
      'is_assigned_to_projects': isAssignedToProjects,
      'is_assigned_to_units': isAssignedToUnits,
      'has_active_memberships': hasActiveMemberships,
      'registration_profile': registrationProfile?.toJson(),
      'binding_profile': bindingProfile?.toJson(),
      'person': person.toJson(),
      'association_member': associationMember?.toJson(),
      'memberships': memberships.map((item) => item.toJson()).toList(),
      'projects': projects.map((item) => item.toJson()).toList(),
      'latest_association_membership_request':
          latestAssociationMembershipRequest,
      'membership_lifecycle': membershipLifecycle?.toJson(),
    };
  }
}

class ProfileCompletion {
  const ProfileCompletion({
    required this.complete,
    required this.missingFields,
    required this.missingFieldLabels,
  });

  final bool complete;
  final List<String> missingFields;
  final List<String> missingFieldLabels;

  factory ProfileCompletion.fromJson(Map<String, dynamic> json) {
    return ProfileCompletion(
      complete: _boolValue(json['complete']),
      missingFields: _stringList(json['missing_fields']),
      missingFieldLabels: _stringList(json['missing_field_labels']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'complete': complete,
      'missing_fields': missingFields,
      'missing_field_labels': missingFieldLabels,
    };
  }
}

class BindingProfile extends ProfileCompletion {
  const BindingProfile({
    required super.complete,
    required super.missingFields,
    required super.missingFieldLabels,
    required this.documentsComplete,
  });

  final bool documentsComplete;

  factory BindingProfile.fromJson(Map<String, dynamic> json) {
    return BindingProfile(
      complete: _boolValue(json['complete']),
      missingFields: _stringList(json['missing_fields']),
      missingFieldLabels: _stringList(json['missing_field_labels']),
      documentsComplete: _boolValue(json['documents_complete']),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {...super.toJson(), 'documents_complete': documentsComplete};
  }
}

class AssociationPerson {
  const AssociationPerson({
    this.id,
    this.firstName = '',
    this.lastName = '',
    this.fullName = '',
    this.name = '',
    this.fatherName = '',
    this.motherName = '',
    this.gender = '',
    this.nationalId = '',
    this.status = '',
    this.email = '',
    this.phone = '',
    this.whatsappNumber = '',
    this.address = '',
    this.profileAddresses = const [],
  });

  final int? id;
  final String firstName;
  final String lastName;
  final String fullName;
  final String name;
  final String fatherName;
  final String motherName;
  final String gender;
  final String nationalId;
  final String status;
  final String email;
  final String phone;
  final String whatsappNumber;
  final String address;
  final List<Map<String, dynamic>> profileAddresses;

  String get displayName {
    if (fullName.isNotEmpty) return fullName;
    if (name.isNotEmpty) return name;
    return [firstName, lastName].where((part) => part.isNotEmpty).join(' ');
  }

  factory AssociationPerson.fromJson(Map<String, dynamic> json) {
    return AssociationPerson(
      id: _intValue(json['id']),
      firstName: _stringValue(json['first_name']),
      lastName: _stringValue(json['last_name']),
      fullName: _stringValue(json['full_name']),
      name: _stringValue(json['name']),
      fatherName: _stringValue(json['father_name']),
      motherName: _stringValue(json['mother_name']),
      gender: _stringValue(json['gender']),
      nationalId: _stringValue(json['national_id']),
      status: _stringValue(json['status']),
      email: _stringValue(json['email']),
      phone: _stringValue(json['phone']),
      whatsappNumber: _stringValue(json['whatsapp_number']),
      address: _stringValue(json['address']),
      profileAddresses: _mapList(json['profile_addresses']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'full_name': fullName,
      'name': name,
      'father_name': fatherName,
      'mother_name': motherName,
      'gender': gender,
      'national_id': nationalId,
      'status': status,
      'email': email,
      'phone': phone,
      'whatsapp_number': whatsappNumber,
      'address': address,
      'profile_addresses': profileAddresses,
    };
  }
}

class AssociationCoreMember {
  const AssociationCoreMember({
    this.id,
    this.membershipNumber = '',
    this.priorityNumber,
    this.priorityStatus = '',
    this.priorityStatusLabel = '',
    this.status = '',
    this.statusLabel = '',
    this.isActive = false,
  });

  final int? id;
  final String membershipNumber;
  final int? priorityNumber;
  final String priorityStatus;
  final String priorityStatusLabel;
  final String status;
  final String statusLabel;
  final bool isActive;

  factory AssociationCoreMember.fromJson(Map<String, dynamic> json) {
    return AssociationCoreMember(
      id: _intValue(json['id']),
      membershipNumber: _stringValue(json['membership_number']),
      priorityNumber: _intValue(json['priority_number']),
      priorityStatus: _stringValue(json['priority_status']),
      priorityStatusLabel: _stringValue(json['priority_status_label']),
      status: _stringValue(json['status']),
      statusLabel: _stringValue(json['status_label']),
      isActive: _boolValue(json['is_active']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'membership_number': membershipNumber,
      'priority_number': priorityNumber,
      'priority_status': priorityStatus,
      'priority_status_label': priorityStatusLabel,
      'status': status,
      'status_label': statusLabel,
      'is_active': isActive,
    };
  }
}

class AssociationMembership {
  const AssociationMembership({
    this.id,
    this.membershipNumber = '',
    this.membershipType = '',
    this.membershipTypeLabel = '',
    this.membershipStatus = '',
    this.status = '',
    this.membershipStatusLabel = '',
    this.isActive = false,
    this.isAssignedToProject = false,
    this.isAssignedToUnit = false,
    this.financialStatus = '',
    this.financialStatusLabel = '',
    this.memberFinancialStatus = '',
    this.memberFinancialStatusLabel = '',
    this.joinDate = '',
    this.priorityNumber,
    this.priorityStatus = '',
    this.priorityStatusLabel = '',
    this.membershipDecision = '',
    this.joinDocuments = '',
    this.closedAt = '',
    this.project,
    this.building,
    this.unit,
    this.totalPaymentsMade,
  });

  final int? id;
  final String membershipNumber;
  final String membershipType;
  final String membershipTypeLabel;
  final String membershipStatus;
  final String status;
  final String membershipStatusLabel;
  final bool isActive;
  final bool isAssignedToProject;
  final bool isAssignedToUnit;
  final String financialStatus;
  final String financialStatusLabel;
  final String memberFinancialStatus;
  final String memberFinancialStatusLabel;
  final String joinDate;
  final int? priorityNumber;
  final String priorityStatus;
  final String priorityStatusLabel;
  final String membershipDecision;
  final String joinDocuments;
  final String closedAt;
  final AssociationProject? project;
  final AssociationBuilding? building;
  final AssociationUnit? unit;
  final num? totalPaymentsMade;

  String get displayType {
    if (membershipTypeLabel.isNotEmpty) return membershipTypeLabel;
    return membershipType;
  }

  String get displayStatus {
    if (membershipStatusLabel.isNotEmpty) return membershipStatusLabel;
    return membershipStatus.isNotEmpty ? membershipStatus : status;
  }

  String get displayFinancialStatus {
    if (memberFinancialStatusLabel.isNotEmpty) {
      return memberFinancialStatusLabel;
    }
    if (financialStatusLabel.isNotEmpty) return financialStatusLabel;
    return memberFinancialStatus.isNotEmpty
        ? memberFinancialStatus
        : financialStatus;
  }

  factory AssociationMembership.fromJson(Map<String, dynamic> json) {
    return AssociationMembership(
      id: _intValue(json['id']),
      membershipNumber: _stringValue(json['membership_number']),
      membershipType: _stringValue(json['membership_type']),
      membershipTypeLabel: _stringValue(json['membership_type_label']),
      membershipStatus: _stringValue(json['membership_status']),
      status: _stringValue(json['status']),
      membershipStatusLabel: _stringValue(json['membership_status_label']),
      isActive: _boolValue(json['is_active']),
      isAssignedToProject: _boolValue(json['is_assigned_to_project']),
      isAssignedToUnit: _boolValue(json['is_assigned_to_unit']),
      financialStatus: _stringValue(json['financial_status']),
      financialStatusLabel: _stringValue(json['financial_status_label']),
      memberFinancialStatus: _stringValue(json['member_financial_status']),
      memberFinancialStatusLabel: _stringValue(
        json['member_financial_status_label'],
      ),
      joinDate: _stringValue(json['join_date']),
      priorityNumber: _intValue(json['priority_number']),
      priorityStatus: _stringValue(json['priority_status']),
      priorityStatusLabel: _stringValue(json['priority_status_label']),
      membershipDecision: _stringValue(json['membership_decision']),
      joinDocuments: _stringValue(json['join_documents']),
      closedAt: _stringValue(json['closed_at']),
      project: _mapOrNull(json['project'], AssociationProject.fromJson),
      building: _mapOrNull(json['building'], AssociationBuilding.fromJson),
      unit: _mapOrNull(json['unit'], AssociationUnit.fromJson),
      totalPaymentsMade: _numValue(json['total_payments_made']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'membership_number': membershipNumber,
      'membership_type': membershipType,
      'membership_type_label': membershipTypeLabel,
      'membership_status': membershipStatus,
      'status': status,
      'membership_status_label': membershipStatusLabel,
      'is_active': isActive,
      'is_assigned_to_project': isAssignedToProject,
      'is_assigned_to_unit': isAssignedToUnit,
      'financial_status': financialStatus,
      'financial_status_label': financialStatusLabel,
      'member_financial_status': memberFinancialStatus,
      'member_financial_status_label': memberFinancialStatusLabel,
      'join_date': joinDate,
      'priority_number': priorityNumber,
      'priority_status': priorityStatus,
      'priority_status_label': priorityStatusLabel,
      'membership_decision': membershipDecision,
      'join_documents': joinDocuments,
      'closed_at': closedAt,
      'project': project?.toJson(),
      'building': building?.toJson(),
      'unit': unit?.toJson(),
      'total_payments_made': totalPaymentsMade,
    };
  }
}

class AssociationProject {
  const AssociationProject({
    this.id,
    this.name = '',
    this.type = '',
    this.typeLabel = '',
    this.price,
    this.status = '',
    this.subtitle = '',
    this.subtitleTranslations = const {},
  });

  final int? id;
  final String name;
  final String type;
  final String typeLabel;
  final num? price;
  final String status;
  final String subtitle;
  final Map<String, String> subtitleTranslations;

  factory AssociationProject.fromJson(Map<String, dynamic> json) {
    return AssociationProject(
      id: _intValue(json['id']),
      name: _stringValue(json['name']),
      type: _stringValue(json['type']),
      typeLabel: _stringValue(json['type_label']),
      price: _numValue(json['price']),
      status: _stringValue(json['status']),
      subtitle: _stringValue(json['subtitle']),
      subtitleTranslations: _stringMap(json['subtitle_translations']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'type_label': typeLabel,
      'price': price,
      'status': status,
      'subtitle': subtitle,
      'subtitle_translations': subtitleTranslations,
    };
  }
}

class AssociationBuilding {
  const AssociationBuilding({
    this.id,
    this.projectId,
    this.name = '',
    this.description = '',
  });

  final int? id;
  final int? projectId;
  final String name;
  final String description;

  factory AssociationBuilding.fromJson(Map<String, dynamic> json) {
    return AssociationBuilding(
      id: _intValue(json['id']),
      projectId: _intValue(json['project_id']),
      name: _stringValue(json['name']),
      description: _stringValue(json['description']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'project_id': projectId,
      'name': name,
      'description': description,
    };
  }
}

class AssociationUnit {
  const AssociationUnit({
    this.id,
    this.buildingId,
    this.unitNumber = '',
    this.floorNumber,
    this.orientation = '',
    this.orientationLabel = '',
    this.area,
    this.gardenTerraceArea,
    this.price,
    this.specifications = '',
    this.unitPlanUrl = '',
    this.status = '',
    this.statusLabel = '',
    this.building,
  });

  final int? id;
  final int? buildingId;
  final String unitNumber;
  final int? floorNumber;
  final String orientation;
  final String orientationLabel;
  final num? area;
  final num? gardenTerraceArea;
  final num? price;
  final String specifications;
  final String unitPlanUrl;
  final String status;
  final String statusLabel;
  final AssociationBuilding? building;

  factory AssociationUnit.fromJson(Map<String, dynamic> json) {
    return AssociationUnit(
      id: _intValue(json['id']),
      buildingId: _intValue(json['building_id']),
      unitNumber: _stringValue(json['unit_number']),
      floorNumber: _intValue(json['floor_number']),
      orientation: _stringValue(json['orientation']),
      orientationLabel: _stringValue(json['orientation_label']),
      area: _numValue(json['area']),
      gardenTerraceArea: _numValue(json['garden_terrace_area']),
      price: _numValue(json['price']),
      specifications: _stringValue(json['specifications']),
      unitPlanUrl: _stringValue(json['unit_plan_url']),
      status: _stringValue(json['status']),
      statusLabel: _stringValue(json['status_label']),
      building: _mapOrNull(json['building'], AssociationBuilding.fromJson),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'building_id': buildingId,
      'unit_number': unitNumber,
      'floor_number': floorNumber,
      'orientation': orientation,
      'orientation_label': orientationLabel,
      'area': area,
      'garden_terrace_area': gardenTerraceArea,
      'price': price,
      'specifications': specifications,
      'unit_plan_url': unitPlanUrl,
      'status': status,
      'status_label': statusLabel,
      'building': building?.toJson(),
    };
  }
}

class MembershipLifecycle {
  const MembershipLifecycle({
    required this.stage,
    required this.title,
    required this.message,
    required this.statusLabel,
    required this.canSubmitRequest,
    required this.canRequestProfileUpdate,
    required this.showSubmitButton,
    this.adminNotes = '',
    this.associationMember,
    this.membership,
  });

  final String stage;
  final String title;
  final String message;
  final String statusLabel;
  final bool canSubmitRequest;
  final bool canRequestProfileUpdate;
  final bool showSubmitButton;
  final String adminNotes;
  final LifecycleAssociationMember? associationMember;
  final LifecycleMembership? membership;

  factory MembershipLifecycle.fromJson(Map<String, dynamic> json) {
    return MembershipLifecycle(
      stage: _stringValue(json['stage']),
      title: _stringValue(json['title']),
      message: _stringValue(json['message']),
      statusLabel: _stringValue(json['status_label']),
      canSubmitRequest: _boolValue(json['can_submit_request']),
      canRequestProfileUpdate: _boolValue(json['can_request_profile_update']),
      showSubmitButton: _boolValue(json['show_submit_button']),
      adminNotes: _stringValue(json['admin_notes']),
      associationMember: _mapOrNull(
        json['association_member'],
        LifecycleAssociationMember.fromJson,
      ),
      membership: _mapOrNull(json['membership'], LifecycleMembership.fromJson),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stage': stage,
      'title': title,
      'message': message,
      'status_label': statusLabel,
      'can_submit_request': canSubmitRequest,
      'can_request_profile_update': canRequestProfileUpdate,
      'show_submit_button': showSubmitButton,
      'admin_notes': adminNotes,
      'association_member': associationMember?.toJson(),
      'membership': membership?.toJson(),
    };
  }
}

class LifecycleAssociationMember {
  const LifecycleAssociationMember({
    this.membershipNumber = '',
    this.priorityNumber,
    this.priorityStatus = '',
    this.priorityStatusLabel = '',
    this.joinDate = '',
    this.admitted = false,
  });

  final String membershipNumber;
  final int? priorityNumber;
  final String priorityStatus;
  final String priorityStatusLabel;
  final String joinDate;
  final bool admitted;

  factory LifecycleAssociationMember.fromJson(Map<String, dynamic> json) {
    return LifecycleAssociationMember(
      membershipNumber: _stringValue(json['membership_number']),
      priorityNumber: _intValue(json['priority_number']),
      priorityStatus: _stringValue(json['priority_status']),
      priorityStatusLabel: _stringValue(json['priority_status_label']),
      joinDate: _stringValue(json['join_date']),
      admitted: _boolValue(json['admitted']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'membership_number': membershipNumber,
      'priority_number': priorityNumber,
      'priority_status': priorityStatus,
      'priority_status_label': priorityStatusLabel,
      'join_date': joinDate,
      'admitted': admitted,
    };
  }
}

class LifecycleMembership {
  const LifecycleMembership({
    this.membershipNumber = '',
    this.projectName = '',
    this.projectType = '',
    this.subscriptionDate = '',
    this.unitNumber = '',
    this.buildingName = '',
    this.floor,
    this.area,
  });

  final String membershipNumber;
  final String projectName;
  final String projectType;
  final String subscriptionDate;
  final String unitNumber;
  final String buildingName;
  final int? floor;
  final num? area;

  factory LifecycleMembership.fromJson(Map<String, dynamic> json) {
    return LifecycleMembership(
      membershipNumber: _stringValue(json['membership_number']),
      projectName: _stringValue(json['project_name']),
      projectType: _stringValue(json['project_type']),
      subscriptionDate: _stringValue(json['subscription_date']),
      unitNumber: _stringValue(json['unit_number']),
      buildingName: _stringValue(json['building_name']),
      floor: _intValue(json['floor']),
      area: _numValue(json['area']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'membership_number': membershipNumber,
      'project_name': projectName,
      'project_type': projectType,
      'subscription_date': subscriptionDate,
      'unit_number': unitNumber,
      'building_name': buildingName,
      'floor': floor,
      'area': area,
    };
  }
}

T? _mapOrNull<T>(Object? raw, T Function(Map<String, dynamic>) fromJson) {
  if (raw is Map<String, dynamic>) return fromJson(raw);
  if (raw is Map) return fromJson(Map<String, dynamic>.from(raw));
  return null;
}

List<T> _listOf<T>(Object? raw, T Function(Map<String, dynamic>) fromJson) {
  if (raw is! List) return const [];
  return raw
      .whereType<Map>()
      .map((item) => fromJson(Map<String, dynamic>.from(item)))
      .toList();
}

List<Map<String, dynamic>> _mapList(Object? raw) {
  if (raw is! List) return const [];
  return raw
      .whereType<Map>()
      .map((item) => Map<String, dynamic>.from(item))
      .toList();
}

List<String> _stringList(Object? raw) {
  if (raw is! List) return const [];
  return raw.map(_stringValue).where((item) => item.isNotEmpty).toList();
}

Map<String, String> _stringMap(Object? raw) {
  if (raw is! Map) return const {};
  return raw.map((key, value) => MapEntry(key.toString(), _stringValue(value)));
}

String _stringValue(Object? value) {
  if (value == null) return '';
  final text = value.toString().trim();
  return text == 'null' ? '' : text;
}

bool _boolValue(Object? value) {
  if (value is bool) return value;
  final text = _stringValue(value).toLowerCase();
  return text == 'true' || text == '1' || text == 'yes';
}

int? _intValue(Object? value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(_stringValue(value));
}

num? _numValue(Object? value) {
  if (value is num) return value;
  return num.tryParse(_stringValue(value));
}
