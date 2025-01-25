import json
from datetime import datetime

from django.http import (
    HttpRequest,
    HttpResponse,
    HttpResponseBadRequest,
    HttpResponseNotAllowed,
    JsonResponse,
)
from django.views.decorators.http import require_http_methods

from app.decorator import require_login
from app.models import (
    Application,
    FileApplicationAttachments,
    InfoApplicationAttachments,
    TextApplicationAttachments,
    User,
)


@require_login
@require_http_methods(["POST"])
def add_file_attachemnts(request: HttpRequest, user: User) -> HttpResponse:

    return HttpResponse()
    try:
        new_file = FileApplicationAttachments(file=request.FILES["file"])
        new_file.save()
        return redirect("success_url")

    except Exception as e:
        return HttpResponseBadRequest("FILE_UPLOAD_ERROR")
