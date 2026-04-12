import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:studycards/data/flashcards_data.dart';
import 'package:studycards/model/flashcard.dart';

class FlashcardsService {
  final String baseUrl;
  final bool useFallbackLocal;

  const FlashcardsService({
    required this.baseUrl,
    this.useFallbackLocal = true,
  });

  Future<List<Flashcard>> getFlashcards() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/flashcards'))
          .timeout(const Duration(seconds: 3));

      if (response.statusCode != 200) {
        throw Exception("No se pudieron cargar las tarjetas");
      }

      final dynamic decoded = jsonDecode(response.body);

      if (decoded is! List) {
        throw Exception('La respuesta no tiene el formato esperado');
      }

      final result = decoded
          .map((item) => Flashcard.fromJson(item as Map<String, dynamic>))
          .toList();
      return result;
    } catch (e) {
      if (!useFallbackLocal) rethrow;

      await Future.delayed(const Duration(seconds: 1));

      // Crear una copia profunda para evitar modificar la lista original
      final copiedFlashcards = flashcards
          .map(
            (f) => Flashcard(
              id: f.id,
              question: f.question,
              answer: f.answer,
              isLearned: f.isLearned,
            ),
          )
          .toList();

      return copiedFlashcards;
    }
  }

  Future<void> flashcardLearned(int flashcardId, bool isLearned) async {
    try {
      final response = await http
          .put(
            Uri.parse('$baseUrl/flashcards/$flashcardId'),
            headers: <String, String>{'Content-Type': 'application/json'},
            body: jsonEncode({'isLearned': isLearned}),
          )
          .timeout(Duration(seconds: 3));

      if (response.statusCode != 200) {
        throw Exception('No se pudo marcar la tarjeta como aprendida');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Flashcard> createFlashcard(String question, String answer) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/flashcards'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'question': question,
              'answer': answer,
              'isLearned': false,
            }),
          )
          .timeout(const Duration(seconds: 5));
      if (response.statusCode != 201) {
        throw Exception('No se pudo crear la tarjeta en el servidor');
      }

      final dynamic decoded = jsonDecode(response.body);

      return Flashcard.fromJson(decoded as Map<String, dynamic>);
    } catch (e) {
      if (!useFallbackLocal) rethrow;

      await Future.delayed(const Duration(seconds: 1));

      return Flashcard(
        id: DateTime.now().millisecondsSinceEpoch,
        question: question,
        answer: answer,
        isLearned: false,
      );
    }
  }

  Future<void> deleteFlashcard(int flashcardId) async {
    try {
      final response = await http
          .delete(
            Uri.parse('$baseUrl/flashcards/$flashcardId'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 3));

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('No se pudo eliminar la tarjeta');
      }
    } catch (e) {
      rethrow;
    }
  }
}
