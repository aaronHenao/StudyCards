import 'package:flutter/material.dart';
import 'package:studycards/model/flashcard.dart';

class FlashcardCard extends StatelessWidget {
  final Flashcard flashcard;
  final VoidCallback onTap;
  final bool isLearned;
  final bool isSyncing;

  const FlashcardCard({
    super.key,
    required this.flashcard,
    required this.onTap,
    required this.isLearned,
    this.isSyncing = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isLearned ? Colors.green.withValues(alpha: 0.1) : Colors.white,
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 16.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                flashcard.question,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
