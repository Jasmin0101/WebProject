import json
from datetime import datetime

from django.core.paginator import EmptyPage, PageNotAnInteger, Paginator
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
    ApplicationStatus,
    FileApplicationAttachments,
    InfoApplicationAttachments,
    TextApplicationAttachments,
    User,
    UserStatus,
)

ITEMS_PER_PAGE = 10


@require_login
@require_http_methods(["GET"])
def view_application_admin(request: HttpRequest, user: User) -> HttpResponse:

    status = request.GET.get("status")
    page = request.GET.get("page")

    all_applications = Application.objects.all().order_by("date_created")
    page = int(page)

    if user.status != UserStatus.ADMIN:
        return HttpResponseNotAllowed()

    if not page:
        return HttpResponseBadRequest("Page parameter is required")

    if page < 1:
        return HttpResponseBadRequest("Page parameter must be greater than 0")

    if status:
        all_applications = all_applications.filter(status=status)

    paginator = Paginator(all_applications, ITEMS_PER_PAGE)

    try:
        current_page = paginator.page(page)
    except PageNotAnInteger:
        current_page = paginator.page(1)
    except EmptyPage:
        current_page = paginator.page(paginator.num_pages)

    return JsonResponse(
        {
            "applications": [
                {
                    "id": application.id,
                    "date_created": application.date_created,
                    "status": application.status,
                    "title": application.title,
                    "author": application.author.id,
                }
                for application in current_page
            ],
            "is_last_page": not current_page.has_next(),
        },
    )
