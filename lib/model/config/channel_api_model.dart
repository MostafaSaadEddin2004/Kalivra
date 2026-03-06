/// GET /api/shop/v1/channels – channel config (optional).
class ChannelApiModel {
  const ChannelApiModel({
    required this.id,
    this.code,
    this.name,
    this.description,
    this.theme,
    this.homePageContent,
    this.footerContent,
    this.logo,
    this.favicon,
  });

  final int id;
  final String? code;
  final String? name;
  final String? description;
  final String? theme;
  final String? homePageContent;
  final String? footerContent;
  final String? logo;
  final String? favicon;

  factory ChannelApiModel.fromJson(Map<String, dynamic> json) {
    return ChannelApiModel(
      id: json['id'] as int,
      code: json['code'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      theme: json['theme'] as String?,
      homePageContent: json['home_page_content'] as String?,
      footerContent: json['footer_content'] as String?,
      logo: json['logo'] as String?,
      favicon: json['favicon'] as String?,
    );
  }
}
