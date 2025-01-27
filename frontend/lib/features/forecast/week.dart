import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/api/chopper.dart';
import 'package:flutter_application_1/core/api/services/forecast.dart';

class WeekForecast extends StatefulWidget {
  final int? cityId;
  final DateTime date;

  const WeekForecast({
    super.key,
    this.cityId,
    required this.date,
  });

  @override
  State<WeekForecast> createState() => _WeekForecastState();
}

class _WeekForecastState extends State<WeekForecast> {
  Map<String, dynamic>? _forecastDataWeek;
  bool _isLoading = true;
  bool _fetchError = false;

  Future<void> _fetchForecastWeek() async {
    try {
      final response = await api.getService<ForecastService>().forecastWeek(
            widget.date.toIso8601String(),
            city: widget.cityId?.toString(),
          );
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
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 298),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Builder(
            builder: (context) {
              if (_isLoading) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  height: 298,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              final isError = _fetchError || _forecastDataWeek == null;

              if (isError) {
                return const Center(child: Text('Не удалось загрузить данные'));
              }

              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Прогноз на 7 дней',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ...List.generate(
                      _forecastDataWeek!['forecasts'].length,
                      (index) {
                        return Column(
                          children: [
                            _DayForecast(
                              date: _forecastDataWeek!['forecasts'][index]
                                  ['day_name'],
                              minTemp: _forecastDataWeek!['forecasts'][index]
                                      ['min_temp']
                                  .toInt(),
                              maxTemp: _forecastDataWeek!['forecasts'][index]
                                      ['max_temp']
                                  .toInt(),
                            ),
                            if (index != 6) const Divider(),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
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
        const Spacer(),
        Text('От $minTemp° до $maxTemp°'),
      ],
    );
  }
}
