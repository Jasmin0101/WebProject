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
def cites_view(request):

    try:
        cities = City.objects.all()

    except Exception as e:
        return HttpResponseBadRequest("Not all required fields are provided.")

    data = list(cities.values())
    return JsonResponse(data, safe=False)
