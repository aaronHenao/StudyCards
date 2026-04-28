import 'package:flutter/material.dart';
import 'package:studycards/model/flashcard.dart';

class FlashcardCard extends StatelessWidget {
  final FlashcardModel flashcard;
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
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      flashcard.question,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        decoration: isLearned 
                            ? TextDecoration.lineThrough 
                            : TextDecoration.none,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Icon(
                      isSyncing ? Icons.sync_problem : Icons.cloud_done,
                      size: 18,
                      color: isSyncing ? Colors.orange : Colors.blue,
                    ),
                  ),
                ],
              ),
              if (isSyncing)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Pendiente de sincronizar',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.orange.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}