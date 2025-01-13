import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/api/chopper.dart';
import 'package:flutter_application_1/core/api/services/forecast.dart';

class WeekForecast extends StatefulWidget {
  const WeekForecast({super.key});

  @override
  State<WeekForecast> createState() => _WeekForecastState();
}

class _WeekForecastState extends State<WeekForecast> {
  Map<String, dynamic>? _forecastDataWeek;
  bool _isLoading = true;
  bool _fetchError = false;

  Future<void> _fetchForecastWeek() async {
    try {
      final response = await api
          .getService<ForecastService>()
          .forecastWeek("2023-01-01 14:34");
      if (response.isSuccessful) {
        setState(() {
          _forecastDataWeek = Map<String, dynamic>.from(response.body);
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _fetchError = true;
        });
      }
    } catch (error) {
      setState(
        () {
          _isLoading = false;
          _fetchError = true;
        },
      );
    }
  }

  Future<void> _loadData() async {
    await Future.delayed(const Duration(milliseconds: 500));
    await _fetchForecastWeek();
    setState(() {
      _isLoading = false;
      _fetchError = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      alignment: Alignment.topCenter,
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _fetchError || _forecastDataWeek == null
              ? const Center(child: Text('Не удалось загрузить данные'))
              : Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Прогноз на 7 дней',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      _DayForecast(
                          date: 'Сегодня', minTemp: -243, maxTemp: 500),
                      Divider(),
                      _DayForecast(date: 'Завтра', minTemp: -23, maxTemp: 22),
                      Divider(),
                      _DayForecast(date: '3', minTemp: -23, maxTemp: 22),
                      Divider(),
                      _DayForecast(date: '4', minTemp: -23, maxTemp: 22),
                      Divider(),
                      _DayForecast(date: '5', minTemp: -23, maxTemp: 22),
                      Divider(),
                      _DayForecast(date: '6', minTemp: -23, maxTemp: 22),
                      Divider(),
                      _DayForecast(date: '7', minTemp: -23, maxTemp: 22)
                    ],
                  ),
                ),
    );
  }
}

class _DayForecast extends StatelessWidget {
  final String date;
  final int minTemp;
  final int maxTemp;

  const _DayForecast({
    required this.date,
    required this.minTemp,
    required this.maxTemp,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(date),
        Spacer(),
        Text('От${minTemp}° до ${maxTemp}°'),
      ],
    );
  }
}
