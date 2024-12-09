import json
from django.http import (
    HttpRequest,
    HttpResponseBadRequest,
    JsonResponse,
    HttpResponse,
)
from django.views.decorators.csrf import csrf_exempt
from app.decorator import require_login
from app.models import *

from django.views.decorators.http import require_http_methods


@csrf_exempt
@require_http_methods(["POST"])
@require_login
def application_create(request: HttpRequest, user: User) -> HttpResponse:

    data = json.loads(request.body)

    title = data.get("title")
    text = data.get("text")

    if title == None or text == None:
        return HttpResponseBadRequest("Ohh something broken :/ ")

    application = Application.objects.create(title=title, text=text, author=user)

    return JsonResponse(
        {"message": "Application successful."},
    )


@csrf_exempt
@require_http_methods(["GET"])
@require_login
def application_view(request: HttpRequest, user: User) -> HttpResponse:

    # Словарь для фильтрации по статусу
    status = request.GET.get("status", "all")  # По умолчанию "all"
    status_filter = {
        "all": None,  # Если "all", фильтр не применяется
        "send": "SEND",
        "read": "READ",
        "rejected": "REJECTED",
        "received": "RECEIVED",
    }

    if status not in status_filter:
        return JsonResponse({"error": "Invalid status"}, status=400)

    # Фильтрация по статусу
    queryset = (
        Application.objects.all()
        if status == "all"
        else Application.objects.filter(status=status_filter[status])
    )

    # Формирование данных для ответа
    data = list(queryset.values())
    return JsonResponse(data, safe=False)


@csrf_exempt
@require_http_methods(["GET"])
@require_login
def my_application_view(request: HttpRequest, user: User) -> HttpResponse:

    application = Application.objects.filter(author=user)

    data = list(application.values())
    return JsonResponse(data, safe=False)


@csrf_exempt
@require_http_methods(["POST"])
@require_login
def my_application_edit(request: HttpRequest, user: User) -> HttpResponse:
    data = json.loads(request.body)

    application_id = data.get("id")

    if application_id == None:
        return JsonResponse({"error": "Don't application"}, status=400)

    if not Application.objects.filter(id=application_id).exists():
        return JsonResponse({"error": " Application doesn't exists"}, status=400)

    application = Application.objects.get(id=application_id)

    if application.author != user:
        return JsonResponse({"error": "This is not correct user"}, status=400)

    title = data.get("title")
    text = data.get("text")

    if title == ("" or None) or text == ("" or None):
        return JsonResponse({"error": "Don't correct application"}, status=400)

    Application.objects.filter(id=application_id).update(title=title, text=text)

    return JsonResponse(
        {"message": "Application successful."},
    )
