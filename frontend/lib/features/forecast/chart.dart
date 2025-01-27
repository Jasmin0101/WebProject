import 'dart:math';

import 'package:chopper/chopper.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/api/chopper.dart';
import 'package:flutter_application_1/core/api/services/forecast.dart';
import 'package:http/http.dart' as http;

class ChartForecast extends StatefulWidget {
  final int? cityId;
  final DateTime date;

  const ChartForecast({
    super.key,
    this.cityId,
    required this.date,
  });

  @override
  State<ChartForecast> createState() => _ChartForecastState();
}

class _ChartForecastState extends State<ChartForecast> {
  List<int>? _data;

  bool _isLoading = true;
  bool _isError = false;

  Future<void> _fetchData() async {
    await Future.delayed(const Duration(seconds: 1));

    try {
      // Вот тут надо поменять на настоящий запрос
      final response = await api.getService<ForecastService>().forecastToday24(
            widget.date.toIso8601String(),
            city: widget.cityId?.toString(),
          );

      if (response.isSuccessful) {
        final responseData = response.body['forecasts'] as List<dynamic>;
        setState(() {
          _data = responseData.map((e) => e.toInt() as int).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _isError = true;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 100),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Прогноз на 24 часа',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            if (_isLoading)
              const SizedBox(
                height: 200,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            if (_isError)
              const SizedBox(
                height: 200,
                child: Center(
                  child: Text('Ошибка при загрузке данных'),
                ),
              ),
            if (!_isLoading && _data != null)
              SizedBox(
                height: 200,
                child: _Chart(
                  data: _data!,
                ),
              )
          ],
        ),
      ),
    );
  }
}

class _Chart extends StatelessWidget {
  final List<int> data;

  const _Chart({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: data.length * 50.0,
          child: LineChart(
            LineChartData(
              backgroundColor: Theme.of(context).colorScheme.surface,
              maxY:
                  data.reduce(max) + 5, // Fixed: Using reduce with max function
              minY: data.reduce(min) - 5,
              lineBarsData: [
                LineChartBarData(
                  spots: List.generate(
                    data.length,
                    (index) => FlSpot(index.toDouble(), data[index].toDouble()),
                  ),
                  isCurved: true,
                  color: const Color.fromARGB(255, 61, 215, 205),
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(
                    show: true, // Скрываем точки
                  ),
                  curveSmoothness: 0.2,
                  preventCurveOverShooting: true,
                ),
              ],
              extraLinesData: ExtraLinesData(
                horizontalLines: [
                  HorizontalLine(
                    y: data.reduce((a, b) => a + b) / data.length,
                    color: Colors.white.withValues(alpha: 0.5),
                    strokeWidth: 2,
                  ),
                ],
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  axisNameWidget: Text("Температура"),
                  axisNameSize: 16,
                  sideTitles: SideTitles(
                    showTitles: true,

                    reservedSize: 40,
                    // interval: (data.reduce(max) - data.reduce(min)) / 5,
                    maxIncluded: false,
                    minIncluded: false,
                    getTitlesWidget: (value, meta) {
                      return Center(
                        child: Text(
                          value.toInt().toString(),
                          style: const TextStyle(fontSize: 12),
                        ),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        '${value.toInt()}:00'.padLeft(5, '0'),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 12,
                        ),
                      );
                    },
                    interval: 1,
                  ),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: AxisTitles(
                  axisNameWidget: const Text("Температура"),
                  axisNameSize: 16,
                  sideTitles: SideTitles(
                    showTitles: true,

                    reservedSize: 40,
                    // interval: (data.reduce(max) - data.reduce(min)) / 5,
                    maxIncluded: false,
                    minIncluded: false,
                    getTitlesWidget: (value, meta) {
                      return Center(
                        child: Text(
                          value.toInt().toString(),
                          style: const TextStyle(fontSize: 12),
                        ),
                      );
                    },
                  ),
                ),
              ),
              gridData: const FlGridData(show: true),
              borderData: FlBorderData(
                show: true,
                border: Border(
                  left: BorderSide(
                    color: Theme.of(context).colorScheme.surfaceContainer,
                    width: 1,
                  ),
                  bottom: BorderSide(
                    color: Theme.of(context).colorScheme.surfaceContainer,
                    width: 0,
                  ),
                ),
              ),
              lineTouchData: const LineTouchData(
                enabled: false,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
