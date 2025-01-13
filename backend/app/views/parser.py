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
from app.utils.parser import *
from app.utils.randomizer import *
from django.views.decorators.http import require_http_methods


@csrf_exempt
@require_http_methods(["GET"])
def parser_start(request):

    parse()


@csrf_exempt
@require_http_methods(["GET"])
def randomizer_start(request):

    randomize()
