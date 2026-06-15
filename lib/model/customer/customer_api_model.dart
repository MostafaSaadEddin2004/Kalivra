class CustomerApiModel {
  const CustomerApiModel({
    required this.id,
    this.firstName,
    this.lastName,
    this.name,
    this.email,
    this.phone,
    this.whatsappNumber,
    this.city,
    this.country,
    this.postalCode,
    this.gender,
    this.dateOfBirth,
    this.imageUrl,
    this.status,
    this.isVerified,
    this.subscribedToNewsLetter,
    this.referralCode,
    this.notes,
    this.createdAt,
    this.updatedAt,
    this.personalInformation,
    this.contactInformation,
    this.addressInformation,
  });

  final int id;
  final String? firstName;
  final String? lastName;
  final String? name;
  final String? email;
  final String? phone;
  final String? whatsappNumber;
  final String? city;
  final String? country;
  final String? postalCode;
  final String? gender;
  final String? dateOfBirth;
  final String? imageUrl;
  final int? status;
  final bool? isVerified;
  final bool? subscribedToNewsLetter;
  final String? referralCode;
  final String? notes;
  final String? createdAt;
  final String? updatedAt;
  final CustomerPersonalInformation? personalInformation;
  final CustomerContactInformation? contactInformation;
  final CustomerAddressInformation? addressInformation;

  String? get address =>
      addressInformation?.permanentAddress ??
      addressInformation?.formattedAddress;

  String? get avatar => imageUrl;

  String? get displayImageUrl => imageUrl ?? avatar;

  String? get fatherName => personalInformation?.fatherName;

  String? get motherName => personalInformation?.motherName;

  String? get nationalId => personalInformation?.nationalId;

  factory CustomerApiModel.fromJson(Map<String, dynamic> json) {
    final personal = _mapOrNull(
      json['personal_information'],
      CustomerPersonalInformation.fromJson,
    );
    final contact = _mapOrNull(
      json['contact_information'],
      CustomerContactInformation.fromJson,
    );
    final addressInfo = _mapOrNull(
      json['address_information'],
      CustomerAddressInformation.fromJson,
    );

    final imageUrl = _nullableString(json['image_url']) ?? personal?.imageUrl;

    return CustomerApiModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      firstName: _nullableString(json['first_name']) ?? personal?.firstName,
      lastName: _nullableString(json['last_name']) ?? personal?.lastName,
      name: _nullableString(json['name']) ?? personal?.name,
      email: _nullableString(json['email']) ?? contact?.email,
      phone: _nullableString(json['phone']) ?? contact?.phone,
      whatsappNumber:
          _nullableString(json['whatsapp_number']) ?? contact?.whatsappNumber,
      city: _nullableString(json['city']) ?? addressInfo?.officialCity,
      country: _nullableString(json['country']),
      postalCode: _nullableString(json['postal_code']),
      gender: _nullableString(json['gender']) ?? personal?.gender,
      dateOfBirth:
          _nullableString(json['date_of_birth']) ?? personal?.dateOfBirth,
      imageUrl: imageUrl,
      status: _parseStatus(json['status']),
      isVerified: json['is_verified'] as bool?,
      subscribedToNewsLetter: json['subscribed_to_news_letter'] as bool?,
      referralCode: _nullableString(json['referral_code']),
      notes: _nullableString(json['notes']),
      createdAt: _nullableString(json['created_at']),
      updatedAt: _nullableString(json['updated_at']),
      personalInformation: personal,
      contactInformation: contact,
      addressInformation: addressInfo,
    );
  }

  static String? _nullableString(dynamic value) {
    if (value == null) return null;
    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }

  static int? _nullableInt(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString().trim());
  }

  static int? _parseStatus(dynamic value) {
    if (value is bool) return value ? 1 : 0;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '');
  }

  static T? _mapOrNull<T>(
    dynamic raw,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (raw is Map<String, dynamic>) return fromJson(raw);
    if (raw is Map) return fromJson(Map<String, dynamic>.from(raw));
    return null;
  }
}

class CustomerPersonalInformation {
  const CustomerPersonalInformation({
    this.firstName,
    this.lastName,
    this.fatherName,
    this.motherName,
    this.gender,
    this.dateOfBirth,
    this.nationalId,
    this.name,
    this.imageUrl,
  });

  final String? firstName;
  final String? lastName;
  final String? fatherName;
  final String? motherName;
  final String? gender;
  final String? dateOfBirth;
  final String? nationalId;
  final String? name;
  final String? imageUrl;

  factory CustomerPersonalInformation.fromJson(Map<String, dynamic> json) {
    return CustomerPersonalInformation(
      firstName: CustomerApiModel._nullableString(json['first_name']),
      lastName: CustomerApiModel._nullableString(json['last_name']),
      fatherName: CustomerApiModel._nullableString(json['father_name']),
      motherName: CustomerApiModel._nullableString(json['mother_name']),
      gender: CustomerApiModel._nullableString(json['gender']),
      dateOfBirth: CustomerApiModel._nullableString(json['date_of_birth']),
      nationalId: CustomerApiModel._nullableString(json['national_id']),
      name: CustomerApiModel._nullableString(json['name']),
      imageUrl: CustomerApiModel._nullableString(json['image_url']),
    );
  }
}

class CustomerContactInformation {
  const CustomerContactInformation({
    this.email,
    this.phone,
    this.whatsappNumber,
  });

  final String? email;
  final String? phone;
  final String? whatsappNumber;

  factory CustomerContactInformation.fromJson(Map<String, dynamic> json) {
    return CustomerContactInformation(
      email: CustomerApiModel._nullableString(json['email']),
      phone: CustomerApiModel._nullableString(json['phone']),
      whatsappNumber: CustomerApiModel._nullableString(json['whatsapp_number']),
    );
  }
}

class CustomerAddressInformation {
  const CustomerAddressInformation({
    this.permanentCapitalId,
    this.permanentCityId,
    this.permanentTownId,
    this.permanentVillageId,
    this.officialGovernorate,
    this.officialCity,
    this.officialTown,
    this.officialMunicipalityVillage,
    this.officialStreet,
    this.officialBuilding,
    this.permanentAddress,
  });

  final int? permanentCapitalId;
  final int? permanentCityId;
  final int? permanentTownId;
  final int? permanentVillageId;
  final String? officialGovernorate;
  final String? officialCity;
  final String? officialTown;
  final String? officialMunicipalityVillage;
  final String? officialStreet;
  final String? officialBuilding;
  final String? permanentAddress;

  String get formattedAddress {
    final parts = [
      officialGovernorate,
      officialCity,
      officialTown,
      officialMunicipalityVillage,
      officialStreet,
      officialBuilding,
    ].whereType<String>().where((part) => part.trim().isNotEmpty).toList();
    return parts.join(' - ');
  }

  factory CustomerAddressInformation.fromJson(Map<String, dynamic> json) {
    return CustomerAddressInformation(
      permanentCapitalId: CustomerApiModel._nullableInt(
        json['permanent_capital_id'],
      ),
      permanentCityId: CustomerApiModel._nullableInt(json['permanent_city_id']),
      permanentTownId: CustomerApiModel._nullableInt(json['permanent_town_id']),
      permanentVillageId: CustomerApiModel._nullableInt(
        json['permanent_village_id'],
      ),
      officialGovernorate: CustomerApiModel._nullableString(
        json['official_governorate'],
      ),
      officialCity: CustomerApiModel._nullableString(json['official_city']),
      officialTown: CustomerApiModel._nullableString(json['official_town']),
      officialMunicipalityVillage: CustomerApiModel._nullableString(
        json['official_municipality_village'],
      ),
      officialStreet: CustomerApiModel._nullableString(json['official_street']),
      officialBuilding: CustomerApiModel._nullableString(
        json['official_building'],
      ),
      permanentAddress: CustomerApiModel._nullableString(
        json['permanent_address'],
      ),
    );
  }
}
