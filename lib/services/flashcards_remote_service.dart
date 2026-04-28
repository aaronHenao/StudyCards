import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:studycards/model/flashcard.dart';
import 'app_logger.dart';

enum FlashcardRemoteFailure { none, permissionDenied, network, unexpected }

class FlashcardRemoteService {
  
  final CollectionReference<Map<String, dynamic>> _cardsRef =
      FirebaseFirestore.instance.collection('flashcards');

  FlashcardRemoteFailure _nextFailure = FlashcardRemoteFailure.none;

  void simulateNetworkErrorOnce() => _nextFailure = FlashcardRemoteFailure.network;

  void _throwFailureIfNeeded() {
    final failure = _nextFailure;
    _nextFailure = FlashcardRemoteFailure.none;
    if (failure == FlashcardRemoteFailure.network) {
      throw const SocketException('Simulación: Error de red');
    }
  }


  Future<void> upsertFlashcard(FlashcardModel card) async {
    if (card.id == null) {
      AppLogger.warning('No se puede sincronizar una tarjeta sin ID local');
      return;
    }

    _throwFailureIfNeeded();

    try {
     
      await _cardsRef.doc(card.id.toString()).set(card.toFirestore());
      AppLogger.info('Flashcard ${card.id} sincronizada en Firebase');
    } catch (e, stack) {
      AppLogger.error('Error al subir flashcard', error: e, stackTrace: stack);
      rethrow;
    }
  }

  Future<List<FlashcardModel>> fetchFlashcards() async {
    _throwFailureIfNeeded();

    try {
      final snapshot = await _cardsRef.get();
      return snapshot.docs.map((doc) {
        return FlashcardModel.fromFirestore(
          doc.data(),
          id: int.parse(doc.id),
        );
      }).toList();
    } catch (e, stack) {
      AppLogger.error('Error al descargar flashcards', error: e, stackTrace: stack);
      rethrow;
    }
  }
}