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

# ITEM_PER_PAGE = 10


@require_login
@require_http_methods(["GET"])
def view_application_my(request: HttpRequest, user: User) -> HttpResponse:

    all_applications = Application.objects.filter(author=user).order_by("date_created")

    return JsonResponse(
        {
            "applications": [
                {
                    "id": application.id,
                    "created_at": application.created_at,
                    "status": application.status,
                    "title": application.title,
                    "description": application.description,
                    "author": application.author.id,
                }
                for application in all_applications
            ]
        },
    )
