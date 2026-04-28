import 'package:flutter/material.dart';
import 'package:studycards/model/flashcard.dart';

class FlashcardTile extends StatelessWidget {
  final FlashcardModel flashcard;
  final VoidCallback onTap;

  const FlashcardTile({
    super.key,
    required this.flashcard,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: flashcard.isLearned 
          ? Colors.green.withValues(alpha: 0.1) 
          : Colors.white,
      margin: const EdgeInsets.only(bottom: 12.0),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  flashcard.question,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    decoration: flashcard.isLearned 
                        ? TextDecoration.lineThrough 
                        : TextDecoration.none,
                  ),
                ),
              ),
              Icon(
                flashcard.pendSync ? Icons.sync_problem : Icons.cloud_done,
                size: 18,
                color: flashcard.pendSync ? Colors.orange : Colors.blue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}