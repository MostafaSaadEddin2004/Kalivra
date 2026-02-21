/// Model for language option (e.g. Arabic, English).
class LanguageModel {
  const LanguageModel({
    required this.title,
    required this.subtitle,
    required this.languageCode,
    required this.index,
  });

  final String title;
  final String subtitle;
  final String languageCode;
  final int index;
}
