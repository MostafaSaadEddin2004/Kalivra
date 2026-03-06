/// GET /api/shop/v1/configurations – core store config.
class ConfigurationApiModel {
  const ConfigurationApiModel({
    this.channelCode,
    this.currencyCode,
    this.localeCode,
    this.storeName,
    this.logo,
    this.favicon,
    this.homePageContent,
    this.footerContent,
    this.slider,
    this.extra,
  });

  final String? channelCode;
  final String? currencyCode;
  final String? localeCode;
  final String? storeName;
  final String? logo;
  final String? favicon;
  final String? homePageContent;
  final String? footerContent;
  final List<Map<String, dynamic>>? slider;
  final Map<String, dynamic>? extra;

  factory ConfigurationApiModel.fromJson(Map<String, dynamic> json) {
    return ConfigurationApiModel(
      channelCode: json['channel_code'] as String?,
      currencyCode: json['currency_code'] as String?,
      localeCode: json['locale_code'] as String?,
      storeName: json['store_name'] as String?,
      logo: json['logo'] as String?,
      favicon: json['favicon'] as String?,
      homePageContent: json['home_page_content'] as String?,
      footerContent: json['footer_content'] as String?,
      slider: (json['slider'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      extra: json['extra'] as Map<String, dynamic>?,
    );
  }
}
