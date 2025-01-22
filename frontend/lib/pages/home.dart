import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/forecast/chart.dart';
import 'package:flutter_application_1/features/forecast/city_selector.dart';
import 'package:flutter_application_1/features/forecast/current.dart';
import 'package:flutter_application_1/features/forecast/week.dart';

import '../core/city.dart';
import '../features/quiz/service.dart';
import '../features/quiz/widgets/quiz.dart';
import '../navigation/navigator.dart';

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
        title: const Text("Добро пожаловать :>"),
        centerTitle: true,
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
                  AppNavigator.openUser();
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
            maxWidth: 720,
          ),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: const [
              CurrentForecast(),
              SizedBox(
                height: 32,
              ),
              WeekForecast(),
              SizedBox(
                height: 8,
              ),
              ChartForecast(),
              SizedBox(
                height: 32,
              ),
              CitySelector(),
            ],
          ),
        ),
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
