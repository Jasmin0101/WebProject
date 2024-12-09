import 'package:flutter/material.dart';
import '../service.dart';

class QuestionWidget extends StatelessWidget {
  final Question question;
  final Function(List<AnswerType>) onAnswer;

  const QuestionWidget({
    super.key,
    required this.question,
    required this.onAnswer,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            question.title,
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ...List.generate(
            question.answers.length,
            (index) => Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    onAnswer(question.answers[index].types);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      question.answers[index].text,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ),
                const SizedBox(height: 10), // Отступ между кнопками
              ],
            ),
          ),
        ],
      ),
    );
  }
}
