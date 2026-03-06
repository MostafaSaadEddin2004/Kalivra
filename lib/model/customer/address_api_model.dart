/// GET /api/shop/v1/customers/addresses – customer address.
class AddressApiModel {
  const AddressApiModel({
    required this.id,
    this.customerId,
    this.companyName,
    this.firstName,
    this.lastName,
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
      id: json['id'] as int,
      customerId: json['customer_id'] as int?,
      companyName: json['company_name'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      vatId: json['vat_id'] as String?,
      address1: (json['address1'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      address2: (json['address2'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      country: json['country'] as String?,
      countryName: json['country_name'] as String?,
      state: json['state'] as String?,
      city: json['city'] as String?,
      postcode: json['postcode'] as String?,
      phone: json['phone'] as String?,
      defaultAddress: json['default_address'] as bool?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }
}
