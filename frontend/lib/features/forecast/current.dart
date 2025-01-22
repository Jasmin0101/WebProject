import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/api/chopper.dart';
import 'package:flutter_application_1/core/api/services/forecast.dart';
import 'package:flutter_application_1/core/api/services/user.dart';

/// Виджет для отображения текущей погоды
///
///
class CurrentForecast extends StatefulWidget {
  final int? cityId;

  const CurrentForecast({super.key, this.cityId});
  @override
  State<CurrentForecast> createState() => _CurrentForecastState();
}

class _CurrentForecastState extends State<CurrentForecast> {
  Map<String, dynamic>? _userData;
  Map<String, dynamic>? _forecastData;
  bool _isLoading = true;
  bool _fetchError = false;

  Future<void> _fetchUser() async {
    try {
      final response = await api.getService<UserService>().userMeView();
      if (response.isSuccessful && response.body != null) {
        setState(() {
          _userData = Map<String, dynamic>.from(response.body);
        });
      } else {
        // Обработка ошибки
        setState(() {
          _isLoading = false;
        });
      }
    } catch (error) {
      // Обработка исключений
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchForecastToday() async {
    try {
      final response = await api.getService<ForecastService>().forecastToday(
            "2023-01-01 14:00",
            city: widget.cityId?.toString(),
          );
      if (response.isSuccessful) {
        setState(() {
          _forecastData = Map<String, dynamic>.from(response.body);
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
    await _fetchUser();
    if (_userData != null) {
      await _fetchForecastToday();
    } else {
      setState(() {
        _isLoading = false;
        _fetchError = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  String _getWeatherDescription(String type) => switch (type) {
        "Snow" => "Снег",
        _ => "Не определено",
      };

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 189),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _fetchError || _forecastData == null
                  ? const Center(child: Text('Не удалось загрузить данные'))
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(width: double.infinity),
                        Text(
                          _forecastData!['city'] ??
                              "Местоположение не известно",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "${_forecastData!['temperature'].toInt().toString()}°C",
                          style: const TextStyle(
                            fontSize: 100,
                            fontWeight: FontWeight.w100,
                          ),
                        ),
                        Text(
                          _getWeatherDescription(
                              _forecastData!['weather_type']),
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
        ),
      ),
    );
  }
}
