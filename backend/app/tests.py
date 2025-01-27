from django.test import TestCase
from django.urls import reverse
from rest_framework.test import APIClient
from rest_framework import status
from app.models import Forecast, City, User
from datetime import datetime, timedelta


class ForecastViewsTests(TestCase):

    def setUp(self):

        # Создаем тестовый город
        self.city = City.objects.create(city="Москва", city_en="Moscow")
        # Создаем тестового пользователя
        self.user = User.objects.create(
            login="testuser1",
            password="Testuser1",
            dob="1990-01-01",
            status="US",
            name="Test",
            surname="User",
            city=self.city,
            email="testuser@example.com",
        )
        # Создаем прогноз на тестовую дату
        self.forecast = Forecast.objects.create(
            city=self.city,
            date="2025-01-01",
            time="12:00:00",
            temperature=5.0,
            conditions="Cloudy",
            pressure=1015.0,
            humidity=80.0,
            wind_speed=10.0,
        )
        self.client = APIClient()

        response = self.client.post(
            reverse("login"),
            '{"login": "testuser", "password": "testuser"}',
            content_type="application/json",
        )

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.token = response.data["token"]

    def test_today_view(self):
        # Проверка запроса с корректным городом и временем
        url = reverse("forecast/today")  # Замените на правильный URL
        response = self.client.get(
            url,
            # {"city": 1, "time": "2025-01-27T12:00:00"},
            QUERY_STRING="?time=2025-01-27T12:00:00",
            headers={
                "auth": self.token,
            },
        )

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIn("city", response.data)
        self.assertIn("temperature", response.data)
        self.assertIn("weather_type", response.data)

        # Проверка случая, когда прогноз не найден
        response = self.client.get(
            url,
            {"city": self.city.id, "time": "2025-01-01T15:00:00"},
            headers={
                "auth": self.token,
            },
        )
        self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND)

    def test_week_view(self):
        # Проверка запроса с корректным городом и временем
        url = reverse("week")  # Замените на правильный URL
        start_date = "2025-01-01"
        response = self.client.get(
            url,
            {"city": self.city.id, "time": start_date},
            headers={
                "auth": self.token,
            },
        )

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIn("forecasts", response.data)
        self.assertEqual(len(response.data["forecasts"]), 1)

        # Проверка случая с некорректной датой
        response = self.client.get(
            url,
            {"city": self.city.id, "time": "invalid-date"},
            headers={
                "auth": self.token,
            },
        )
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    def test_today24_view(self):
        # Проверка запроса с корректными параметрами
        url = reverse("today24")  # Замените на правильный URL
        date = "2025-01-01"
        response = self.client.get(
            url,
            {"city": self.city.id, "time": f"{date}T12:00:00"},
            headers={
                "auth": self.token,
            },
        )

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIn("forecasts", response.data)
        self.assertEqual(len(response.data["forecasts"]), 1)

        # Проверка случая, когда параметр 'city' или 'date' отсутствует
        response = self.client.get(url, {"city": self.city.id})
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

        # Проверка случая, когда данных нет для указанного дня
        response = self.client.get(
            url,
            {"city": self.city.id, "time": "2025-01-02T12:00:00"},
            headers={
                "auth": self.token,
            },
        )
        self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND)
