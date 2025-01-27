import 'package:chopper/chopper.dart';

part '../../../.gen/core/api/services/forecast.chopper.dart';

@ChopperApi()
abstract class ForecastService extends ChopperService {
  @Get(path: '/forecast/today')
  Future<Response> forecastToday(
    @Query('date') String date, {
    @Query('city') String? city,
  });
  @Get(path: '/forecast/week')
  Future<Response> forecastWeek(
    @Query('date') String date, {
    @Query('city') String? city,
  });
  @Get(path: '/forecast/today24')
  Future<Response> forecastToday24(
    @Query('date') String date, {
    @Query('city') String? city,
  });

  static ForecastService create([ChopperClient? client]) =>
      _$ForecastService(client);
}
