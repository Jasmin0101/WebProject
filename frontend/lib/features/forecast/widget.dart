import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/city.dart';
import 'service.dart';

class ForecastWidget extends StatefulWidget {
  final City city;
  final DateTime date;

  const ForecastWidget({
    super.key,
    required this.city,
    required this.date,
  });

  @override
  _ForecastWidgetState createState() => _ForecastWidgetState();
}

class _ForecastWidgetState extends State<ForecastWidget> {
  bool _isLoading = true;
  bool _isError = false;
  Forecast? _forecast;
  double? _temp;

  // Метод для загрузки данных с API погоды
  Future<void> _fetchForecast() async {
    try {
      final response = await ForecastService.get(widget.city, widget.date);
      setState(() {
        _forecast = response['forecast'];
        _temp = response['temp'];
        _isLoading = false;
      });
    } catch (_) {
      setState(() {
        _isError = true;
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchForecast();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(), // Показ прогресса загрузки
      );
    }

    if (_isError || _forecast == null || _temp == null) {
      return const Center(
        child: Text("Произошла ошибка во время загрузки данных погоды :/"),
      );
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image:
              AssetImage(_forecast!.asset), // Декорация фона на основе погоды
        ),
      ),
      child: TempWidget(temp: _temp!),
    );
  }
}

class TempWidget extends StatelessWidget {
  final double temp;

  const TempWidget({super.key, required this.temp});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .primaryContainer
                  .withOpacity(0.7),
              borderRadius: BorderRadius.circular(50),
            ),
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            child: Text(
              '${temp.toString()}°C',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 22,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
