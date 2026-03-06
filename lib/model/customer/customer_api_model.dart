/// GET /api/shop/v1/customers/profile – customer profile.
class CustomerApiModel {
  const CustomerApiModel({
    required this.id,
    this.firstName,
    this.lastName,
    this.name,
    this.email,
    this.phone,
    this.gender,
    this.dateOfBirth,
    this.avatar,
    this.status,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final String? firstName;
  final String? lastName;
  final String? name;
  final String? email;
  final String? phone;
  final String? gender;
  final String? dateOfBirth;
  final String? avatar;
  final int? status;
  final String? notes;
  final String? createdAt;
  final String? updatedAt;

  factory CustomerApiModel.fromJson(Map<String, dynamic> json) {
    return CustomerApiModel(
      id: json['id'] as int,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      gender: json['gender'] as String?,
      dateOfBirth: json['date_of_birth'] as String?,
      avatar: json['avatar'] as String?,
      status: json['status'] as int?,
      notes: json['notes'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }
}
