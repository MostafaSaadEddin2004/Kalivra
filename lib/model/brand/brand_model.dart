class BrandModel {
  final int id;
  final String name;
  final String? description;
  final String? logo;
  final String? banner;
  final List<String> gallery;
  final String? website;
  final List<String> phoneNumbers;
  final String? email;
  final String? country;
  final String? city;
  final String? address;
  final String? workingHours;
  final List<BrandSocialLink> socialLinks;
  final bool? isActive;
  final int? sortOrder;

  BrandModel({
    required this.id,
    required this.name,
    this.description,
    this.logo,
    this.banner,
    this.gallery = const [],
    this.website,
    this.phoneNumbers = const [],
    this.email,
    this.country,
    this.city,
    this.address,
    this.workingHours,
    this.socialLinks = const [],
    this.isActive,
    this.sortOrder,
  });

  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      logo: json['logo'] as String?,
      banner: json['banner'] as String?,
      gallery: _stringList(json['gallery']),
      website: json['website'] as String?,
      phoneNumbers: _stringList(json['phone_numbers']),
      email: json['email'] as String?,
      country: json['country'] as String?,
      city: json['city'] as String?,
      address: json['address'] as String?,
      workingHours: json['working_hours'] as String?,
      socialLinks: _socialLinks(json['social_links']),
      isActive: json['is_active'] as bool?,
      sortOrder: json['sort_order'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'logo': logo,
    'banner': banner,
    'gallery': gallery,
    'website': website,
    'phone_numbers': phoneNumbers,
    'email': email,
    'country': country,
    'city': city,
    'address': address,
    'working_hours': workingHours,
    'social_links': socialLinks.map((e) => e.toJson()).toList(),
    'is_active': isActive,
    'sort_order': sortOrder,
  };

  static List<String> _stringList(dynamic value) {
    if (value is! List) return const [];
    return value
        .whereType<String>()
        .where((item) => item.trim().isNotEmpty)
        .toList();
  }

  static List<BrandSocialLink> _socialLinks(dynamic value) {
    if (value is! List) return const [];
    return value
        .map(BrandSocialLink.fromDynamic)
        .where((link) => link != null)
        .cast<BrandSocialLink>()
        .toList();
  }
}

class BrandSocialLink {
  final String? platform;
  final String url;

  const BrandSocialLink({this.platform, required this.url});

  factory BrandSocialLink.fromJson(Map<String, dynamic> json) {
    return BrandSocialLink(
      platform:
          json['platform'] as String? ??
          json['name'] as String? ??
          json['type'] as String?,
      url:
          json['url'] as String? ??
          json['link'] as String? ??
          json['value'] as String? ??
          '',
    );
  }

  static BrandSocialLink? fromDynamic(dynamic value) {
    if (value is String && value.trim().isNotEmpty) {
      return BrandSocialLink(url: value.trim());
    }
    if (value is Map<String, dynamic>) {
      final link = BrandSocialLink.fromJson(value);
      return link.url.trim().isEmpty ? null : link;
    }
    return null;
  }

  Map<String, dynamic> toJson() => {'platform': platform, 'url': url};
}
