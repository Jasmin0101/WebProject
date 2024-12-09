import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../core/city.dart';

final class ForecastService {
  // Ajax для создания запроса на сайт Weatherapi по ключу apiKey
  static Future<Map<String, dynamic>> get(City city, DateTime date) async {
    final apiKey = '49e5ca8e4dd5453ca3e50132242310';

    final url = Uri.parse(
        'https://api.weatherapi.com/v1/history.json?key=$apiKey&q=${city.queryName}&dt=$date');

    final response = await http.get(url);
    // запрос представляет собой Json файл, ниже просписан разпарсинг нужных нам данных
    final data = jsonDecode(response.body);
    final dayWeather = data['forecast']['forecastday'][0]['day'];

    final avgTemp = dayWeather['avgtemp_c'];
    final condition = dayWeather['condition']['text'];
    final dailyForecast = _getForecastFromWeatherApi(condition);

    return {"temp": avgTemp, "forecast": dailyForecast};
  }
  // обработка данных из запроса на сайт weatherapi

  static Forecast _getForecastFromWeatherApi(String weatherData) {
    String description = weatherData.toLowerCase();

    if (description.contains('rain') || description.contains('дождь')) {
      return Forecast.rainy;
    } else if (description.contains('snow') || description.contains('снег')) {
      return Forecast.snowy;
    } else if (description.contains('fog') ||
        description.contains('туман') ||
        description.contains('mist') ||
        description.contains('дымка')) {
      return Forecast.foggy;
    } else {
      return Forecast.sunny;
    }
  }
}

// написание Enum перемненным в даном случае с типом данных Forecast
enum Forecast {
  sunny,
  rainy,
  foggy,
  snowy;

  String get name => switch (this) {
        Forecast.foggy => "Туман",
        Forecast.rainy => "Дождь",
        Forecast.snowy => "Снег",
        Forecast.sunny => "Солнце",
      };

  String get asset => switch (this) {
        Forecast.foggy => "/img/foggy.webp",
        Forecast.rainy => "/img/rainy.jpg",
        Forecast.snowy => "/img/snowy.jpg",
        Forecast.sunny => "/img/sunny.webp",
      };
}
