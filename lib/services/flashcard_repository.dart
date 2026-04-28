import 'package:studycards/model/flashcard.dart';
import 'package:studycards/services/flashcards_remote_service.dart';
import '../data/app_database.dart';
import 'app_logger.dart';

class FlashcardRepository {
  final AppDatabase localDb;
  final FlashcardRemoteService remoteService;

  FlashcardRepository({
    required this.localDb,
    required this.remoteService,
  });

  Stream<List<FlashcardModel>> watchFlashcards() {
    AppLogger.debug('Escuchando flashcards desde Drift');
    return localDb.watchFlashcards();
  }

  Future<void> loadInitialData() async {
    AppLogger.info('Cargando datos iniciales de flashcards');
    await refreshFromRemote();
    await syncPendingCards();
  }

  Future<void> addFlashcard({
    required String question,
    required String answer,
  }) async {
    AppLogger.info('Intentando crear flashcard local');

    final localCard = FlashcardModel(
      question: question,
      answer: answer,
      isLearned: false,
      pendSync: true,
    );

    final insertedCard = await localDb.insertFlashcard(localCard);
    AppLogger.info('Flashcard creada localmente con id: ${insertedCard.id}');

    try {

      await remoteService.upsertFlashcard(insertedCard);
      
      if (insertedCard.id != null) {
        await localDb.markAsSynced(insertedCard.id!);
        AppLogger.info('Flashcard sincronizada: ${insertedCard.id}');
      }
    } catch (error, stackTrace) {
      AppLogger.warning('Guardado localmente, pero pendiente de sincronización');
      AppLogger.error('Error sincronizando con Firebase', error: error, stackTrace: stackTrace);
    }
  }

  Future<void> toggleLearned(FlashcardModel card) async {
    if (card.id == null) return;

    final newStatus = !card.isLearned;
    AppLogger.info('Cambiando estado de flashcard ${card.id} a: $newStatus');

    await localDb.toggleLearnedStatus(
      id: card.id!,
      learned: newStatus,
    );

    try {
      final updatedCard = card.copyWith(
        isLearned: newStatus,
        pendSync: true,
      );
      await remoteService.upsertFlashcard(updatedCard);
      await localDb.markAsSynced(card.id!);
    } catch (error, stackTrace) {
      AppLogger.error('Error sincronizando cambio de estado', error: error, stackTrace: stackTrace);
    }
  }

  Future<void> refreshFromRemote() async {
    AppLogger.info('Refrescando flashcards desde Firebase');
    try {
      final remoteCards = await remoteService.fetchFlashcards();
      for (final card in remoteCards) {
        await localDb.upsertFromRemote(card);
      }
      AppLogger.info('Refresco finalizado. Cartas: ${remoteCards.length}');
    } catch (error, stackTrace) {
      AppLogger.error('Error obteniendo datos remotos', error: error, stackTrace: stackTrace);
    }
  }

  Future<void> syncPendingCards() async {
    final pending = await localDb.getPendingSync();
    if (pending.isEmpty) return;

    AppLogger.info('Sincronizando ${pending.length} cartas pendientes');
    for (final card in pending) {
      try {
        await remoteService.upsertFlashcard(card);
        await localDb.markAsSynced(card.id!);
      } catch (e) {
        AppLogger.error('Fallo re-sincronización de carta ${card.id}');
      }
    }
  }


  Future<void> qaCreateWithNetworkError(String q, String a) async {
    remoteService.simulateNetworkErrorOnce();
    await addFlashcard(question: q, answer: a);
  }
}