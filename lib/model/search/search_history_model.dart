class SearchHistoryModel {
  final int id;
  final String query;
  final DateTime? searchedAt;

  const SearchHistoryModel({
    required this.id,
    required this.query,
    this.searchedAt,
  });

  factory SearchHistoryModel.fromJson(Map<String, dynamic> json) {
    return SearchHistoryModel(
      id: json['id'] as int? ?? 0,
      query: json['query'] as String? ?? '',
      searchedAt: DateTime.tryParse(json['searched_at'] as String? ?? ''),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'query': query,
    'searched_at': searchedAt?.toIso8601String(),
  };
}
