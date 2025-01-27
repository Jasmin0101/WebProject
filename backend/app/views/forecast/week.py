import json
from datetime import datetime, timedelta
from statistics import mean

from django.http import HttpRequest, HttpResponse, HttpResponseBadRequest, JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_http_methods

from app.decorator import require_login
from app.models import City, Forecast, User
from app.views.forecast.today import local_today, today
from app.views.forecast.today24 import local_today24, today24


@csrf_exempt
@require_http_methods(["GET"])
@require_login
def week(request: HttpRequest, user: User) -> HttpResponse:
    try:
        city_id = request.GET.get("city", user.city.id)
        start_date_str = request.GET.get("date")[:10]

        if not city_id or not start_date_str:
            return JsonResponse(
                {"error": "Missing 'city' or 'date' parameter"}, status=400
            )

        # Преобразуем дату из строки в объект datetime
        try:

            start_date = datetime.strptime(start_date_str, "%Y-%m-%d")
        except Exception as e:
            return JsonResponse(
                {"error": f" Error : {str(e)} "},
                status=400,
            )

        forecast_list = []

        for i in range(7):

            date = start_date + timedelta(days=i)

            day24 = local_today24(city_id, date.strftime("%Y-%m-%d"))
            day = local_today(city_id, date.strftime("%Y-%m-%d"))

            forecast_list.append(
                {
                    "date": date.strftime("%Y-%m-%d"),
                    "max_temp": max(day24["forecasts"]),
                    "min_temp": min(day24["forecasts"]),
                    "conditions": day["weather_type"],
                    "day_name": date.strftime("%d.%m"),
                }
            )

        print(forecast_list)
        return JsonResponse({"forecasts": forecast_list}, status=200)

    except json.JSONDecodeError:
        return JsonResponse({"error": "Invalid JSON format"}, status=400)
    except Exception as e:
        return JsonResponse({"error": str(e)}, status=500)
