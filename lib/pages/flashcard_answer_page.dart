import 'package:flutter/material.dart';
import 'package:studycards/model/flashcard.dart';
import 'package:studycards/services/flashcard_repository.dart';


class FlashcardAnswerPage extends StatelessWidget {
  final FlashcardModel flashcard;
  final FlashcardRepository repository;

  const FlashcardAnswerPage({
    super.key,
    required this.flashcard,
    required this.repository,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Estudiando')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('PREGUNTA:', style: TextStyle(color: Colors.grey, letterSpacing: 1.2)),
            const SizedBox(height: 8),
            Text(
              flashcard.question,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 60),
            const Text('RESPUESTA:', style: TextStyle(color: Colors.grey, letterSpacing: 1.2)),
            const SizedBox(height: 8),
            Text(
              flashcard.answer,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: flashcard.isLearned ? Colors.orange : Colors.green,
                ),
                onPressed: () async {
                  await repository.toggleLearned(flashcard);
                  if (context.mounted) Navigator.pop(context);
                },
                icon: Icon(flashcard.isLearned ? Icons.undo : Icons.check),
                label: Text(
                  flashcard.isLearned ? 'Marcar como pendiente' : '¡La aprendí!',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}