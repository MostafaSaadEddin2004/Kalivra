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
    this.statusLabel = '',
    this.subtitle = '',
    this.subtitleTranslations = const {},
    this.imageUrl = '',
    this.images = const [],
    this.galleryImages = const [],
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
  final List<AssociationProjectStage> stages;
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
      images: _stringList(json['images']),
      galleryImages: _stringList(json['gallery_images']),
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
      stages: _listOf(json['stages'], AssociationProjectStage.fromJson),
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
    this.buildingNumber = '',
    this.name = '',
    this.description = '',
    this.physicalAddress = '',
    this.latitude,
    this.longitude,
    this.numberOfFloors,
    this.numberOfUnits,
    this.buildingPlanUrl = '',
    this.floorPlanImages = const [],
    this.galleryImages = const [],
    this.specifications = '',
    this.completionPercentage,
    this.totalUnits,
    this.availableUnits,
    this.allocatedUnits,
    this.deliveredUnits,
    this.stages = const [],
  });

  final int? id;
  final int? projectId;
  final String buildingNumber;
  final String name;
  final String description;
  final String physicalAddress;
  final num? latitude;
  final num? longitude;
  final int? numberOfFloors;
  final int? numberOfUnits;
  final String buildingPlanUrl;
  final List<String> floorPlanImages;
  final List<String> galleryImages;
  final String specifications;
  final num? completionPercentage;
  final int? totalUnits;
  final int? availableUnits;
  final int? allocatedUnits;
  final int? deliveredUnits;
  final List<AssociationProjectStage> stages;

  String get displayName => name.isNotEmpty ? name : buildingNumber;

  List<String> get allImages {
    return [
      buildingPlanUrl,
      ...floorPlanImages,
      ...galleryImages,
    ].where((item) => item.trim().isNotEmpty).toSet().toList();
  }

  factory AssociationBuilding.fromJson(Map<String, dynamic> json) {
    return AssociationBuilding(
      id: _intValue(json['id']),
      projectId: _intValue(json['project_id']),
      buildingNumber: _stringValue(json['building_number']),
      name: _stringValue(json['name']),
      description: _stringValue(json['description']),
      physicalAddress: _stringValue(json['physical_address']),
      latitude: _numValue(json['latitude']),
      longitude: _numValue(json['longitude']),
      numberOfFloors: _intValue(json['number_of_floors']),
      numberOfUnits: _intValue(json['number_of_units']),
      buildingPlanUrl: _stringValue(json['building_plan_url']),
      floorPlanImages: _stringList(json['floor_plan_images']),
      galleryImages: _stringList(json['gallery_images']),
      specifications: _stringValue(json['specifications']),
      completionPercentage: _numValue(json['completion_percentage']),
      totalUnits: _intValue(json['total_units']),
      availableUnits: _intValue(json['available_units']),
      allocatedUnits: _intValue(json['allocated_units']),
      deliveredUnits: _intValue(json['delivered_units']),
      stages: _listOf(json['stages'], AssociationProjectStage.fromJson),
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
      'specifications': specifications,
      'completion_percentage': completionPercentage,
      'total_units': totalUnits,
      'available_units': availableUnits,
      'allocated_units': allocatedUnits,
      'delivered_units': deliveredUnits,
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
      floorNumber: _intValue(json['floor_number']),
      orientation: _stringValue(json['orientation']),
      orientationLabel: _stringValue(json['orientation_label']),
      area: _numValue(json['area']),
      gardenTerraceArea: _numValue(json['garden_terrace_area']),
      price: _numValue(json['price']),
      specifications: _stringValue(json['specifications']),
      unitPlanUrl: _stringValue(json['unit_plan_url']),
      galleryImages: _stringList(json['gallery_images']),
      images: _stringList(json['images']),
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
      'gallery_images': galleryImages,
      'images': images,
      'status': status,
      'status_label': statusLabel,
      'building': building?.toJson(),
    };
  }
}

class AssociationProjectStage {
  const AssociationProjectStage({
    this.id,
    this.stageDefinitionId,
    this.stageName = '',
    this.startDate = '',
    this.endDate = '',
    this.completionPercentage,
    this.actualOrder,
    this.isActive = false,
    this.notes = '',
  });

  final int? id;
  final int? stageDefinitionId;
  final String stageName;
  final String startDate;
  final String endDate;
  final num? completionPercentage;
  final int? actualOrder;
  final bool isActive;
  final String notes;

  factory AssociationProjectStage.fromJson(Map<String, dynamic> json) {
    return AssociationProjectStage(
      id: _intValue(json['id']),
      stageDefinitionId: _intValue(json['stage_definition_id']),
      stageName: _stringValue(json['stage_name']),
      startDate: _stringValue(json['start_date']),
      endDate: _stringValue(json['end_date']),
      completionPercentage: _numValue(json['completion_percentage']),
      actualOrder: _intValue(json['actual_order']),
      isActive: _boolValue(json['is_active']),
      notes: _stringValue(json['notes']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'stage_definition_id': stageDefinitionId,
      'stage_name': stageName,
      'start_date': startDate,
      'end_date': endDate,
      'completion_percentage': completionPercentage,
      'actual_order': actualOrder,
      'is_active': isActive,
      'notes': notes,
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
