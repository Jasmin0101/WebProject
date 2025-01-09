import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../core/city.dart';
import '../features/forecast/widget.dart';
import '../navigation/navigator.dart';

class WeatherPage extends StatelessWidget {
  final City city;
  final DateTime date;

  const WeatherPage({
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
      body: ForecastWidget(
        key: UniqueKey(),
        city: city,
        date: date,
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
