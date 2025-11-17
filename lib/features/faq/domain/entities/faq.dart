class FAQ {
  final int id;
  final String category;
  final String question;
  final String answer;

  FAQ({
    required this.id,
    required this.category,
    required this.question,
    required this.answer,
  });

  FAQ.fromJson(Map<String, dynamic> json)
    : id = json['id'] as int,
      category = json['category'] as String? ?? '',
      question = json['question'] as String? ?? '',
      answer = json['answer'] as String? ?? '';
}
