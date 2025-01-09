import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/forecast/chart.dart';
import 'package:flutter_application_1/features/forecast/widget.dart';
import 'package:intl/intl.dart';

import 'package:fl_chart/fl_chart.dart';

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
        title: Text("Добро пожаловать :>"),
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage("assets/img/snowy.jpg"), ///////////
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primaryContainer
                          .withOpacity(0.7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      " Погода ${city.name[1] == 'В' ? 'во' : "в"} ${city.name}е ",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ],
              ),
            ),
            const Row(
              children: [
                ChartWidget(),
              ],
            ),
          ],
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
