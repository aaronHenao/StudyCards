class Flashcard {
  final int id;
  final String question;
  final String answer;
  bool isLearned;

  Flashcard({
    required this.id,
    required this.question,
    required this.answer,
    this.isLearned = false,
  });

  factory Flashcard.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    
    //manejamos tanto strings como ints para el id
    int parsedId;
    if (id is int) {
      parsedId = id;
    } else if (id is String) {
      parsedId = int.tryParse(id) ?? 0;
    } else {
      parsedId = 0;
    }

    return Flashcard(
      id: parsedId,
      question: json['question'] is String ? json['question'] as String : 'Pregunta no disponible',
      answer: json['answer'] is String ? json['answer'] as String : 'Respuesta no disponible',
      isLearned: json['isLearned'] is bool ? json['isLearned'] as bool : false,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'question': question, 'answer': answer, 'isLearned': isLearned};
  }
  
}
