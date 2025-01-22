import 'package:flutter/material.dart';


class QuestionnairePage extends StatefulWidget {
  const QuestionnairePage({super.key});

  @override
  State<QuestionnairePage> createState() => _QuestionnairePageState();
}

class _QuestionnairePageState extends State<QuestionnairePage> {
  int winter = 0;
  int autumn = 0;
  int spring = 0;
  int summer = 0;

  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _reset() {
    winter = 0;
    autumn = 0;
    spring = 0;
    summer = 0;
    _currentPage = 0;

    setState(() {});
  }

  void _nextPage() {
    // функция отвечающая за переключения между страницами пользователя
    if (_currentPage < 6) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
      return;
    }
    _showSummary();
  }

  void _selectSeason(int value, String season) {
    setState(() {
      switch (season) {
        case 'winter':
          winter = value;
          break;
        case 'autumn':
          autumn = value;
          break;
        case 'spring':
          spring = value;
          break;
        case 'summer':
          summer = value;
          break;
      }
    });
    _nextPage();
  }

  void _showQuestionnaireDialog(BuildContext context) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Опрос"),
          content: SizedBox(
            height: 200, // высота окна диалога
            width: 300, // ширина окна диалога
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                _currentPage = index;
                setState(() {});
              },
              children: [
                _buildQuestionPage(
                  "Что бы вы предпочли ?",
                  "winter",
                ),
                _buildQuestionPage(
                  "Какое время препровождение вам больше по душе?",
                  "winter",
                ),
                _buildQuestionPage(
                  "Вы больше?",
                  "winter",
                ),
                _buildQuestionPage(
                  "Ваш любимый праздник?",
                  "winter",
                ),
                _buildQuestionPage(
                  "Выберете цвет",
                  "autumn",
                ),
                _buildQuestionPage(
                  "Планы отменились и у вас неожиданно появилось много свободного времени, ваши действия?",
                  "spring",
                ),
                _buildQuestionPage(
                  "Какую погоду вы предпочитаете?",
                  "summer",
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Закрыть"),
            ),
          ],
        ),
      );

  void _showSummary() {
    Navigator.of(context).pop(); // Закрываем диалог опросника
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Результаты опроса"),
        content: Text(
          'Зима: $winter\nОсень: $autumn\nВесна: $spring\nЛето: $summer',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Закрыть"),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _reset();
                _showQuestionnaireDialog(context);
              },
              child: const Text("Пройти опрос заново"))
        ],
      ),
    );
  }

  Widget _buildQuestionPage(String question, String season) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          question,
          style: const TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            5,
            (index) => ElevatedButton(
              onPressed: () => _selectSeason(index + 1, season),
              child: Text('${index + 1}'),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Опрос"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _showQuestionnaireDialog(context),
          child: const Text("Начать опрос"),
        ),
      ),
    );
  }
}
