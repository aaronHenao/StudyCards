import 'package:flutter/material.dart';
import '../services/app_logger.dart';

class FlashcardFormResult {
  final String answer;
  final String question;

  const FlashcardFormResult({
    required this.answer,
    required this.question,
  });
}

class FlashcardFormDialog extends StatefulWidget {
  const FlashcardFormDialog({super.key});

  @override
  State<FlashcardFormDialog> createState() => _TaskFormDialogState();
}

class _TaskFormDialogState extends State<FlashcardFormDialog> {
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();

  String? _questionError;
  String? _answerError;

  @override
  void dispose() {
    _questionController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  void _save() {
    final question = _questionController.text.trim();
    final answer = _answerController.text.trim();

    AppLogger.debug('Intentando guardar flashcard desde FlashcardFormDialog');

    if (question.isEmpty) {
      AppLogger.warning('Validación fallida: pregunta vacía');

      setState(() {
        _questionError = 'La pregunta no puede estar vacía.';
      });

      return;
    }

    if(answer.isEmpty) {
      AppLogger.warning('Validación fallida: respuesta vacía');

      setState(() {
        _answerError = 'La respuesta no puede estar vacía.';
      });

      return;
    }

    Navigator.of(context).pop(
      FlashcardFormResult(
        question: question,
        answer: answer,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nueva Flashcard'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _questionController,
            autofocus: true,
            decoration: InputDecoration(
              labelText: 'Pregunta',
              errorText: _questionError,
            ),
            onChanged: (_) {
              if (_questionError != null) {
                setState(() {
                  _questionError = null;
                });
              }
            },
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _answerController,
            decoration: InputDecoration(
              labelText: 'Respuesta',
              errorText: _answerError,
            ),
            onChanged: (_) {
              if(_answerError != null) {
                setState(() {
                  _answerError = null;
                });
              }
            },
            onSubmitted: (_) => _save(),
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            AppLogger.debug('Creación de flashcard cancelada desde dialog');
            Navigator.of(context).pop();
          },
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: _save,
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}