import 'package:flutter/material.dart';

import '../features/quiz/service.dart';
import '../features/quiz/widgets/quiz.dart';

class QuizPage extends StatelessWidget {
  const QuizPage({super.key});

  Future<void> _showQuizDialog(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => QuizWidget(
        quiz: QuizService.generateQuiz(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Опрос'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _showQuizDialog(context);
          },
          child: const Text('Пройти опрос'),
        ),
      ),
    );
  }
}
