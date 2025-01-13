import requests
from datetime import datetime, timedelta
from django.utils.dateparse import parse_date, parse_time
from app.models import Forecast, City


def fetch_weather_for_city(city_name, start_year=2023, end_year=2024):
    """
    Получает данные о погоде для заданного города за весь период с 2023 по 2024 годы
    с разбивкой по 14 дней.
    """
    API_KEY = "5QKY43EEZTAAP4RYUSGUGJATE"
    API_URL = "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline"

    # Проверяем, что город существует в базе
    try:
        city = City.objects.get(city_en=city_name)
    except City.DoesNotExist:
        raise Exception(f"City '{city_name}' not found in the database.")

    # Начальная и конечная даты
    start_date = datetime(start_year, 1, 1)
    end_date = datetime(end_year, 12, 31)
    delta = timedelta(days=14)  # Интервал в 14 дней

    current_date = start_date

    while current_date <= end_date:
        # Определяем диапазон: от текущей даты до +14 дней
        range_start = current_date
        range_end = min(current_date + delta - timedelta(days=1), end_date)

        # Формируем запрос
        response = requests.get(
            f'{API_URL}/{city_name}/{range_start.strftime("%Y-%m-%d")}/{range_end.strftime("%Y-%m-%d")}',
            params={"key": API_KEY},
        )

        if response.status_code != 200:
            print(
                f"Failed to fetch data for {range_start} to {range_end}: {response.status_code}"
            )
            current_date += delta
            continue

        data = response.json()

        # Проверяем данные
        if not data or "days" not in data:
            print(f"No data for {range_start} to {range_end}")
            current_date += delta
            continue

        # Сохраняем данные в базу
        for day in data["days"]:
            date = parse_date(day["datetime"])
            max_temp = day.get("tempmax", None)
            min_temp = day.get("tempmin", None)

            if "hours" in day:
                for hour in day["hours"]:
                    time = parse_time(hour.get("datetime", "00:00:00"))
                    temperature = hour.get("temp", None)
                    conditions = hour.get("conditions", None)
                    pressure = hour.get("pressure", None)
                    humidity = hour.get("humidity", None)
                    wind_speed = hour.get("windspeed", None)

                    # Сохранение данных
                    Forecast.objects.update_or_create(
                        city=city,
                        date=date,
                        time=time,
                        defaults={
                            "max_temp": max_temp,
                            "min_temp": min_temp,
                            "temperature": temperature,
                            "conditions": conditions,
                            "pressure": pressure,
                            "humidity": humidity,
                            "wind_speed": wind_speed,
                        },
                    )

        print(f"Data saved for range {range_start.date()} to {range_end.date()}")

        # Переход к следующему интервалу
        current_date += delta


def parse():

    for i in City.objects.all():
        fetch_weather_for_city(i.city_en)
