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
    UserStatus,
)

ITEM_PER_PAGE = 10


@require_login
@require_http_methods(["GET"])
def view_application_page(request: HttpRequest, user: User) -> HttpResponse:

    page = request.GET.get("page", 1)
    application_id = request.GET.get("application_id")

    page = int(page)

    if page < 1:
        return HttpResponseBadRequest("PAGE_NUMBER_INVALID")

    if not application_id:
        return HttpResponseBadRequest("APPLICATION_ID_REQUIRED")

    application = Application.objects.get(id=application_id)

    if application == None:
        return HttpResponseBadRequest("APPLICATION_NOT_FOUND")

    if user.status != UserStatus.ADMIN and application.author != user:
        return HttpResponseNotAllowed("ACCESS_DENIED")

    text_attachments = TextApplicationAttachments.objects.filter(
        application=application_id
    ).order_by("number_in_order")

    info_attachments = InfoApplicationAttachments.objects.filter(
        application=application_id
    ).order_by("number_in_order")

    file_attachments = FileApplicationAttachments.objects.filter(
        application=application_id
    ).order_by("number_in_order")

    order = list(text_attachments) + list(info_attachments) + list(file_attachments)

    all_attachemnts = sorted(order, key=lambda x: x.number_in_order)

    page_attachnemts = all_attachemnts[::-1][
        (page - 1) * ITEM_PER_PAGE : page * ITEM_PER_PAGE
    ]

    return JsonResponse(
        {
            "items": list(map(lambda x: x.toDTO(), page_attachnemts)),
            "is_last_page": page * ITEM_PER_PAGE >= len(all_attachemnts),
        },
        status=200,
    )
