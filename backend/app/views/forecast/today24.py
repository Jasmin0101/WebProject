import json
from datetime import datetime, timedelta
from statistics import mean

from django.http import HttpRequest, HttpResponse, HttpResponseBadRequest, JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_http_methods

from app.decorator import require_login
from app.models import City, Forecast, User


@csrf_exempt
@require_http_methods(["GET"])
@require_login
def today24(request: HttpRequest, user: User) -> HttpResponse:
    try:
        city_id = request.GET.get("city", user.city.id)
        date_str = request.GET.get("date")[:10]

        if not city_id or not date_str:
            return HttpResponseBadRequest("Not all required fields are provided.")

        # Преобразование строки даты в объект datetime
        try:
            date = datetime.strptime(date_str, "%Y-%m-%d")
        except ValueError:
            return HttpResponseBadRequest("Invalid date format. Use YYYY-MM-DD.")

        city = City.objects.get(id=city_id)
        # Получение прогнозов за выбранный день
        forecast = Forecast.objects.filter(city=city_id, date=date)

        hourly_temperatures = {}
        if len(forecast) >= 24:
            for hour in range(24):
                hourly_data = forecast
                if hourly_data:
                    hourly_temperatures[hour] = mean(
                        [f.temperature for f in hourly_data]
                    )

            return JsonResponse(
                {
                    "city": city.city,
                    "forecasts": list(hourly_temperatures.values()),
                }
            )

        # Если данных за день недостаточно, получаем данные за те же дни предыдущих 10 лет и за диапазон ±30 дней
        for hour in range(24):
            past_years_temperatures = []
            for year_offset in range(1, 11):
                past_date = date - timedelta(days=365 * year_offset)
                past_forecast = Forecast.objects.filter(
                    city=city_id,
                    date=past_date,
                )

                if past_forecast:
                    past_temperatures = [f.temperature for f in past_forecast]
                    if past_temperatures:
                        past_years_temperatures.append(mean(past_temperatures))

            range_temperatures = []
            for day_offset in range(-30, 31):
                range_date = date + timedelta(days=day_offset)
                range_forecast = Forecast.objects.filter(
                    city=city_id,
                    date=range_date,
                )

                if range_forecast:
                    range_temperatures.extend([f.temperature for f in range_forecast])

            combined_temperatures = past_years_temperatures + range_temperatures

            if combined_temperatures:
                hourly_temperatures[hour] = mean(combined_temperatures)

        if not hourly_temperatures:
            return JsonResponse(
                {"error": "Insufficient data for this day."}, status=404
            )

        return JsonResponse(
            {
                "city": city.city,
                "forecasts": list(hourly_temperatures.values()),
            }
        )

    except Exception as e:
        return JsonResponse({"error": str(e)}, status=500)


def local_today24(city_id: int, date_str: str) -> dict:
    try:

        if not city_id or not date_str:
            return HttpResponseBadRequest("Not all required fields are provided.")

        # Преобразование строки даты в объект datetime
        try:
            date = datetime.strptime(date_str, "%Y-%m-%d")
        except ValueError:
            return HttpResponseBadRequest("Invalid date format. Use YYYY-MM-DD.")

        city = City.objects.get(id=city_id)
        # Получение прогнозов за выбранный день
        forecast = Forecast.objects.filter(city=city_id, date=date)

        hourly_temperatures = {}
        if len(forecast) >= 24:
            for hour in range(24):
                hourly_data = forecast
                if hourly_data:
                    hourly_temperatures[hour] = mean(
                        [f.temperature for f in hourly_data]
                    )

            return {
                "city": city.city,
                "forecasts": list(hourly_temperatures.values()),
            }

        # Если данных за день недостаточно, получаем данные за те же дни предыдущих 10 лет и за диапазон ±30 дней
        for hour in range(24):
            past_years_temperatures = []
            for year_offset in range(1, 11):
                past_date = date - timedelta(days=365 * year_offset)
                past_forecast = Forecast.objects.filter(
                    city=city_id,
                    date=past_date,
                )

                if past_forecast:
                    past_temperatures = [f.temperature for f in past_forecast]
                    if past_temperatures:
                        past_years_temperatures.append(mean(past_temperatures))

            range_temperatures = []
            for day_offset in range(-30, 31):
                range_date = date + timedelta(days=day_offset)
                range_forecast = Forecast.objects.filter(
                    city=city_id,
                    date=range_date,
                )

                if range_forecast:
                    range_temperatures.extend([f.temperature for f in range_forecast])

            combined_temperatures = past_years_temperatures + range_temperatures

            if combined_temperatures:
                hourly_temperatures[hour] = mean(combined_temperatures)

        if not hourly_temperatures:
            return {"error": "Insufficient data for this day."}

        return {
            "city": city.city,
            "forecasts": list(hourly_temperatures.values()),
        }

    except Exception as e:
        return {"error": str(e)}
