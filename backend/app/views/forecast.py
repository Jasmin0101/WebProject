from datetime import datetime, timedelta

import json
from django.http import (
    HttpRequest,
    HttpResponseBadRequest,
    HttpResponseNotAllowed,
    JsonResponse,
    HttpResponse,
)
from django.views.decorators.csrf import csrf_exempt
from django.contrib.auth.hashers import check_password, make_password
from app.decorator import require_login
from app.models import *

from rest_framework_simplejwt.tokens import RefreshToken, AccessToken
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from django.views.decorators.http import require_http_methods


@csrf_exempt
@require_http_methods(["GET"])
@require_login
def my_view(request: HttpRequest, user: User) -> HttpResponse:

    pass


@csrf_exempt
@require_http_methods(["GET"])
@require_login
def today(request: HttpRequest, user: User) -> HttpResponse:
    try:
        # Получаем параметры из GET-запроса
        city_id = request.GET.get("city", user.city.id)
        time = request.GET.get("time")[10:]
        date = request.GET.get("time")[:11]
        if not city_id or not time:
            return HttpResponseBadRequest("Not all required fields are provided.")

        forecast = Forecast.objects.filter(city=city_id).first()

        if not forecast:
            return JsonResponse({"error": "Forecast not found"}, status=404)

        return JsonResponse(
            {
                "city": forecast.city.city,
                "temperature": forecast.temperature,
                "weather_type": forecast.conditions,
            }
        )

    except Exception as e:
        return JsonResponse({"error": str(e)}, status=500)


@csrf_exempt
@require_http_methods(["GET"])
@require_login
def week(request: HttpRequest, user: User) -> HttpResponse:
    try:
        city_id = request.GET.get("city", user.city.id)
        start_date_str = request.GET.get("time")[:10]

        if not city_id or not start_date_str:
            return JsonResponse(
                {"error": "Missing 'city' or 'date' parameter"}, status=400
            )
        print(start_date_str)

        # Преобразуем дату из строки в объект datetime
        try:

            start_date = datetime.strptime(start_date_str, "%Y-%m-%d")
        except Exception as e:
            return JsonResponse(
                {"error": f" Error : {str(e)} "},
                status=400,
            )

        # Определяем диапазон дат (7 дней)
        end_date = start_date + timedelta(days=6)

        # Получаем прогнозы из базы данных
        forecasts = Forecast.objects.filter(
            city=city_id, date__range=[start_date, end_date]
        ).order_by("date")

        # Формируем ответ
        forecast_list = [
            {
                "date": forecast.date.strftime("%Y-%m-%d"),
                "max_temp": forecast.max_temp,
                "min_temp": forecast.max_temp,
                "conditions": forecast.conditions,
            }
            for forecast in forecasts
        ]

        return JsonResponse({"forecasts": forecast_list}, status=200)

    except json.JSONDecodeError:
        return JsonResponse({"error": "Invalid JSON format"}, status=400)
    except Exception as e:
        return JsonResponse({"error": str(e)}, status=500)


@csrf_exempt
@require_http_methods(["GET"])
def today_24(request):
    try:

        # Получаем данные из тела запроса
        city = request.GET.get("city")
        date = request.GET.get("date")

        # Проверяем, что обязательные параметры переданы
        if not city or not date:
            return HttpResponseBadRequest("Missing 'city' or 'date' parameter")

        # Получаем прогнозы за указанный день
        forecasts = Forecast.objects.filter(city=city, date=date).order_by("time")

        # Проверяем, есть ли данные
        if not forecasts.exists():
            return JsonResponse(
                {"error": "No forecasts found for the specified city and date"},
                status=404,
            )

        # Формируем ответ
        forecast_list = [
            {
                "time": forecast.time.strftime("%H:%M"),
                "temperature": forecast.temperature,
            }
            for forecast in forecasts
        ]

        return JsonResponse(
            {"city": city, "date": date, "forecasts": forecast_list}, status=200
        )

    except json.JSONDecodeError:
        return JsonResponse({"error": "Invalid JSON format"}, status=400)
    except Exception as e:
        return JsonResponse({"error": str(e)}, status=500)
