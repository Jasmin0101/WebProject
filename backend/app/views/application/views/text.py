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
def add_text_attachment(request: HttpRequest, user: User) -> HttpResponse:

    data = json.loads(request.body)

    application_id = data.get("application_id")
    text = data.get("text")

    if not application_id:
        return HttpResponseBadRequest("APPLICATION_ID_REQUIRED")

    if not text:
        return HttpResponseBadRequest("TEXT_REQUIRED")

    application = Application.objects.get(id=application_id)

    if application == None:
        return HttpResponseBadRequest("APPLICATION_NOT_FOUND")

    if application.author != user:
        return HttpResponseNotAllowed("ACCESS_DENIED")

    text_attachment = TextApplicationAttachments(
        author=user,
        application=application,
        text=text,
        number_in_order=application.total_attachments + 1,
    )

    application.total_attachments += 1

    application.save()
    text_attachment.save()

    return JsonResponse({"id": text_attachment.id}, status=200)
