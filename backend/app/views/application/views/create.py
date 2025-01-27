import json
from datetime import datetime

from django.http import HttpRequest, HttpResponse, HttpResponseBadRequest, JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_http_methods

from app.decorator import require_login
from app.models import Application, InfoApplicationAttachments, User


@require_login
@require_http_methods(["POST"])
@csrf_exempt
def create_application(request: HttpRequest, user: User) -> HttpResponse:

    data = json.loads(request.body)

    title = data.get("title")

    if not title:
        return HttpResponseBadRequest("TITLE_REQUIRED")

    application = Application(
        author=user,
        title=title,
        total_attachments=1,
    )

    new_info_attachment = InfoApplicationAttachments(
        application=application,
        info=f"Заявка создана {datetime.now().strftime('%Y.%m.%d %H:%M')}",
        number_in_order=1,
    )

    application.save()
    new_info_attachment.save()

    return JsonResponse(
        {"id": application.id},
        status=200,
    )
