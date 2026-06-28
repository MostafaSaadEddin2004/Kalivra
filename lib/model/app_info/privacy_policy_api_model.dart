class PrivacyPolicyApiModel {
  const PrivacyPolicyApiModel({
    this.id,
    this.title,
    this.content,
    this.slug,
    this.extra = const {},
  });

  final int? id;
  final String? title;
  final String? content;
  final String? slug;
  final Map<String, dynamic> extra;

  factory PrivacyPolicyApiModel.fromJson(Map<String, dynamic> json) {
    return PrivacyPolicyApiModel(
      id: _intOrNull(json['id']),
      title: _stringOrNull(json['title'] ?? json['name']),
      content: _stringOrNull(
        json['content'] ??
            json['description'] ??
            json['body'] ??
            json['html'] ??
            json['html_content'] ??
            json['page_content'] ??
            json['value'],
      ),
      slug: _stringOrNull(json['slug'] ?? json['url_key']),
      extra: _withoutKeys(json, {
        'id',
        'title',
        'name',
        'content',
        'description',
        'body',
        'html',
        'html_content',
        'page_content',
        'value',
        'slug',
        'url_key',
      }),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'content': content,
    'slug': slug,
    ...extra,
  };
}

int? _intOrNull(dynamic value) {
  if (value is int) return value;
  if (value is String) return int.tryParse(value);
  return null;
}

String? _stringOrNull(dynamic value) => value?.toString();

Map<String, dynamic> _withoutKeys(Map<String, dynamic> json, Set<String> keys) {
  return Map<String, dynamic>.from(json)
    ..removeWhere((key, _) => keys.contains(key));
}
