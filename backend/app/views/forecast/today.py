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
def today(request: HttpRequest, user: User) -> HttpResponse:
    try:
        city_id = request.GET.get("city", user.city.id)
        date_str = request.GET.get("date")[:10]

        if not city_id or not date_str:
            return HttpResponseBadRequest("Not all required fields are provided.")

        # Преобразование строки даты в объект datetime
        try:
            date = datetime.strptime(date_str, "%Y-%m-%d")
        except ValueError as e:
            return HttpResponseBadRequest(f"Invalid date format. {e}")

        city = City.objects.get(id=city_id)
        # Получение прогнозов за выбранный день
        forecast = Forecast.objects.filter(city=city_id, date=date)

        if len(forecast) >= 24:
            return JsonResponse(
                {
                    "city": city.city,
                    "temperature": mean([f.temperature for f in forecast]),
                    "weather_type": forecast[0].conditions,
                }
            )

        # Если данных за день недостаточно, получаем среднюю температуру за те же дни предыдущих 10 лет
        past_years_temperatures = []
        for year_offset in range(1, 11):
            past_date = date - timedelta(days=365 * year_offset)
            past_forecast = Forecast.objects.filter(city=city_id, date=past_date)

            if past_forecast:
                past_temperatures = [f.temperature for f in past_forecast]
                if past_temperatures:
                    past_years_temperatures.append(mean(past_temperatures))

        # Также добавляем данные за 30 дней до и после текущей даты
        range_temperatures = []
        for day_offset in range(-30, 31):
            range_date = date + timedelta(days=day_offset)
            range_forecast = Forecast.objects.filter(city=city_id, date=range_date)

            if range_forecast:
                range_temperatures.extend([f.temperature for f in range_forecast])

        # Объединяем исторические и диапазонные температуры
        combined_temperatures = past_years_temperatures + range_temperatures

        if not combined_temperatures:
            return JsonResponse(
                {"error": "Insufficient data for this day."}, status=404
            )

        average_temperature = mean(combined_temperatures)

        return JsonResponse(
            {
                "city": city.city,
                "temperature": average_temperature,
                "weather_type": forecast[0].conditions if forecast else "Unknown",
                "note": "Temperature is calculated based on historical and range data.",
            }
        )

    except Exception as e:
        return JsonResponse({"error": str(e)}, status=500)


def local_today(city_id: int, date_str: str) -> dict:
    try:

        if not city_id or not date_str:
            return HttpResponseBadRequest("Not all required fields are provided.")

        # Преобразование строки даты в объект datetime
        try:
            date = datetime.strptime(date_str, "%Y-%m-%d")
        except ValueError as e:
            return HttpResponseBadRequest(f"Invalid date format. {e}")

        city = City.objects.get(id=city_id)
        # Получение прогнозов за выбранный день
        forecast = Forecast.objects.filter(city=city_id, date=date)

        if len(forecast) >= 24:
            return {
                "city": city.city,
                "temperature": mean([f.temperature for f in forecast]),
                "weather_type": forecast[0].conditions,
            }

        # Если данных за день недостаточно, получаем среднюю температуру за те же дни предыдущих 10 лет
        past_years_temperatures = []
        for year_offset in range(1, 11):
            past_date = date - timedelta(days=365 * year_offset)
            past_forecast = Forecast.objects.filter(city=city_id, date=past_date)

            if past_forecast:
                past_temperatures = [f.temperature for f in past_forecast]
                if past_temperatures:
                    past_years_temperatures.append(mean(past_temperatures))

        # Также добавляем данные за 30 дней до и после текущей даты
        range_temperatures = []
        for day_offset in range(-30, 31):
            range_date = date + timedelta(days=day_offset)
            range_forecast = Forecast.objects.filter(city=city_id, date=range_date)

            if range_forecast:
                range_temperatures.extend([f.temperature for f in range_forecast])

        # Объединяем исторические и диапазонные температуры
        combined_temperatures = past_years_temperatures + range_temperatures

        if not combined_temperatures:
            return {"error": "Insufficient data for this day."}

        average_temperature = mean(combined_temperatures)

        return {
            "city": city.city,
            "temperature": average_temperature,
            "weather_type": forecast[0].conditions if forecast else "Unknown",
            "note": "Temperature is calculated based on historical and range data.",
        }

    except Exception as e:
        return JsonResponse({"error": str(e)}, status=500)
