import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:studycards/model/flashcard.dart';
import 'package:studycards/services/flashcards_service.dart';

class FlashcardAnswerPage extends StatefulWidget {
  final Flashcard flashcard;
  final bool isLearnedInitial;
  final ValueChanged<bool> onLearnedChange;

  const FlashcardAnswerPage({
    super.key,
    required this.flashcard,
    required this.isLearnedInitial,
    required this.onLearnedChange,
  });

  @override
  State<FlashcardAnswerPage> createState() => _FlashcardAnswerPage();
}

class _FlashcardAnswerPage extends State<FlashcardAnswerPage> {
  late bool _isLearned;
  late final FlashcardsService _service;

  @override
  void initState() {
    super.initState();
    _isLearned = widget.isLearnedInitial;
    _service = const FlashcardsService(
      baseUrl: 'https://69d99d5726585bd92dd31e13.mockapi.io/api/v1',
      useFallbackLocal: true,
    );
  }

  void _toggleLearned() async {
    final newState = !_isLearned;

    setState(() {
      _isLearned = newState;
    });

    widget.onLearnedChange(_isLearned);

    try{
      await _service.flashcardLearned(widget.flashcard.id, newState);
    } catch(e){
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final flashcard = widget.flashcard;

    return Scaffold(
      appBar: AppBar(
        title: Text('Respuesta'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      flashcard.answer,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  IconButton(
                    onPressed: _toggleLearned,
                    icon: HugeIcon(
                      icon: _isLearned ? HugeIcons.strokeRoundedToggleOn : HugeIcons.strokeRoundedToggleOff,
                      color: _isLearned ? Colors.green : Colors.grey,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
