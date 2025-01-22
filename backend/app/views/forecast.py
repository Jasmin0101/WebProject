import json
from datetime import datetime, timedelta

from django.contrib.auth.hashers import check_password, make_password
from django.http import (
    HttpRequest,
    HttpResponse,
    HttpResponseBadRequest,
    HttpResponseNotAllowed,
    JsonResponse,
)
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_http_methods
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework_simplejwt.tokens import AccessToken, RefreshToken

from app.decorator import require_login
from app.models import *


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

        forecast_dict = {}
        for i in forecasts:
            if forecast_dict.get(i.date) == None:
                forecast_dict[i.date] = i

        print(forecast_dict)
        forecast_list = []

        def which_weekday(start, day):
            if start.weekday() == day.weekday():
                return "Сегодня"
            if (start.weekday() + 1) % 7 == day.weekday():
                return "Завтра"
            if day.weekday() == 0:
                return "Пн"
            if day.weekday() == 1:
                return "Вт"
            if day.weekday() == 2:
                return "Ср"
            if day.weekday() == 3:
                return "Чт"
            if day.weekday() == 4:
                return "Пт"
            if day.weekday() == 5:
                return "Сб"
            if day.weekday() == 6:
                return "Вс"

        for key in forecast_dict.keys():
            forecast_list.append(
                {
                    "date": key.strftime("%Y-%m-%d"),
                    "max_temp": forecast_dict[key].max_temp,
                    "min_temp": forecast_dict[key].max_temp,
                    "conditions": forecast_dict[key].conditions,
                    "day_name": which_weekday(start_date, key),
                }
            )

        # Формируем ответ
        # forecast_list = [
        #     {
        #         "date": forecast.date.strftime("%Y-%m-%d"),
        #         "max_temp": forecast.max_temp,
        #         "min_temp": forecast.max_temp,
        #         # "conditions": forecast.conditions,
        #     }
        #     for forecast in forecasts
        # ]

        return JsonResponse({"forecasts": forecast_list}, status=200)

    except json.JSONDecodeError:
        return JsonResponse({"error": "Invalid JSON format"}, status=400)
    except Exception as e:
        return JsonResponse({"error": str(e)}, status=500)


@csrf_exempt
@require_http_methods(["GET"])
@require_login
def today24(request: HttpRequest, user: User) -> HttpResponse:
    try:

        # Получаем данные из тела запроса
        city = request.GET.get("city", user.city.id)
        time = request.GET.get("time")[10:]
        date = request.GET.get("time")[:10]
        print(city, time, date)
        # Проверяем, что обязательные параметры переданы
        if not city or not date:
            return HttpResponseBadRequest("Missing 'city' or 'date' parameter")

        # Получаем прогнозы за указанный день
        forecasts = Forecast.objects.filter(city=city, date=date).order_by("time")

        print(forecasts)
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
