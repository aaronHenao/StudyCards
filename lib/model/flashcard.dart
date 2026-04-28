class FlashcardModel {
  final int? id;
  final String question;
  final String answer;
  final bool isLearned;
  final bool pendSync;

  FlashcardModel({
    this.id,
    required this.question,
    required this.answer,
    this.isLearned = false,
    this.pendSync = true,
  });

  FlashcardModel copyWith({
    int? id,
    String? question,
    String? answer,
    bool? isLearned,
    bool? pendSync
  }) {
    return FlashcardModel(
      id: id ?? this.id,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      isLearned: isLearned ?? this.isLearned,
      pendSync: pendSync ?? this.pendSync
    );
  }

  Map<String, dynamic> toFirestore(){
    return {
      'question': question,
      'answer': answer,
      'isLearned': isLearned
    };
  }

  factory FlashcardModel.fromFirestore(Map<String, dynamic> map, {required int id}) {

    return FlashcardModel(
      id: id,
      question: map['question'] as String ?? '',
      answer: map['answer'] as String ?? '',
      isLearned: map['isLearned'] as bool ?? false,
      pendSync: false,
    );
  }
}
