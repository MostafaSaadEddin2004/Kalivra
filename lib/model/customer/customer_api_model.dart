class CustomerApiModel {
  const CustomerApiModel({
    required this.id,
    this.firstName,
    this.middleName,
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
    this.userBalance,
    this.notes,
    this.createdAt,
    this.updatedAt,
    this.personalInformation,
    this.contactInformation,
    this.addressInformation,
  });

  final int id;
  final String? firstName;
  final String? middleName;
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
  final num? userBalance;
  final String? notes;
  final String? createdAt;
  final String? updatedAt;
  final CustomerPersonalInformation? personalInformation;
  final CustomerContactInformation? contactInformation;
  final CustomerAddressInformation? addressInformation;

  String? get address =>
      addressInformation?.permanent?.formatted ??
      addressInformation?.formattedAddress;

  String? get avatar => imageUrl;

  String? get displayImageUrl => imageUrl ?? avatar;

  String? get fatherName => personalInformation?.fatherName;

  String? get displayMiddleName =>
      middleName ?? personalInformation?.middleName;

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
      middleName: _nullableString(json['middle_name']) ?? personal?.middleName,
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
      userBalance: _nullableNum(json['user_balance'] ?? json['User Balance']),
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

  static num? _nullableNum(dynamic value) {
    if (value == null) return null;
    if (value is num) return value;
    return num.tryParse(value.toString().trim());
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
    this.middleName,
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
  final String? middleName;
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
      middleName: CustomerApiModel._nullableString(json['middle_name']),
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
    this.permanent,
    this.current,
    this.additional = const [],
  });

  final CustomerAddressEntry? permanent;
  final CustomerAddressEntry? current;
  final List<CustomerAddressEntry> additional;

  int? get permanentCapitalId => permanent?.capitalId;

  int? get permanentCityId => permanent?.cityId;

  int? get permanentTownId => permanent?.townId;

  int? get permanentVillageId => null;

  String? get officialGovernorate => permanent?.capital;

  String? get officialCity => permanent?.city;

  String? get officialTown => permanent?.town;

  String? get officialMunicipalityVillage => permanent?.village;

  String? get officialStreet => permanent?.streetName;

  String? get officialBuilding => permanent?.building;

  String? get permanentAddress => permanent?.formatted;

  String get formattedAddress {
    return permanent?.formatted ?? '';
  }

  factory CustomerAddressInformation.fromJson(Map<String, dynamic> json) {
    final permanent = CustomerAddressEntry.fromDynamic(json['permanent']);
    final current = CustomerAddressEntry.fromDynamic(json['current']);
    final additional = CustomerAddressEntry.listFromDynamic(json['additional']);

    if (permanent != null || current != null || additional.isNotEmpty) {
      return CustomerAddressInformation(
        permanent: permanent,
        current: current,
        additional: additional,
      );
    }

    return CustomerAddressInformation(
      permanent: CustomerAddressEntry(
        capitalId: CustomerApiModel._nullableInt(json['permanent_capital_id']),
        cityId: CustomerApiModel._nullableInt(json['permanent_city_id']),
        townId: CustomerApiModel._nullableInt(json['permanent_town_id']),
        capital: CustomerApiModel._nullableString(json['official_governorate']),
        city: CustomerApiModel._nullableString(json['official_city']),
        town: CustomerApiModel._nullableString(json['official_town']),
        village: CustomerApiModel._nullableString(
          json['official_municipality_village'],
        ),
        streetName: CustomerApiModel._nullableString(json['official_street']),
        building: CustomerApiModel._nullableString(json['official_building']),
        formatted: CustomerApiModel._nullableString(json['permanent_address']),
      ),
    );
  }
}

class CustomerAddressEntry {
  const CustomerAddressEntry({
    this.id,
    this.type,
    this.label,
    this.capitalId,
    this.cityId,
    this.townId,
    this.village,
    this.streetName,
    this.streetNumber,
    this.building,
    this.notes,
    this.capital,
    this.city,
    this.town,
    this.formatted,
  });

  final int? id;
  final String? type;
  final String? label;
  final int? capitalId;
  final int? cityId;
  final int? townId;
  final String? village;
  final String? streetName;
  final String? streetNumber;
  final String? building;
  final String? notes;
  final String? capital;
  final String? city;
  final String? town;
  final String? formatted;

  List<String> get addressParts {
    return [
      capital,
      city,
      town,
      village,
      streetName,
      streetNumber,
      building,
    ].whereType<String>().where((part) => part.trim().isNotEmpty).toList();
  }

  String get displayAddress {
    final address = formatted?.trim();
    if (address != null && address.isNotEmpty) return address;
    return addressParts.join(', ');
  }

  bool get hasContent {
    return [
      label,
      type,
      displayAddress,
      notes,
    ].any((value) => value != null && value.trim().isNotEmpty);
  }

  static CustomerAddressEntry? fromDynamic(dynamic raw) {
    if (raw is Map<String, dynamic>) return CustomerAddressEntry.fromJson(raw);
    if (raw is Map) {
      return CustomerAddressEntry.fromJson(Map<String, dynamic>.from(raw));
    }
    return null;
  }

  static List<CustomerAddressEntry> listFromDynamic(dynamic raw) {
    if (raw is List) {
      return raw
          .map(CustomerAddressEntry.fromDynamic)
          .whereType<CustomerAddressEntry>()
          .toList();
    }

    final single = fromDynamic(raw);
    return single == null ? const [] : [single];
  }

  factory CustomerAddressEntry.fromJson(Map<String, dynamic> json) {
    return CustomerAddressEntry(
      id: CustomerApiModel._nullableInt(json['id']),
      type: CustomerApiModel._nullableString(json['type']),
      label: CustomerApiModel._nullableString(json['label']),
      capitalId: CustomerApiModel._nullableInt(json['capital_id']),
      cityId: CustomerApiModel._nullableInt(json['city_id']),
      townId: CustomerApiModel._nullableInt(json['town_id']),
      village: CustomerApiModel._nullableString(json['village']),
      streetName: CustomerApiModel._nullableString(json['street_name']),
      streetNumber: CustomerApiModel._nullableString(json['street_number']),
      building: CustomerApiModel._nullableString(json['building']),
      notes: CustomerApiModel._nullableString(json['notes']),
      capital: CustomerApiModel._nullableString(json['capital']),
      city: CustomerApiModel._nullableString(json['city']),
      town: CustomerApiModel._nullableString(json['town']),
      formatted: CustomerApiModel._nullableString(json['formatted']),
    );
  }
}
