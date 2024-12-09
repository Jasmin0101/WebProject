import 'dart:math';

import 'package:flutter/material.dart';

import '../service.dart';
import 'question.dart';
import 'result.dart';

class QuizWidget extends StatefulWidget {
  final List<Question> quiz;
  const QuizWidget({super.key, required this.quiz});

  @override
  State<QuizWidget> createState() => _QuizWidgetState();
}

class _QuizWidgetState extends State<QuizWidget> {
  int _autumnCounter = 0;
  int _winterCounter = 0;
  int _springCounter = 0;
  int _summerCounter = 0;

  int _currentQuestion = 0;

  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Опрос'),
      content: SizedBox(
        height: 600,
        width: max(300, MediaQuery.sizeOf(context).width / 2),
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: List<Widget>.generate(
                widget.quiz.length,
                (index) => QuestionWidget(
                  question: widget.quiz[index],
                  onAnswer: (types) {
                    for (int i = 0; i < types.length; i++) {
                      if (types[i] == AnswerType.winter) {
                        _winterCounter++;
                      }
                      if (types[i] == AnswerType.autumn) {
                        _autumnCounter++;
                      }
                      if (types[i] == AnswerType.spring) {
                        _springCounter++;
                      }
                      if (types[i] == AnswerType.summer) {
                        _summerCounter++;
                      }
                    }
                    _currentQuestion++;
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.linear,
                    );
                    setState(() {});
                  },
                ),
              ) +
              [
                ResultWidget(
                  summerCount: _summerCounter,
                  autumnCount: _autumnCounter,
                  winterCount: _winterCounter,
                  springCount: _springCounter,
                ),
              ],
        ),
      ),
      actions: [
        if (_currentQuestion == widget.quiz.length)
          TextButton(
            onPressed: () {
              _autumnCounter = 0;
              _springCounter = 0;
              _summerCounter = 0;
              _winterCounter = 0;
              _currentQuestion = 0;
              _pageController.animateToPage(
                0,
                duration: const Duration(milliseconds: 900),
                curve: Curves.easeInOut,
              );
              setState(() {});
            },
            child: const Text("Пройти заново"),
          ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Закрыть"),
        ),
      ],
    );
  }
}
