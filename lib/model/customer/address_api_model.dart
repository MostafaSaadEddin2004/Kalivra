class AddressApiModel {
  const AddressApiModel({
    required this.id,
    this.customerId,
    this.companyName,
    this.firstName,
    this.lastName,
    this.email,
    this.vatId,
    this.address1,
    this.address2,
    this.country,
    this.countryName,
    this.state,
    this.city,
    this.postcode,
    this.phone,
    this.defaultAddress,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final int? customerId;
  final String? companyName;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? vatId;
  final List<String>? address1;
  final List<String>? address2;
  final String? country;
  final String? countryName;
  final String? state;
  final String? city;
  final String? postcode;
  final String? phone;
  final bool? defaultAddress;
  final String? createdAt;
  final String? updatedAt;

  factory AddressApiModel.fromJson(Map<String, dynamic> json) {
    return AddressApiModel(
      id: _asInt(json['id']) ?? 0,
      customerId: _asInt(json['customer_id']),
      companyName: json['company_name'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      email: json['email'] as String?,
      vatId: json['vat_id'] as String?,
      address1: _asStringList(json['address'] ?? json['address1']),
      address2: (json['address2'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      country: json['country'] as String?,
      countryName: json['country_name'] as String?,
      state: json['state'] as String?,
      city: json['city'] as String?,
      postcode: json['postcode'] as String?,
      phone: json['phone'] as String?,
      defaultAddress: _asBool(json['default_address']),
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }
}

int? _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

bool? _asBool(dynamic value) {
  if (value is bool) return value;
  if (value is num) return value != 0;
  if (value is String) {
    final normalized = value.toLowerCase().trim();
    if (normalized == 'true' || normalized == '1') return true;
    if (normalized == 'false' || normalized == '0') return false;
  }
  return null;
}

List<String>? _asStringList(dynamic value) {
  if (value is List) return value.map((e) => e.toString()).toList();
  if (value is String && value.trim().isNotEmpty) return [value.trim()];
  return null;
}
