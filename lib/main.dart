import 'package:flutter/material.dart';
import 'package:studycards/data/app_database.dart';
import 'package:studycards/pages/flashcards_home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:studycards/services/app_logger.dart';
import 'package:studycards/services/flashcard_repository.dart';
import 'package:studycards/services/flashcards_remote_service.dart';
import 'firebase_options.dart';

import 'dart:async';

Future<void> main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      AppLogger.info('Inicializando FlashcardSync RC');

      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      AppLogger.info('Firebase inicializado correctamente');

      final database = AppDatabase();
      final remoteService = FlashcardRemoteService();
      final repository = FlashcardRepository(
        localDb: database,
        remoteService: remoteService,
      );

      runApp(MyApp(repository: repository));
    },
    (error, stackTrace) {
      AppLogger.error(
        'Error global no controlado',
        error: error,
        stackTrace: stackTrace,
      );
    },
  );
}

class MyApp extends StatelessWidget {
  final FlashcardRepository repository;

  const MyApp({
    super.key,
    required this.repository,
  });

  @override
  Widget build(BuildContext context) {
    AppLogger.debug('Construyendo MyApp');

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FlashcardSync RC',
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      home: FlashcardsHomePage(repository: repository),
    );
  }
}
