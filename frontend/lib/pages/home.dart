import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/forecast/widget.dart';
import 'package:intl/intl.dart';

import '../core/city.dart';
import '../features/quiz/service.dart';
import '../features/quiz/widgets/quiz.dart';
import '../navigation/navigator.dart';
import 'questionnaire.dart';

class HomePage extends StatelessWidget {
  final City city;
  final DateTime date;

  const HomePage({
    super.key,
    required this.city,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${city.name}"),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: [
              IconButton(
                icon: const Icon(Icons.mail),
                onPressed: () {
                  AppNavigator.openApplication();
                },
              ),
              IconButton(
                icon: const Icon(Icons.account_circle),
                onPressed: () {
                  // Логика для кнопки "Аккаунт"
                  AppNavigator.openAccount();
                },
              ),
              PopupMenuButton<City>(
                initialValue: city,
                onSelected: (City item) => AppNavigator.openWeather(item, date),
                itemBuilder: (context) => List.generate(
                  City.values.length,
                  (index) => PopupMenuItem<City>(
                    value: City.values[index],
                    child: Text(City.values[index].name),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 380,
          ),
          child: ListView(
              padding: const EdgeInsets.all(8),
              children: [ForecastWidget(city: city, date: date)]),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final date = await showDatePicker(
            context: context,
            initialDate: this.date,
            firstDate: DateTime(2023),
            lastDate: DateTime.now(),
          );
          if (date == null) return;

          AppNavigator.openWeather(city, date);
        },
        label: const Text("Выберете дату"),
        icon: const Icon(Icons.calendar_month),
      ),
    );
  }
}

class CityCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const CityCard({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 140,
      ),
      child: Card(
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Center(
            child: Text(title),
          ),
        ),
      ),
    );
  }
}

Future<void> _showQuizDialog(BuildContext context) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => QuizWidget(
      quiz: QuizService.generateQuiz(),
    ),
  );
}
