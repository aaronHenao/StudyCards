import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:studycards/model/flashcard.dart';

part 'app_database.g.dart';

class Flashcards extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get question => text()();
  TextColumn get answer => text()();
  BoolColumn get isLearned => boolean().withDefault(const Constant(false))();
  BoolColumn get pendSync => boolean().withDefault(const Constant(true))();
}

@DriftDatabase(tables: [Flashcards])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'studycards_app_db',
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
      ),
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.dart.js'),
      ),
    );
  }

  FlashcardModel _mapFlashcardToModel(Flashcard row) {
    return FlashcardModel(
      id: row.id,
      question: row.question,
      answer: row.answer,
      isLearned: row.isLearned,
      pendSync: row.pendSync,
    );
  }

  Stream<List<FlashcardModel>> watchFlashcards() {
  return (select(flashcards)
        ..orderBy([
          (f) => OrderingTerm.asc(f.isLearned),
          (f) => OrderingTerm.desc(f.id),
        ])) 
      .watch()
      .map((rows) => rows.map(_mapFlashcardToModel).toList());
}

  Future<FlashcardModel> insertFlashcard(FlashcardModel card) async {
    final insertedId = await into(flashcards).insert(
      FlashcardsCompanion.insert(
        question: card.question,
        answer: card.answer,
        isLearned: Value(card.isLearned),
        pendSync: const Value(true),
      ),
    );
    return card.copyWith(id: insertedId);
  }


  Future<void> toggleLearnedStatus({
    required int id,
    required bool learned,
  }) async {
    await (update(flashcards)..where((t) => t.id.equals(id))).write(
      FlashcardsCompanion(
        isLearned: Value(learned),
        pendSync: const Value(true),
      ),
    );
  }

  Future<List<FlashcardModel>> getPendingSync() async {
    final rows = await (select(flashcards)..where((t) => t.pendSync.equals(true))).get();
    return rows.map(_mapFlashcardToModel).toList();
  }

  Future<void> markAsSynced(int id) async {
    await (update(flashcards)..where((t) => t.id.equals(id))).write(
      const FlashcardsCompanion(
        pendSync: Value(false),
      ),
    );
  }

  Future<void> upsertFromRemote(FlashcardModel card) async {
    if (card.id == null) return;

    await into(flashcards).insertOnConflictUpdate(
      FlashcardsCompanion(
        id: Value(card.id!),
        question: Value(card.question),
        answer: Value(card.answer),
        isLearned: Value(card.isLearned),
        pendSync: const Value(false),
      ),
    );
  }
}
