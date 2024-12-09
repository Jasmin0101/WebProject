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
@require_http_methods(["POST"])
def login(request):
    data = json.loads(request.body)
    login = data.get("login")
    password = data.get("password")

    # Проверка наличия email и пароля
    if not login or not password:
        return HttpResponseBadRequest("Login and password are required.")

    try:
        # Ищем пользователя по email
        user = User.objects.get(login=login)
    except User.DoesNotExist:
        return HttpResponseBadRequest("User not found.")

    # Проверяем пароль
    if not check_password(password, user.password):
        return HttpResponseBadRequest("Invalid password.")

    refresh = RefreshToken.for_user(user)

    # Возвращаем успешный ответ
    return JsonResponse(
        {
            "message": "Login successful.",
            "access_token": str(refresh.access_token),
        }
    )


@csrf_exempt
@require_http_methods(["POST"])
def registration(request):
    data = json.loads(request.body)
    # Получение данных из запроса
    login = data.get("login")
    email = data.get("email")
    name = data.get("name")
    surname = data.get("surname")
    city_id = data.get("city")
    dob = data.get("dob")
    password = data.get("password")

    print([login, email, name, surname, city_id, dob, password])

    # Проверка наличия всех обязательных полей
    if not all([login, email, name, surname, city_id, dob, password]):
        return HttpResponseBadRequest("Not all required fields are provided.")

    # Проверка уникальности логина
    if User.objects.filter(login=login).exists():
        return HttpResponseBadRequest("This login is already taken.")

    if not City.objects.filter(id=city_id).exists():
        return HttpResponseBadRequest("This city is not exists.")

    # Проверка уникальности email
    if User.objects.filter(email=email).exists():
        return HttpResponseBadRequest("This email is already taken.")

    user = User.objects.create(
        login=login,
        email=email,
        name=name,
        surname=surname,
        city_id=city_id,
        dob=dob,
        password=make_password(password),  # Хэширование пароля
    )
    refresh = RefreshToken.for_user(user)
    return JsonResponse(
        {
            "message": "Registration successful.",
            "access_token": str(refresh.access_token),
        },
    )
