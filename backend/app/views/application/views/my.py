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
def view_application_my(request: HttpRequest, user: User) -> HttpResponse:

    active = request.GET.get("active")
    page = request.GET.get("page")
    all_applications = Application.objects.filter(author=user).order_by("date_created")

    active = active == "true"
    page = int(page)
    if not page:
        return HttpResponseBadRequest("Page parameter is required")

    if page < 1:
        return HttpResponseBadRequest("Page parameter must be greater than 0")

    if active:
        # Filter to show only non-completed applications
        all_applications = all_applications.exclude(status=ApplicationStatus.COMPLETED)
    else:
        # Show all applications
        all_applications = all_applications.filter(status=ApplicationStatus.COMPLETED)

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


@require_login
@require_http_methods(["GET"])
def view_application(request: HttpRequest, user: User) -> HttpResponse:

    application_id = request.GET.get("application_id")

    if not application_id:
        return HttpResponseBadRequest("APPLICATION_ID_REQUIRED")

    application = Application.objects.get(id=application_id)

    if application == None:
        return HttpResponseBadRequest("APPLICATION_NOT_FOUND")

    if user.status != UserStatus.ADMIN and application.author != user:
        return HttpResponseNotAllowed("ACCESS_DENIED")

    return JsonResponse(
        {
            "id": application.id,
            "date_created": application.date_created,
            "status": application.status,
            "title": application.title,
            "author": application.author.id,
            "total_attachments": application.total_attachments,
        },
    )
