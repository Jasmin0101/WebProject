import random
from datetime import datetime, timedelta
from django.utils.dateparse import parse_date, parse_time
from app.models import City, Forecast


def get_season(date):
    """Возвращает сезон в зависимости от месяца."""
    month = date.month
    if month in [12, 1, 2]:
        return "winter"
    elif month in [3, 4, 5]:
        return "spring"
    elif month in [6, 7, 8]:
        return "summer"
    elif month in [9, 10, 11]:
        return "autumn"


def generate_random_weather_sql(
    city_id, city_name, output_file, start_year=2025, end_year=2025
):
    """
    Генерирует SQL-запросы для случайных данных о погоде за период с 2023 по 2024 годы
    с разбивкой по 14 дней.
    """
    start_date = datetime(start_year, 1, 20)
    end_date = datetime(end_year, 2, 1)
    delta = timedelta(days=365 / 2)

    current_date = start_date

    while current_date <= end_date:
        # Определяем диапазон: от текущей даты до +14 дней
        range_start = current_date
        range_end = min(current_date + delta - timedelta(days=1), end_date)

        # Генерация случайных данных
        for single_date in (
            range_start + timedelta(days=i)
            for i in range((range_end - range_start).days + 1)
        ):
            # Определяем сезон
            season = get_season(single_date)

            # Генерация температуры и условий в зависимости от сезона
            if season == "winter":
                max_temp = random.uniform(-10, 5)
                min_temp = max_temp - random.uniform(0, 10)
                conditions = random.choice(["Clear", "Cloudy", "Snow", "Storm"])
            elif season == "spring":
                max_temp = random.uniform(5, 20)
                min_temp = max_temp - random.uniform(0, 10)
                conditions = random.choice(["Clear", "Cloudy", "Rain", "Windy"])
            elif season == "summer":
                max_temp = random.uniform(15, 40)
                min_temp = max_temp - random.uniform(0, 10)
                conditions = random.choice(["Clear", "Cloudy", "Rain", "Storm"])
            elif season == "autumn":
                max_temp = random.uniform(5, 15)
                min_temp = max_temp - random.uniform(0, 5)
                conditions = random.choice(["Clear", "Cloudy", "Rain", "Windy"])

            pressure = random.uniform(950, 1050)  # Давление в гПа
            humidity = random.uniform(10, 100)  # Влажность в процентах
            wind_speed = random.uniform(0, 20)  # Скорость ветра в м/с

            # Генерация данных по часам
            for hour in range(24):
                time = f"{hour:02}:00:00"
                temperature = random.uniform(min_temp, max_temp)

                # Формируем SQL-запрос
                sql_query = (
                    f"INSERT INTO app_forecast "
                    f"(city_id, date, time, temperature, conditions, pressure, humidity, wind_speed) "
                    f"VALUES ({city_id}, '{single_date.date()}', '{time}', "
                    f"{temperature:.2f}, '{conditions}', {pressure:.2f}, {humidity:.2f}, {wind_speed:.2f});\n"
                )
                output_file.write(sql_query)

        print(f"Generated SQL for range {range_start.date()} to {range_end.date()}")
        current_date += delta


def randomize():
    with open("randomize.sql", "w", encoding="utf-8") as file:
        file.write("-- SQL script to insert random weather data\n")
        for i in City.objects.all():
            generate_random_weather_sql(i.id, i.city_en, file)
