class AssociationMemberProfileModel {
  final bool isLinkedPerson;
  final bool isAssociationMember;
  final bool hasPendingAssociationMembershipRequest;
  final bool isAssignedToProjects;
  final bool isAssignedToUnits;
  final bool hasActiveMemberships;

  final ProfileCompletion? registrationProfile;
  final BindingProfile? bindingProfile;

  final dynamic person;
  final dynamic associationMember;

  final List<dynamic> memberships;
  final List<dynamic> projects;

  final dynamic latestAssociationMembershipRequest;

  final MembershipLifecycle? membershipLifecycle;

  AssociationMemberProfileModel({
    required this.isLinkedPerson,
    required this.isAssociationMember,
    required this.hasPendingAssociationMembershipRequest,
    required this.isAssignedToProjects,
    required this.isAssignedToUnits,
    required this.hasActiveMemberships,
    this.registrationProfile,
    this.bindingProfile,
    this.person,
    this.associationMember,
    required this.memberships,
    required this.projects,
    this.latestAssociationMembershipRequest,
    this.membershipLifecycle,
  });

  factory AssociationMemberProfileModel.fromJson(Map<String, dynamic> json) {
    return AssociationMemberProfileModel(
      isLinkedPerson: json['is_linked_person'] ?? false,
      isAssociationMember: json['is_association_member'] ?? false,
      hasPendingAssociationMembershipRequest:
          json['has_pending_association_membership_request'] ?? false,
      isAssignedToProjects: json['is_assigned_to_projects'] ?? false,
      isAssignedToUnits: json['is_assigned_to_units'] ?? false,
      hasActiveMemberships: json['has_active_memberships'] ?? false,
      registrationProfile: json['registration_profile'] != null
          ? ProfileCompletion.fromJson(json['registration_profile'])
          : null,
      bindingProfile: json['binding_profile'] != null
          ? BindingProfile.fromJson(json['binding_profile'])
          : null,
      person: json['person'],
      associationMember: json['association_member'],
      memberships: json['memberships'] ?? [],
      projects: json['projects'] ?? [],
      latestAssociationMembershipRequest:
          json['latest_association_membership_request'],
      membershipLifecycle: json['membership_lifecycle'] != null
          ? MembershipLifecycle.fromJson(json['membership_lifecycle'])
          : null,
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
      'person': person,
      'association_member': associationMember,
      'memberships': memberships,
      'projects': projects,
      'latest_association_membership_request':
          latestAssociationMembershipRequest,
      'membership_lifecycle': membershipLifecycle?.toJson(),
    };
  }
}

class ProfileCompletion {
  final bool complete;
  final List<String> missingFields;
  final List<String> missingFieldLabels;

  ProfileCompletion({
    required this.complete,
    required this.missingFields,
    required this.missingFieldLabels,
  });

  factory ProfileCompletion.fromJson(Map<String, dynamic> json) {
    return ProfileCompletion(
      complete: json['complete'] ?? false,
      missingFields: List<String>.from(json['missing_fields'] ?? []),
      missingFieldLabels: List<String>.from(json['missing_field_labels'] ?? []),
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
  final bool documentsComplete;

  BindingProfile({
    required super.complete,
    required super.missingFields,
    required super.missingFieldLabels,
    required this.documentsComplete,
  });

  factory BindingProfile.fromJson(Map<String, dynamic> json) {
    return BindingProfile(
      complete: json['complete'] ?? false,
      missingFields: List<String>.from(json['missing_fields'] ?? []),
      missingFieldLabels: List<String>.from(json['missing_field_labels'] ?? []),
      documentsComplete: json['documents_complete'] ?? false,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'complete': complete,
      'missing_fields': missingFields,
      'missing_field_labels': missingFieldLabels,
      'documents_complete': documentsComplete,
    };
  }
}

class MembershipLifecycle {
  final String stage;
  final String title;
  final String message;
  final String statusLabel;

  final bool canSubmitRequest;
  final bool canRequestProfileUpdate;
  final bool showSubmitButton;

  final dynamic adminNotes;
  final dynamic associationMember;
  final dynamic membership;

  MembershipLifecycle({
    required this.stage,
    required this.title,
    required this.message,
    required this.statusLabel,
    required this.canSubmitRequest,
    required this.canRequestProfileUpdate,
    required this.showSubmitButton,
    this.adminNotes,
    this.associationMember,
    this.membership,
  });

  factory MembershipLifecycle.fromJson(Map<String, dynamic> json) {
    return MembershipLifecycle(
      stage: json['stage'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      statusLabel: json['status_label'] ?? '',
      canSubmitRequest: json['can_submit_request'] ?? false,
      canRequestProfileUpdate: json['can_request_profile_update'] ?? false,
      showSubmitButton: json['show_submit_button'] ?? false,
      adminNotes: json['admin_notes'],
      associationMember: json['association_member'],
      membership: json['membership'],
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
      'association_member': associationMember,
      'membership': membership,
    };
  }
}