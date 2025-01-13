import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ChartForecast extends StatefulWidget {
  const ChartForecast({super.key});

  @override
  State<ChartForecast> createState() => _ChartForecastState();
}

class _ChartForecastState extends State<ChartForecast> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Прогноз на 24 часа',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          _Chart()
        ],
      ),
    );
  }
}

class _Chart extends StatelessWidget {
  const _Chart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          backgroundColor: Theme.of(context).colorScheme.surface,
          lineBarsData: [
            LineChartBarData(
                spots: const [
                  FlSpot(0, 1),
                  FlSpot(1, 2),
                  FlSpot(2, -4),
                  FlSpot(3, 5),
                  FlSpot(4, 17),
                  FlSpot(5, 1),
                  FlSpot(6, -9),
                ],
                isCurved: true,
                color: const Color.fromARGB(255, 61, 215, 205),
                barWidth: 3,
                isStrokeCapRound: true,
                dotData: const FlDotData(
                  show: false, // Скрываем точки
                ),
                curveSmoothness: 0.2,
                preventCurveOverShooting: true),
          ],
          extraLinesData: ExtraLinesData(
            horizontalLines: [
              HorizontalLine(
                y: 0,
                color: Colors.white.withOpacity(0.5),
                strokeWidth: 2,
              ),
            ],
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(fontSize: 12),
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
            topTitles: AxisTitles(
              /// вот тут посмотреть

              axisNameWidget: Text(
                'Температура',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                ),
              ),
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
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
            enabled: false, // Отключаем взаимодействие с графиком
          ),
        ),
      ),
    );
  }
}
