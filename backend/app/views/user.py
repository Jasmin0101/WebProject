import json

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
@require_login  # декоратор ( если забыла посмотри реализацию )
def me_view(request: HttpRequest, user: User) -> HttpResponse:
    try:
        city_data = City.objects.get(id=user.city_id)
        city_name = city_data.city
    except Exception as e:
        city_name = None
        print(f"Error fetching city data: {e}")

    return JsonResponse(
        {
            "name": user.name,
            "surname": user.surname,
            "city": city_name,
            "dob": user.dob,
            "email": user.email,
            "login": user.login,
            "city_id": user.city_id,
        }
    )


@csrf_exempt
@require_http_methods(["POST"])
@require_login
def me_edit(request: HttpRequest, user: User) -> HttpResponse:
    data = json.loads(request.body)

    name = data.get("name")
    surname = data.get("surname")
    city = data.get("city")
    dob = data.get("dob")

    if not name or not surname or not city or not dob:
        return JsonResponse(
            {"error": "All fields (name, surname, city, dob) are required."},
            status=400,
        )

    city = City.objects.get(id=int(city))

    user.name = name
    user.surname = surname
    user.city = city
    user.dob = dob
    user.save()
    return JsonResponse({"message": "User data updated successfully."})


@csrf_exempt
@require_http_methods(["GET"])
def status(request):
    try:
        # Получаем ID текущего пользователя из токена
        user_id = request.user.id

        user_count = User.objects.all().count()

        return JsonResponse(
            {"Status": "Ok", "Total_Users": str(user_count), "User_ID": user_id}
        )
    except Exception as e:
        return JsonResponse(
            {"Status": "Bad", "error": str(e)},
        )
