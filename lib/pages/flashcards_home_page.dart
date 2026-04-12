import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:studycards/model/flashcard.dart';
import 'package:studycards/pages/flashcard_answer_page.dart';
import 'package:studycards/services/flashcards_service.dart';
import 'package:studycards/widgets/flashcard_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FlashcardsHomePage extends StatefulWidget {
  const FlashcardsHomePage({super.key});

  @override
  State<FlashcardsHomePage> createState() => _FlashcardsHomePageState();
}

class _FlashcardsHomePageState extends State<FlashcardsHomePage> {
  final Set<int> _learned = {};

  late final FlashcardsService _service;
  late Future<List<Flashcard>> _futureFlashcards;

  @override
  void initState() {
    super.initState();

    _service = const FlashcardsService(
      baseUrl: 'https://69d99d5726585bd92dd31e13.mockapi.io/api/v1',
      useFallbackLocal: true,
    );

    _futureFlashcards = _service.getFlashcards();
    loadLearned();
  }

  Future<void> loadLearned() async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList('learned') ?? [];

    setState(() {
      _learned
        ..clear()
        ..addAll(ids.map(int.parse));
    });
  }

  Future<void> _saveLearned() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'learned',
      _learned.map((id) => id.toString()).toList(),
    );
  }

  void _updateLearned(int flashcardId, bool isLearned) {
    setState(() {
      if (isLearned) {
        _learned.add(flashcardId);
      } else {
        _learned.remove(flashcardId);
      }
    });

    _saveLearned();
    _service
        .flashcardLearned(flashcardId, isLearned)
        .catchError((e) => {print("Error al actualizar en la nube")});
  }

  Future<void> _reloadFlashcards() async {
    setState(() {
      _futureFlashcards = _service.getFlashcards();
    });

    await _futureFlashcards;
  }

  void _showCreateNewFlashCardForm(BuildContext context) {
    final questionController = TextEditingController();
    final answerController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nueva Tarjeta'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: questionController,
                decoration: const InputDecoration(labelText: 'Pregunta'),
              ),
              TextField(
                controller: answerController,
                decoration: const InputDecoration(labelText: 'Respuesta'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () async {
                if (questionController.text.isNotEmpty &&
                    answerController.text.isNotEmpty) {
                  await _service.createFlashcard(
                    questionController.text,
                    answerController.text,
                  );

                  if (mounted) {
                    Navigator.pop(context);
                    _reloadFlashcards();
                  }
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tarjetas de estudio')),
      body: FutureBuilder(
        future: _futureFlashcards,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  Text('Cargando tarjetas', textAlign: TextAlign.center),
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 48),
                    const SizedBox(height: 12),
                    const Text(
                      'Ocurrió un error al cargar las tarjetas',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: () {
                        setState(() {
                          _futureFlashcards = _service.getFlashcards();
                        });
                      },
                      child: const Text('reintentar'),
                    ),
                  ],
                ),
              ),
            );
          }

          final flashcards = snapshot.data ?? [];

          if (flashcards.isEmpty) {
            return const Center(child: Text('No hay tarjetas disponibles'));
          }

          return RefreshIndicator(
            onRefresh: _reloadFlashcards,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: flashcards.length,
              itemBuilder: (context, index) {
                final flashcard = flashcards[index];
                final isLearned = _learned.contains(flashcard.id);

                return Dismissible(
                  key: ValueKey(flashcard.id),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (direction) async {
                    return await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('¿Eliminar tarjeta?'),
                          content: Text(
                            'Esta acción eliminará la tarjeta: "${flashcard.question}"',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('Cancelar'),
                            ),
                            FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text('Eliminar'),
                            ),
                          ],
                        );
                      },
                    );
                  },

                  onDismissed: (direction) async {
                    final idToDelete = flashcard.id;
                    setState(() {
                      flashcards.removeAt(index);
                    });

                    try {
                      await _service.deleteFlashcard(idToDelete);

                      if (_learned.contains(idToDelete)) {
                        setState(() {
                          _learned.remove(idToDelete);
                        });
                        _saveLearned();
                      }
                    } catch (e) {
                      _reloadFlashcards();
                      debugPrint("Error al borrar: $e");
                    }
                  },

                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    color: Colors.red,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),

                  child: FlashcardCard(
                    key: ValueKey(flashcard.id),
                    flashcard: flashcard,
                    isLearned: isLearned,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FlashcardAnswerPage(
                            flashcard: flashcard,
                            isLearnedInitial: isLearned,
                            onLearnedChange: (newValue) {
                              _updateLearned(flashcard.id, newValue);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateNewFlashCardForm(context),
        child: const HugeIcon(icon: HugeIcons.strokeRoundedAdd01),
      ),
    );
  }
}
