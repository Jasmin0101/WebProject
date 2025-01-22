import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/date_time/date_selector.dart';
import 'package:flutter_application_1/features/forecast/chart.dart';
import 'package:flutter_application_1/features/forecast/city_selector.dart';
import 'package:flutter_application_1/features/forecast/current.dart';
import 'package:flutter_application_1/features/forecast/week.dart';

import '../features/quiz/service.dart';
import '../features/quiz/widgets/quiz.dart';
import '../navigation/navigator.dart';

class HomePage extends StatelessWidget {
  final int? cityId;
  final DateTime? date;

  const HomePage({
    super.key,
    this.cityId,
    this.date,
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
              // IconButton(
              //   icon: const Icon(Icons.mail),
              //   onPressed: () {
              //     AppNavigator.openApplication();
              //   },
              // ),
              IconButton(
                icon: const Icon(Icons.account_circle),
                onPressed: () {
                  // Логика для кнопки "Аккаунт"
                  AppNavigator.openUser();
                },
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
              Row(
                children: [
                  CurrentForecast(),
                  // DateSelector(currentDate: DateTime.now)
                ],
              ),
              SizedBox(
            children: [
              const CurrentForecast(),
              const SizedBox(
                height: 32,
              ),
              const WeekForecast(),
              const SizedBox(
                height: 8,
              ),
              const ChartForecast(),
              const SizedBox(
                height: 32,
              ),
              CitySelector(
                selectedCity: cityId,
              ),
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
