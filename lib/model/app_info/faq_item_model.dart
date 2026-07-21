class FaqItemModel {
  final int id;
  final String category;
  final String question;
  final String answer;
  final int sortOrder;

  const FaqItemModel({
    required this.id,
    required this.category,
    required this.question,
    required this.answer,
    required this.sortOrder,
  });

  factory FaqItemModel.fromJson(Map<String, dynamic> json) {
    return FaqItemModel(
      id: json['id'] as int? ?? 0,
      category: json['category'] as String? ?? '',
      question: json['question'] as String? ?? '',
      answer: json['answer'] as String? ?? '',
      sortOrder: json['sort_order'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'category': category,
    'question': question,
    'answer': answer,
    'sort_order': sortOrder,
  };
}
