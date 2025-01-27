import json
from datetime import datetime

from django.http import HttpRequest, HttpResponse, HttpResponseBadRequest, JsonResponse
from django.utils import timezone
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_http_methods

from app.decorator import require_login
from app.models import (
    Application,
    ApplicationStatus,
    InfoApplicationAttachments,
    User,
    UserStatus,
)


@require_login
@require_http_methods(["POST"])
@csrf_exempt
def info_req_application(request: HttpRequest, user: User) -> HttpResponse:

    data = json.loads(request.body)

    application_id = data.get("application_id")

    application = Application.objects.get(id=application_id)

    if not application:
        return HttpResponseBadRequest("APPLICATION_NOT_FOUND")

    if user.status != UserStatus.ADMIN:
        return HttpResponseBadRequest("ACCESS_DENIED")

    if application.status == ApplicationStatus.INFORMATION_REQUIRED:
        return HttpResponse(status=200)

    if application.status == ApplicationStatus.COMPLETED:
        return HttpResponseBadRequest("APPLICATION_ALREADY_COMPLETED")

    new_info_attachment = InfoApplicationAttachments(
        application=application,
        info=f"Заявка переведена в статус 'требуется информация' {timezone.make_aware(datetime.now()).strftime('%Y.%m.%d %H:%M')}",
        number_in_order=application.total_attachments + 1,
    )

    application.status = ApplicationStatus.INFORMATION_REQUIRED
    application.total_attachments += 1

    application.save()
    new_info_attachment.save()

    return HttpResponse(status=200)
