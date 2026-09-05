class AssociationMemberProfileModel {
  const AssociationMemberProfileModel({
    this.associationRequestStatus = '',
    this.lifecycleStage = '',
    this.associationMemberStatus = '',
    this.canRequestMembershipInfoEdit = false,
    this.hasPendingProfileEditRequest = false,
    this.documents = const [],
    this.addresses,
    this.associationInformation,
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

  final String associationRequestStatus;
  final String lifecycleStage;
  final String associationMemberStatus;
  final bool canRequestMembershipInfoEdit;
  final bool hasPendingProfileEditRequest;
  final List<AssociationMembershipDocument> documents;
  final AssociationProfileAddresses? addresses;
  final AssociationInformation? associationInformation;
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

  bool get canSubmitAssociationRequest =>
      membershipLifecycle?.canSubmitRequest ?? false;

  factory AssociationMemberProfileModel.fromJson(Map<String, dynamic> json) {
    final association = _mapValue(json['association']) ?? json;
    final memberships = _membershipsWithAssociationFlags(
      json['memberships'],
      association['memberships'],
    );

    return AssociationMemberProfileModel(
      associationRequestStatus: _stringValue(
        json['association_request_status'],
      ),
      lifecycleStage: _stringValue(json['lifecycle_stage']),
      associationMemberStatus: _stringValue(json['association_member_status']),
      canRequestMembershipInfoEdit: _boolValue(
        json['can_request_membership_info_edit'],
      ),
      hasPendingProfileEditRequest: _boolValue(
        json['has_pending_profile_edit_request'],
      ),
      documents: _listOf(
        json['documents'],
        AssociationMembershipDocument.fromJson,
      ),
      addresses: _mapOrNull(
        json['addresses'],
        AssociationProfileAddresses.fromJson,
      ),
      associationInformation: _mapOrNull(
        json['association_information'],
        AssociationInformation.fromJson,
      ),
      isLinkedPerson:
          _boolValue(association['is_linked_person']) ||
          _mapValue(association['person']) != null,
      isAssociationMember: _boolValue(association['is_association_member']),
      hasPendingAssociationMembershipRequest: _boolValue(
        association['has_pending_association_membership_request'],
      ),
      isAssignedToProjects: _boolValue(association['is_assigned_to_projects']),
      isAssignedToUnits: _boolValue(association['is_assigned_to_units']),
      hasActiveMemberships: _boolValue(association['has_active_memberships']),
      registrationProfile: _mapOrNull(
        association['registration_profile'],
        ProfileCompletion.fromJson,
      ),
      bindingProfile: _mapOrNull(
        association['binding_profile'],
        BindingProfile.fromJson,
      ),
      person:
          _mapOrNull(association['person'], AssociationPerson.fromJson) ??
          const AssociationPerson(),
      associationMember: _mapOrNull(
        association['association_member'],
        AssociationCoreMember.fromJson,
      ),
      memberships: memberships,
      projects: _listOf(association['projects'], AssociationProject.fromJson),
      latestAssociationMembershipRequest:
          association['latest_association_membership_request'],
      membershipLifecycle: _mapOrNull(
        association['membership_lifecycle'],
        MembershipLifecycle.fromJson,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'association_request_status': associationRequestStatus,
      'lifecycle_stage': lifecycleStage,
      'association_member_status': associationMemberStatus,
      'can_request_membership_info_edit': canRequestMembershipInfoEdit,
      'has_pending_profile_edit_request': hasPendingProfileEditRequest,
      'documents': documents.map((item) => item.toJson()).toList(),
      'addresses': addresses?.toJson(),
      'association_information': associationInformation?.toJson(),
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

class AssociationProfileAddresses {
  const AssociationProfileAddresses({
    this.permanent,
    this.current,
    this.additional = const [],
  });

  final Map<String, dynamic>? permanent;
  final Map<String, dynamic>? current;
  final List<Map<String, dynamic>> additional;

  factory AssociationProfileAddresses.fromJson(Map<String, dynamic> json) {
    return AssociationProfileAddresses(
      permanent: _mapValue(json['permanent']),
      current: _mapValue(json['current']),
      additional: _mapList(json['additional']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'permanent': permanent,
      'current': current,
      'additional': additional,
    };
  }
}

class AssociationInformation {
  const AssociationInformation({
    this.membershipNumber = '',
    this.priorityNumber,
    this.associationJoinDate = '',
    this.membershipType = '',
    this.membershipTypeLabel = '',
    this.currentAssociationStatus = '',
    this.currentAssociationStatusLabel = '',
  });

  final String membershipNumber;
  final int? priorityNumber;
  final String associationJoinDate;
  final String membershipType;
  final String membershipTypeLabel;
  final String currentAssociationStatus;
  final String currentAssociationStatusLabel;

  factory AssociationInformation.fromJson(Map<String, dynamic> json) {
    return AssociationInformation(
      membershipNumber: _stringValue(json['membership_number']),
      priorityNumber: _intValue(json['priority_number']),
      associationJoinDate: _stringValue(json['association_join_date']),
      membershipType: _stringValue(json['membership_type']),
      membershipTypeLabel: _stringValue(json['membership_type_label']),
      currentAssociationStatus: _stringValue(
        json['current_association_status'],
      ),
      currentAssociationStatusLabel: _stringValue(
        json['current_association_status_label'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'membership_number': membershipNumber,
      'priority_number': priorityNumber,
      'association_join_date': associationJoinDate,
      'membership_type': membershipType,
      'membership_type_label': membershipTypeLabel,
      'current_association_status': currentAssociationStatus,
      'current_association_status_label': currentAssociationStatusLabel,
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
    this.statusLabel = '',
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
    this.allocatedUnit,
    this.membershipDecision = '',
    this.joinDocuments = '',
    this.closedAt = '',
    this.project,
    this.financialInformation,
    this.payments = const [],
    this.financialObligations = const [],
    this.holderHistory = const [],
    this.documents = const [],
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
  final String statusLabel;
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
  final AssociationUnit? allocatedUnit;
  final String membershipDecision;
  final String joinDocuments;
  final String closedAt;
  final AssociationProject? project;
  final AssociationFinancialInformation? financialInformation;
  final List<AssociationPayment> payments;
  final List<AssociationFinancialObligation> financialObligations;
  final List<AssociationHolderHistory> holderHistory;
  final List<AssociationMembershipDocument> documents;
  final AssociationBuilding? building;
  final AssociationUnit? unit;
  final num? totalPaymentsMade;

  String get displayType {
    if (membershipTypeLabel.isNotEmpty) return membershipTypeLabel;
    return membershipType;
  }

  String get displayStatus {
    if (membershipStatusLabel.isNotEmpty) return membershipStatusLabel;
    if (statusLabel.isNotEmpty) return statusLabel;
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
      statusLabel: _stringValue(json['status_label']),
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
      allocatedUnit: _mapOrNull(
        json['allocated_unit'],
        AssociationUnit.fromJson,
      ),
      membershipDecision: _stringValue(json['membership_decision']),
      joinDocuments: _stringValue(json['join_documents']),
      closedAt: _stringValue(json['closed_at']),
      project: _mapOrNull(json['project'], AssociationProject.fromJson),
      financialInformation: _mapOrNull(
        json['financial_information'],
        AssociationFinancialInformation.fromJson,
      ),
      payments: _listOf(json['payments'], AssociationPayment.fromJson),
      financialObligations: _listOf(
        json['financial_obligations'],
        AssociationFinancialObligation.fromJson,
      ),
      holderHistory: _listOf(
        json['holder_history'],
        AssociationHolderHistory.fromJson,
      ),
      documents: _listOf(
        json['documents'],
        AssociationMembershipDocument.fromJson,
      ),
      building: _mapOrNull(json['building'], AssociationBuilding.fromJson),
      unit: _mapOrNull(json['unit'], AssociationUnit.fromJson),
      totalPaymentsMade:
          _numValue(json['total_payments_made']) ??
          _numValue(
            json['financial_information'] is Map
                ? (json['financial_information'] as Map)['total_payments']
                : null,
          ),
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
      'status_label': statusLabel,
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
      'allocated_unit': allocatedUnit?.toJson(),
      'membership_decision': membershipDecision,
      'join_documents': joinDocuments,
      'closed_at': closedAt,
      'project': project?.toJson(),
      'financial_information': financialInformation?.toJson(),
      'payments': payments.map((item) => item.toJson()).toList(),
      'financial_obligations': financialObligations
          .map((item) => item.toJson())
          .toList(),
      'holder_history': holderHistory.map((item) => item.toJson()).toList(),
      'documents': documents.map((item) => item.toJson()).toList(),
      'building': building?.toJson(),
      'unit': unit?.toJson(),
      'total_payments_made': totalPaymentsMade,
    };
  }
}

List<AssociationMembership> _membershipsWithAssociationFlags(
  Object? topLevelRaw,
  Object? associationRaw,
) {
  final topLevelItems = _mapList(topLevelRaw);
  final associationItems = _mapList(associationRaw);

  if (topLevelItems.isEmpty) {
    return associationItems.map(AssociationMembership.fromJson).toList();
  }
  if (associationItems.isEmpty) {
    return topLevelItems.map(AssociationMembership.fromJson).toList();
  }

  final associationByKey = <String, Map<String, dynamic>>{};
  for (final item in associationItems) {
    final key = _membershipKey(item);
    if (key.isNotEmpty) associationByKey[key] = item;
  }

  return topLevelItems.map((item) {
    final associationItem = associationByKey[_membershipKey(item)];
    if (associationItem == null) return AssociationMembership.fromJson(item);

    final mergedItem = Map<String, dynamic>.from(item);
    for (final key in const [
      'is_active',
      'is_assigned_to_project',
      'is_assigned_to_unit',
      'building',
      'unit',
      'total_payments_made',
    ]) {
      if (associationItem.containsKey(key)) {
        mergedItem[key] = associationItem[key];
      }
    }

    return AssociationMembership.fromJson(mergedItem);
  }).toList();
}

String _membershipKey(Map<String, dynamic> item) {
  final id = _stringValue(item['id']);
  if (id.isNotEmpty) return 'id:$id';

  final membershipNumber = _stringValue(item['membership_number']);
  return membershipNumber.isEmpty ? '' : 'number:$membershipNumber';
}

class AssociationFinancialInformation {
  const AssociationFinancialInformation({
    this.totalPayments,
    this.totalObligations,
    this.coveredObligations,
    this.uncoveredObligations,
    this.openObligationsCount,
    this.overdueObligationsCount,
    this.overdueObligationsAmount,
    this.availableBalance,
    this.currentBalance,
    this.memberFinancialStatus = '',
    this.memberFinancialStatusLabel = '',
    this.totalPaid,
    this.remainingAmount,
    this.pendingObligations,
  });

  final num? totalPayments;
  final num? totalObligations;
  final num? coveredObligations;
  final num? uncoveredObligations;
  final int? openObligationsCount;
  final int? overdueObligationsCount;
  final num? overdueObligationsAmount;
  final num? availableBalance;
  final num? currentBalance;
  final String memberFinancialStatus;
  final String memberFinancialStatusLabel;
  final num? totalPaid;
  final num? remainingAmount;
  final num? pendingObligations;

  factory AssociationFinancialInformation.fromJson(Map<String, dynamic> json) {
    return AssociationFinancialInformation(
      totalPayments: _numValue(json['total_payments']),
      totalObligations: _numValue(json['total_obligations']),
      coveredObligations: _numValue(json['covered_obligations']),
      uncoveredObligations: _numValue(json['uncovered_obligations']),
      openObligationsCount: _intValue(json['open_obligations_count']),
      overdueObligationsCount: _intValue(json['overdue_obligations_count']),
      overdueObligationsAmount: _numValue(json['overdue_obligations_amount']),
      availableBalance: _numValue(json['available_balance']),
      currentBalance: _numValue(json['current_balance']),
      memberFinancialStatus: _stringValue(json['member_financial_status']),
      memberFinancialStatusLabel: _stringValue(
        json['member_financial_status_label'],
      ),
      totalPaid: _numValue(json['total_paid']),
      remainingAmount: _numValue(json['remaining_amount']),
      pendingObligations: _numValue(json['pending_obligations']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_payments': totalPayments,
      'total_obligations': totalObligations,
      'covered_obligations': coveredObligations,
      'uncovered_obligations': uncoveredObligations,
      'open_obligations_count': openObligationsCount,
      'overdue_obligations_count': overdueObligationsCount,
      'overdue_obligations_amount': overdueObligationsAmount,
      'available_balance': availableBalance,
      'current_balance': currentBalance,
      'member_financial_status': memberFinancialStatus,
      'member_financial_status_label': memberFinancialStatusLabel,
      'total_paid': totalPaid,
      'remaining_amount': remainingAmount,
      'pending_obligations': pendingObligations,
    };
  }
}

class AssociationPayment {
  const AssociationPayment({
    this.id,
    this.paymentDate = '',
    this.amount,
    this.paymentMethod = '',
    this.paymentMethodLabel = '',
    this.voucherNumber = '',
    this.approvalStatus = '',
    this.approvalStatusLabel = '',
    this.notes = '',
  });

  final int? id;
  final String paymentDate;
  final num? amount;
  final String paymentMethod;
  final String paymentMethodLabel;
  final String voucherNumber;
  final String approvalStatus;
  final String approvalStatusLabel;
  final String notes;

  factory AssociationPayment.fromJson(Map<String, dynamic> json) {
    return AssociationPayment(
      id: _intValue(json['id']),
      paymentDate: _stringValue(json['payment_date']),
      amount: _numValue(json['amount']),
      paymentMethod: _stringValue(json['payment_method']),
      paymentMethodLabel: _stringValue(json['payment_method_label']),
      voucherNumber: _stringValue(json['voucher_number']),
      approvalStatus: _stringValue(json['approval_status']),
      approvalStatusLabel: _stringValue(json['approval_status_label']),
      notes: _stringValue(json['notes']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'payment_date': paymentDate,
      'amount': amount,
      'payment_method': paymentMethod,
      'payment_method_label': paymentMethodLabel,
      'voucher_number': voucherNumber,
      'approval_status': approvalStatus,
      'approval_status_label': approvalStatusLabel,
      'notes': notes,
    };
  }
}

class AssociationFinancialObligation {
  const AssociationFinancialObligation({
    this.id,
    this.name = '',
    this.amount,
    this.dueDate = '',
    this.paymentDeadline = '',
    this.status = '',
    this.statusLabel = '',
    this.isCovered = false,
  });

  final int? id;
  final String name;
  final num? amount;
  final String dueDate;
  final String paymentDeadline;
  final String status;
  final String statusLabel;
  final bool isCovered;

  factory AssociationFinancialObligation.fromJson(Map<String, dynamic> json) {
    return AssociationFinancialObligation(
      id: _intValue(json['id']),
      name: _stringValue(json['name']),
      amount: _numValue(json['amount']),
      dueDate: _stringValue(json['due_date']),
      paymentDeadline: _stringValue(json['payment_deadline']),
      status: _stringValue(json['status']),
      statusLabel: _stringValue(json['status_label']),
      isCovered: _boolValue(json['is_covered']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'due_date': dueDate,
      'payment_deadline': paymentDeadline,
      'status': status,
      'status_label': statusLabel,
      'is_covered': isCovered,
    };
  }
}

class AssociationHolderHistory {
  const AssociationHolderHistory({
    this.holderName = '',
    this.holderStartDate = '',
    this.holderEndDate = '',
    this.reason = '',
    this.reasonLabel = '',
    this.referenceDecision = '',
    this.notes = '',
    this.isCurrent = false,
  });

  final String holderName;
  final String holderStartDate;
  final String holderEndDate;
  final String reason;
  final String reasonLabel;
  final String referenceDecision;
  final String notes;
  final bool isCurrent;

  factory AssociationHolderHistory.fromJson(Map<String, dynamic> json) {
    return AssociationHolderHistory(
      holderName: _stringValue(json['holder_name']),
      holderStartDate: _stringValue(json['holder_start_date']),
      holderEndDate: _stringValue(json['holder_end_date']),
      reason: _stringValue(json['reason']),
      reasonLabel: _stringValue(json['reason_label']),
      referenceDecision: _stringValue(json['reference_decision']),
      notes: _stringValue(json['notes']),
      isCurrent: _boolValue(json['is_current']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'holder_name': holderName,
      'holder_start_date': holderStartDate,
      'holder_end_date': holderEndDate,
      'reason': reason,
      'reason_label': reasonLabel,
      'reference_decision': referenceDecision,
      'notes': notes,
      'is_current': isCurrent,
    };
  }
}

class AssociationMembershipDocument {
  const AssociationMembershipDocument({
    this.documentType = '',
    this.documentTypeLabel = '',
    this.status = '',
    this.uploadDate = '',
    this.previewUrl = '',
    this.downloadUrl = '',
  });

  final String documentType;
  final String documentTypeLabel;
  final String status;
  final String uploadDate;
  final String previewUrl;
  final String downloadUrl;

  factory AssociationMembershipDocument.fromJson(Map<String, dynamic> json) {
    return AssociationMembershipDocument(
      documentType: _stringValue(json['document_type']),
      documentTypeLabel: _stringValue(json['document_type_label']),
      status: _stringValue(json['status']),
      uploadDate: _stringValue(json['upload_date']),
      previewUrl: _stringValue(json['preview_url']),
      downloadUrl: _stringValue(json['download_url']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'document_type': documentType,
      'document_type_label': documentTypeLabel,
      'status': status,
      'upload_date': uploadDate,
      'preview_url': previewUrl,
      'download_url': downloadUrl,
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
    this.statusLabel = '',
    this.subtitle = '',
    this.subtitleTranslations = const {},
    this.imageUrl = '',
    this.images = const [],
    this.galleryImages = const [],
    this.galleryItems = const [],
    this.videos = const [],
    this.videoItems = const [],
    this.latitude,
    this.longitude,
    this.governorate = '',
    this.region = '',
    this.address = '',
    this.completionPercentage,
    this.numberOfBuildings,
    this.totalNumberOfUnits,
    this.launchDate = '',
    this.licenseNumber = '',
    this.licenseDate = '',
    this.estimatedCost,
    this.estimatedDurationMonths,
    this.projectEngineer = '',
    this.numberOfApartments,
    this.landArea,
    this.licensedBuildingArea,
    this.masterPlanUrl = '',
    this.isActive = false,
    this.totalUnits,
    this.availableUnits,
    this.allocatedUnits,
    this.deliveredUnits,
    this.remainingUnits,
    this.createdAt = '',
    this.stages = const [],
    this.buildings = const [],
  });

  final int? id;
  final String name;
  final String type;
  final String typeLabel;
  final num? price;
  final String status;
  final String statusLabel;
  final String subtitle;
  final Map<String, String> subtitleTranslations;
  final String imageUrl;
  final List<String> images;
  final List<String> galleryImages;
  final List<AssociationMediaItem> galleryItems;
  final List<String> videos;
  final List<AssociationMediaItem> videoItems;
  final num? latitude;
  final num? longitude;
  final String governorate;
  final String region;
  final String address;
  final num? completionPercentage;
  final int? numberOfBuildings;
  final int? totalNumberOfUnits;
  final String launchDate;
  final String licenseNumber;
  final String licenseDate;
  final num? estimatedCost;
  final int? estimatedDurationMonths;
  final String projectEngineer;
  final int? numberOfApartments;
  final num? landArea;
  final num? licensedBuildingArea;
  final String masterPlanUrl;
  final bool isActive;
  final int? totalUnits;
  final int? availableUnits;
  final int? allocatedUnits;
  final int? deliveredUnits;
  final int? remainingUnits;
  final String createdAt;
  final List<StageModel> stages;
  final List<AssociationBuilding> buildings;

  String get displayStatus {
    if (statusLabel.isNotEmpty &&
        !statusLabel.startsWith('panel.') &&
        !statusLabel.contains('.')) {
      return statusLabel;
    }
    return status;
  }

  List<String> get allImages {
    return [
      imageUrl,
      ...images,
      ...galleryImages,
      masterPlanUrl,
    ].where((item) => item.trim().isNotEmpty).toSet().toList();
  }

  factory AssociationProject.fromJson(Map<String, dynamic> json) {
    return AssociationProject(
      id: _intValue(json['id']),
      name: _stringValue(json['name']),
      type: _stringValue(json['type']),
      typeLabel: _stringValue(json['type_label']),
      price: _numValue(json['price']),
      status: _stringValue(json['status']),
      statusLabel: _stringValue(json['status_label']),
      subtitle: _stringValue(json['subtitle']),
      subtitleTranslations: _stringMap(json['subtitle_translations']),
      imageUrl: _stringValue(json['image_url']),
      images: _mediaUrlList(json['images']),
      galleryImages: _mediaUrlList(json['gallery_images']),
      galleryItems: _mergedAssociationMediaItems([
        json['image_url'],
        json['images'],
        json['gallery_images'],
        json['gallery_items'],
      ], isVideo: false),
      videos: _mergedMediaUrlList([
        json['videos'],
        json['gallery_videos'],
        json['media_videos'],
        json['video_urls'],
      ]),
      videoItems: _mergedAssociationMediaItems([
        json['videos'],
        json['gallery_videos'],
        json['media_videos'],
        json['video_urls'],
      ], isVideo: true),
      latitude: _numValue(json['latitude']),
      longitude: _numValue(json['longitude']),
      governorate: _stringValue(json['governorate']),
      region: _stringValue(json['region']),
      address: _stringValue(json['address']),
      completionPercentage: _numValue(json['completion_percentage']),
      numberOfBuildings: _intValue(json['number_of_buildings']),
      totalNumberOfUnits: _intValue(json['total_number_of_units']),
      launchDate: _stringValue(json['launch_date']),
      licenseNumber: _stringValue(json['license_number']),
      licenseDate: _stringValue(json['license_date']),
      estimatedCost: _numValue(json['estimated_cost']),
      estimatedDurationMonths: _intValue(json['estimated_duration_months']),
      projectEngineer: _stringValue(json['project_engineer']),
      numberOfApartments: _intValue(json['number_of_apartments']),
      landArea: _numValue(json['land_area']),
      licensedBuildingArea: _numValue(json['licensed_building_area']),
      masterPlanUrl: _stringValue(json['master_plan_url']),
      isActive: _boolValue(json['is_active']),
      totalUnits: _intValue(json['total_units']),
      availableUnits: _intValue(json['available_units']),
      allocatedUnits: _intValue(json['allocated_units']),
      deliveredUnits: _intValue(json['delivered_units']),
      remainingUnits: _intValue(json['remaining_units']),
      createdAt: _stringValue(json['created_at']),
      stages: _listOf(json['stages'], StageModel.fromJson),
      buildings: _listOf(json['buildings'], AssociationBuilding.fromJson),
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
      'status_label': statusLabel,
      'subtitle': subtitle,
      'subtitle_translations': subtitleTranslations,
      'image_url': imageUrl,
      'images': images,
      'gallery_images': galleryImages,
      'gallery_items': galleryItems.map((item) => item.toJson()).toList(),
      'videos': videos,
      'video_items': videoItems.map((item) => item.toJson()).toList(),
      'latitude': latitude,
      'longitude': longitude,
      'governorate': governorate,
      'region': region,
      'address': address,
      'completion_percentage': completionPercentage,
      'number_of_buildings': numberOfBuildings,
      'total_number_of_units': totalNumberOfUnits,
      'launch_date': launchDate,
      'license_number': licenseNumber,
      'license_date': licenseDate,
      'estimated_cost': estimatedCost,
      'estimated_duration_months': estimatedDurationMonths,
      'project_engineer': projectEngineer,
      'number_of_apartments': numberOfApartments,
      'land_area': landArea,
      'licensed_building_area': licensedBuildingArea,
      'master_plan_url': masterPlanUrl,
      'is_active': isActive,
      'total_units': totalUnits,
      'available_units': availableUnits,
      'allocated_units': allocatedUnits,
      'delivered_units': deliveredUnits,
      'remaining_units': remainingUnits,
      'created_at': createdAt,
      'stages': stages.map((item) => item.toJson()).toList(),
      'buildings': buildings.map((item) => item.toJson()).toList(),
    };
  }
}

class AssociationBuilding {
  const AssociationBuilding({
    this.id,
    this.projectId,
    this.buildingNumber,
    this.name,
    this.description,
    this.physicalAddress,
    this.latitude,
    this.longitude,
    this.numberOfFloors,
    this.numberOfUnits,
    this.buildingPlanUrl,
    this.floorPlanImages = const [],
    this.galleryImages = const [],
    this.galleryItems = const [],
    this.videos = const [],
    this.videoItems = const [],
    this.specifications,
    this.completionPercentage,
    this.totalUnits,
    this.availableUnits,
    this.allocatedUnits,
    this.deliveredUnits,
    this.units = const [],
    this.stages = const [],
  });

  final int? id;
  final int? projectId;
  final String? buildingNumber;
  final String? name;
  final String? description;
  final String? physicalAddress;
  final num? latitude;
  final num? longitude;
  final int? numberOfFloors;
  final int? numberOfUnits;
  final String? buildingPlanUrl;
  final List<String> floorPlanImages;
  final List<String> galleryImages;
  final List<AssociationMediaItem> galleryItems;
  final List<String> videos;
  final List<AssociationMediaItem> videoItems;
  final String? specifications;
  final num? completionPercentage;
  final int? totalUnits;
  final int? availableUnits;
  final int? allocatedUnits;
  final int? deliveredUnits;
  final List<AssociationUnit> units;
  final List<StageModel> stages;

  String get displayName {
    final buildingName = name?.trim() ?? '';
    if (buildingName.isNotEmpty) return buildingName;
    return buildingNumber?.trim() ?? '';
  }

  List<String> get allImages {
    return [
      buildingPlanUrl ?? '',
      ...floorPlanImages,
      ...galleryImages,
    ].where((item) => item.trim().isNotEmpty).toSet().toList();
  }

  factory AssociationBuilding.fromJson(Map<String, dynamic> json) {
    return AssociationBuilding(
      id: _intValue(json['id']),
      projectId: _intValue(json['project_id']),
      buildingNumber: _stringOrNull(json['building_number']),
      name: _stringOrNull(json['name']),
      description: _stringOrNull(json['description']),
      physicalAddress: _stringOrNull(json['physical_address']),
      latitude: _numValue(json['latitude']),
      longitude: _numValue(json['longitude']),
      numberOfFloors: _intValue(json['number_of_floors']),
      numberOfUnits: _intValue(json['number_of_units']),
      buildingPlanUrl: _stringOrNull(json['building_plan_url']),
      floorPlanImages: _mediaUrlList(json['floor_plan_images']),
      galleryImages: _mediaUrlList(json['gallery_images']),
      galleryItems: _mergedAssociationMediaItems([
        json['building_plan_url'],
        json['floor_plan_images'],
        json['gallery_images'],
        json['gallery_items'],
      ], isVideo: false),
      videos: _mergedMediaUrlList([
        json['videos'],
        json['gallery_videos'],
        json['media_videos'],
        json['video_urls'],
      ]),
      videoItems: _mergedAssociationMediaItems([
        json['videos'],
        json['gallery_videos'],
        json['media_videos'],
        json['video_urls'],
      ], isVideo: true),
      specifications: _stringOrNull(json['specifications']),
      completionPercentage: _numValue(json['completion_percentage']),
      totalUnits: _intValue(json['total_units']),
      availableUnits: _intValue(json['available_units']),
      allocatedUnits: _intValue(json['allocated_units']),
      deliveredUnits: _intValue(json['delivered_units']),
      units: _listOf(
        json['units'] ??
            json['residential_units'] ??
            json['housing_units'] ??
            json['apartments'],
        AssociationUnit.fromJson,
      ),
      stages: _listOf(json['stages'], StageModel.fromJson),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'project_id': projectId,
      'building_number': buildingNumber,
      'name': name,
      'description': description,
      'physical_address': physicalAddress,
      'latitude': latitude,
      'longitude': longitude,
      'number_of_floors': numberOfFloors,
      'number_of_units': numberOfUnits,
      'building_plan_url': buildingPlanUrl,
      'floor_plan_images': floorPlanImages,
      'gallery_images': galleryImages,
      'gallery_items': galleryItems.map((item) => item.toJson()).toList(),
      'videos': videos,
      'video_items': videoItems.map((item) => item.toJson()).toList(),
      'specifications': specifications,
      'completion_percentage': completionPercentage,
      'total_units': totalUnits,
      'available_units': availableUnits,
      'allocated_units': allocatedUnits,
      'delivered_units': deliveredUnits,
      'units': units.map((item) => item.toJson()).toList(),
      'stages': stages.map((item) => item.toJson()).toList(),
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
    this.galleryImages = const [],
    this.images = const [],
    this.galleryItems = const [],
    this.videos = const [],
    this.videoItems = const [],
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
  final List<String> galleryImages;
  final List<String> images;
  final List<AssociationMediaItem> galleryItems;
  final List<String> videos;
  final List<AssociationMediaItem> videoItems;
  final String status;
  final String statusLabel;
  final AssociationBuilding? building;

  List<String> get allImages {
    return [
      unitPlanUrl,
      ...images,
      ...galleryImages,
    ].where((item) => item.trim().isNotEmpty).toSet().toList();
  }

  factory AssociationUnit.fromJson(Map<String, dynamic> json) {
    return AssociationUnit(
      id: _intValue(json['id']),
      buildingId: _intValue(json['building_id']),
      unitNumber: _stringValue(json['unit_number']),
      floorNumber: _intValue(json['floor_number'] ?? json['floor']),
      orientation: _stringValue(json['orientation']),
      orientationLabel: _stringValue(json['orientation_label']),
      area: _numValue(json['area'] ?? json['unit_area']),
      gardenTerraceArea: _numValue(json['garden_terrace_area']),
      price: _numValue(json['price']),
      specifications: _stringValue(json['specifications']),
      unitPlanUrl: _stringValue(json['unit_plan_url']),
      galleryImages: _mediaUrlList(json['gallery_images']),
      images: _mediaUrlList(json['images']),
      galleryItems: _mergedAssociationMediaItems([
        json['unit_plan_url'],
        json['images'],
        json['gallery_images'],
        json['gallery_items'],
      ], isVideo: false),
      videos: _mergedMediaUrlList([
        json['videos'],
        json['gallery_videos'],
        json['media_videos'],
        json['video_urls'],
      ]),
      videoItems: _mergedAssociationMediaItems([
        json['videos'],
        json['gallery_videos'],
        json['media_videos'],
        json['video_urls'],
      ], isVideo: true),
      status: _stringValue(json['status'] ?? json['unit_status']),
      statusLabel: _stringValue(
        json['status_label'] ?? json['unit_status_label'],
      ),
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
      'gallery_images': galleryImages,
      'images': images,
      'gallery_items': galleryItems.map((item) => item.toJson()).toList(),
      'videos': videos,
      'video_items': videoItems.map((item) => item.toJson()).toList(),
      'status': status,
      'status_label': statusLabel,
      'building': building?.toJson(),
    };
  }
}

class AssociationMediaItem {
  const AssociationMediaItem({
    required this.url,
    required this.isVideo,
    this.thumbnailUrl = '',
    this.description = '',
    this.date = '',
  });

  final String url;
  final bool isVideo;
  final String thumbnailUrl;
  final String description;
  final String date;

  bool get hasDetails => description.isNotEmpty || date.isNotEmpty;

  factory AssociationMediaItem.fromJson(
    Map<String, dynamic> json, {
    bool? isVideo,
  }) {
    final url = _firstStringValue([
      json['url'],
      json['image_url'],
      json['video_url'],
      json['file_url'],
      json['download_url'],
      json['preview_url'],
      json['full_url'],
      json['media_url'],
      json['src'],
      json['path'],
      json['file'],
    ]);
    final isVideoValue =
        isVideo ??
        (_boolValue(json['is_video']) ||
            _stringValue(json['type']).toLowerCase().startsWith('video/') ||
            _looksLikeVideoUrl(url));

    return AssociationMediaItem(
      url: url,
      isVideo: isVideoValue,
      thumbnailUrl: _firstStringValue([
        json['thumbnail_url'],
        json['thumbnail'],
        json['preview_image_url'],
        json['poster_url'],
        json['poster'],
      ]),
      description: _firstStringValue([
        json['description'],
        json['caption'],
        json['title'],
        json['notes'],
      ]),
      date: _firstStringValue([
        json['date'],
        json['taken_at'],
        json['captured_at'],
        json['created_at'],
        json['updated_at'],
      ]),
    );
  }

  factory AssociationMediaItem.fromUrl(String url, {required bool isVideo}) {
    return AssociationMediaItem(url: url.trim(), isVideo: isVideo);
  }

  AssociationMediaItem mergeDetailsFrom(AssociationMediaItem other) {
    return AssociationMediaItem(
      url: url,
      isVideo: isVideo || other.isVideo,
      thumbnailUrl: thumbnailUrl.isNotEmpty ? thumbnailUrl : other.thumbnailUrl,
      description: description.isNotEmpty ? description : other.description,
      date: date.isNotEmpty ? date : other.date,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'is_video': isVideo,
      'thumbnail_url': thumbnailUrl,
      'description': description,
      'date': date,
    };
  }
}

class StageModel {
  const StageModel({
    this.id,
    this.stageDefinitionId,
    this.stageName,
    this.imageUrl,
    this.images = const [],
    this.galleryImages = const [],
    this.galleryItems = const [],
    this.videos = const [],
    this.videoItems = const [],
    this.startDate,
    this.endDate,
    this.completionPercentage,
    this.actualOrder,
    this.isActive,
    this.notes,
  });

  final int? id;
  final int? stageDefinitionId;
  final String? stageName;
  final String? imageUrl;
  final List<String> images;
  final List<String> galleryImages;
  final List<AssociationMediaItem> galleryItems;
  final List<String> videos;
  final List<AssociationMediaItem> videoItems;
  final String? startDate;
  final String? endDate;
  final num? completionPercentage;
  final int? actualOrder;
  final bool? isActive;
  final String? notes;

  List<String> get allImages {
    return [
      imageUrl ?? '',
      ...images,
      ...galleryImages,
    ].where((item) => item.trim().isNotEmpty).toSet().toList();
  }

  factory StageModel.fromJson(Map<String, dynamic> json) {
    return StageModel(
      id: _intValue(json['id']),
      stageDefinitionId: _intValue(json['stage_definition_id']),
      stageName: _stringOrNull(json['stage_name']),
      imageUrl: _stringOrNull(
        json['image_url'] ??
            json['image'] ??
            json['cover_image'] ??
            json['cover_image_url'],
      ),
      images: _mediaUrlList(json['images']),
      galleryImages: _mediaUrlList(
        json['gallery_images'] ??
            json['gallery'] ??
            json['photos'] ??
            json['media'],
      ),
      galleryItems: _mergedAssociationMediaItems([
        json['image_url'] ?? json['image'] ?? json['cover_image'],
        json['images'],
        json['gallery_images'],
        json['gallery_items'],
        json['gallery'],
        json['photos'],
        json['media'],
      ], isVideo: false),
      videos: _mergedMediaUrlList([
        json['videos'],
        json['gallery_videos'],
        json['media_videos'],
        json['video_urls'],
      ]),
      videoItems: _mergedAssociationMediaItems([
        json['videos'],
        json['gallery_videos'],
        json['media_videos'],
        json['video_urls'],
      ], isVideo: true),
      startDate: _stringOrNull(json['start_date']),
      endDate: _stringOrNull(json['end_date']),
      completionPercentage: _numValue(json['completion_percentage']),
      actualOrder: _intValue(json['actual_order']),
      isActive: _boolOrNull(json['is_active']),
      notes: _stringOrNull(json['notes']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'stage_definition_id': stageDefinitionId,
      'stage_name': stageName,
      'image_url': imageUrl,
      'images': images,
      'gallery_images': galleryImages,
      'gallery_items': galleryItems.map((item) => item.toJson()).toList(),
      'videos': videos,
      'video_items': videoItems.map((item) => item.toJson()).toList(),
      'start_date': startDate,
      'end_date': endDate,
      'completion_percentage': completionPercentage,
      'actual_order': actualOrder,
      'is_active': isActive,
      'notes': notes,
    };
  }
}

typedef AssociationProjectStage = StageModel;

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

Map<String, dynamic>? _mapValue(Object? raw) {
  if (raw is Map<String, dynamic>) return raw;
  if (raw is Map) return Map<String, dynamic>.from(raw);
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

List<String> _mediaUrlList(Object? raw) {
  if (raw is List) {
    return raw
        .expand(_mediaUrlList)
        .where((item) => item.isNotEmpty)
        .toSet()
        .toList();
  }

  if (raw is Map) {
    return [
      raw['url'],
      raw['image_url'],
      raw['video_url'],
      raw['file_url'],
      raw['download_url'],
      raw['preview_url'],
      raw['full_url'],
      raw['media_url'],
      raw['src'],
      raw['path'],
      raw['file'],
    ].map(_stringValue).where((item) => item.isNotEmpty).toSet().toList();
  }

  final value = _stringValue(raw);
  return value.isEmpty ? const [] : [value];
}

List<String> _mergedMediaUrlList(List<Object?> sources) {
  return sources.expand(_mediaUrlList).toSet().toList();
}

List<AssociationMediaItem> _associationMediaItems(
  Object? raw, {
  bool? isVideo,
}) {
  if (raw is List) {
    return raw
        .expand((item) => _associationMediaItems(item, isVideo: isVideo))
        .toList();
  }

  if (raw is Map) {
    final item = AssociationMediaItem.fromJson(
      Map<String, dynamic>.from(raw),
      isVideo: isVideo,
    );
    return item.url.isEmpty ? const [] : [item];
  }

  final url = _stringValue(raw);
  if (url.isEmpty) return const [];
  return [
    AssociationMediaItem.fromUrl(
      url,
      isVideo: isVideo ?? _looksLikeVideoUrl(url),
    ),
  ];
}

List<AssociationMediaItem> _mergedAssociationMediaItems(
  List<Object?> sources, {
  bool? isVideo,
}) {
  final itemsByUrl = <String, AssociationMediaItem>{};

  for (final item in sources.expand(
    (source) => _associationMediaItems(source, isVideo: isVideo),
  )) {
    final existing = itemsByUrl[item.url];
    itemsByUrl[item.url] = existing == null
        ? item
        : existing.mergeDetailsFrom(item);
  }

  return itemsByUrl.values.toList();
}

Map<String, String> _stringMap(Object? raw) {
  if (raw is! Map) return const {};
  return raw.map((key, value) => MapEntry(key.toString(), _stringValue(value)));
}

String _firstStringValue(List<Object?> values) {
  for (final value in values) {
    final text = _stringValue(value);
    if (text.isNotEmpty) return text;
  }
  return '';
}

String _stringValue(Object? value) {
  if (value == null) return '';
  final text = value.toString().trim();
  return text == 'null' ? '' : text;
}

String? _stringOrNull(Object? value) {
  final text = _stringValue(value);
  return text.isEmpty ? null : text;
}

bool _boolValue(Object? value) {
  if (value is bool) return value;
  final text = _stringValue(value).toLowerCase();
  return text == 'true' || text == '1' || text == 'yes';
}

bool? _boolOrNull(Object? value) {
  if (value == null) return null;
  if (value is bool) return value;
  final text = _stringValue(value).toLowerCase();
  if (text.isEmpty) return null;
  if (text == 'true' || text == '1' || text == 'yes') return true;
  if (text == 'false' || text == '0' || text == 'no') return false;
  return null;
}

bool _looksLikeVideoUrl(String url) {
  final normalized = url.split('?').first.split('#').first.trim().toLowerCase();
  const videoExtensions = [
    '.mp4',
    '.mov',
    '.m4v',
    '.webm',
    '.mkv',
    '.avi',
    '.wmv',
    '.flv',
    '.3gp',
    '.3gpp',
    '.mpeg',
    '.mpg',
    '.ogv',
  ];

  return videoExtensions.any(normalized.endsWith);
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
