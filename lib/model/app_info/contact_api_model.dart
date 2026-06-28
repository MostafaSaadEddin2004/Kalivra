class ContactApiModel {
  const ContactApiModel({
    this.phone,
    this.email,
    this.address,
    this.workingHours,
    this.whatsapp,
    this.facebook,
    this.instagram,
    this.mapUrl,
    this.socialLinks = const [],
    this.extra = const {},
  });

  final String? phone;
  final String? email;
  final String? address;
  final String? workingHours;
  final String? whatsapp;
  final String? facebook;
  final String? instagram;
  final String? mapUrl;
  final List<Map<String, dynamic>> socialLinks;
  final Map<String, dynamic> extra;

  factory ContactApiModel.fromJson(Map<String, dynamic> json) {
    return ContactApiModel(
      phone: _stringOrNull(json['phone'] ?? json['phone_number']),
      email: _stringOrNull(json['email'] ?? json['support_email']),
      address: _stringOrNull(json['address'] ?? json['location']),
      workingHours: _stringOrNull(
        json['working_hours'] ?? json['hours'] ?? json['opening_hours'],
      ),
      whatsapp: _stringOrNull(json['whatsapp'] ?? json['whatsapp_number']),
      facebook: _stringOrNull(json['facebook'] ?? json['facebook_url']),
      instagram: _stringOrNull(json['instagram'] ?? json['instagram_url']),
      mapUrl: _stringOrNull(json['map_url'] ?? json['google_map_url']),
      socialLinks: _mapList(json['social_links'] ?? json['socials']),
      extra: _withoutKeys(json, {
        'phone',
        'phone_number',
        'email',
        'support_email',
        'address',
        'location',
        'working_hours',
        'hours',
        'opening_hours',
        'whatsapp',
        'whatsapp_number',
        'facebook',
        'facebook_url',
        'instagram',
        'instagram_url',
        'map_url',
        'google_map_url',
        'social_links',
        'socials',
      }),
    );
  }

  Map<String, dynamic> toJson() => {
    'phone': phone,
    'email': email,
    'address': address,
    'working_hours': workingHours,
    'whatsapp': whatsapp,
    'facebook': facebook,
    'instagram': instagram,
    'map_url': mapUrl,
    'social_links': socialLinks,
    ...extra,
  };
}

String? _stringOrNull(dynamic value) => value?.toString();

List<Map<String, dynamic>> _mapList(dynamic value) {
  if (value is! List) return [];
  return value
      .whereType<Map>()
      .map((item) => Map<String, dynamic>.from(item))
      .toList();
}

Map<String, dynamic> _withoutKeys(Map<String, dynamic> json, Set<String> keys) {
  return Map<String, dynamic>.from(json)
    ..removeWhere((key, _) => keys.contains(key));
}
