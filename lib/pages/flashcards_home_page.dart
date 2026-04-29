import 'package:flutter/material.dart';
import 'package:studycards/model/flashcard.dart';
import 'package:studycards/services/flashcard_repository.dart';
import '../widgets/flashcard_tile.dart';
import '../widgets/flashcard_form_dialog.dart';
import 'flashcard_answer_page.dart';

class FlashcardsHomePage extends StatefulWidget {
  final FlashcardRepository repository;

  const FlashcardsHomePage({super.key, required this.repository});

  @override
  State<FlashcardsHomePage> createState() => _FlashcardsHomePageState();
}

class _FlashcardsHomePageState extends State<FlashcardsHomePage> {
  @override
  void initState() {
    super.initState();
    widget.repository.loadInitialData();
  }

  Future<void> _openCreateDialog() async {
    final result = await showDialog<FlashcardFormResult>(
      context: context,
      builder: (context) => const FlashcardFormDialog(),
    );

    if (result != null) {
      await widget.repository.addFlashcard(
        question: result.question,
        answer: result.answer,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Flashcards'),
        centerTitle: true,
      ),
      body: StreamBuilder<List<FlashcardModel>>(
        stream: widget.repository.watchFlashcards(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final cards = snapshot.data ?? [];

          if (cards.isEmpty) {
            return const Center(child: Text('No hay tarjetas. ¡Crea una!'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: cards.length,
            itemBuilder: (context, index) {
              final card = cards[index];
              return FlashcardTile(
                flashcard: card,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FlashcardAnswerPage(
                        flashcard: card,
                        repository: widget.repository,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openCreateDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
