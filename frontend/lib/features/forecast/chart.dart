import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ChartWidget extends StatefulWidget {
  const ChartWidget({super.key});

  @override
  State<ChartWidget> createState() => _ChartWidgetState();
}

class _ChartWidgetState extends State<ChartWidget> {
  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        backgroundColor: const Color.fromARGB(164, 2, 51, 74),
        lineBarsData: [
          LineChartBarData(
            spots: const [
              FlSpot(0, -31),
              FlSpot(1, 0),
              FlSpot(2, -4),
              FlSpot(3, 30),
              FlSpot(4, 17),
              FlSpot(5, 1),
              FlSpot(6, -31),
            ],
            isCurved: true,
            gradient: const LinearGradient(
              colors: [
                Color.fromARGB(255, 5, 50, 155),
                Color.fromARGB(255, 61, 215, 205),
                Color.fromARGB(255, 255, 253, 155),
              ],
            ),
            barWidth: 3,
            isStrokeCapRound: true,
            belowBarData: BarAreaData(
              show: true,
              color: Colors.teal.withOpacity(0.2),
            ),
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, _, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: Colors.tealAccent,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
          ),
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
              interval: 10,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const days = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
                return Text(
                  days[value.toInt()],
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                );
              },
              interval: 1,
            ),
          ),
          topTitles: const AxisTitles(
            axisNameWidget: Text(
              'Температура',
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
            axisNameSize: 40,
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false), // Убрали правую сторону
          ),
        ),
        gridData: const FlGridData(show: true),
        borderData: FlBorderData(
          show: true,
          border: const Border(
            left: BorderSide(color: Colors.white, width: 1),
            bottom: BorderSide(color: Colors.white, width: 1),
          ),
        ),
      ),
    );
  }
}
