import json
from datetime import datetime

from django.http import (
    HttpRequest,
    HttpResponse,
    HttpResponseBadRequest,
    HttpResponseNotAllowed,
    JsonResponse,
)
from django.utils import timezone
from django.views.decorators.csrf import csrf_exempt
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


@require_login
@csrf_exempt
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

    if user.status != UserStatus.ADMIN and application.author != user:
        return HttpResponseNotAllowed("ACCESS_DENIED")

    if application.status == ApplicationStatus.COMPLETED:
        return HttpResponseBadRequest("APPLICATION_ALREADY_COMPLETED")

    if (
        user.status == UserStatus.ADMIN
        and application.status == ApplicationStatus.WAITING
    ):

        new_info_attachment = InfoApplicationAttachments(
            application=application,
            info=f"Заявка принята администратором {user.name}",
            number_in_order=application.total_attachments + 1,
        )

        application.status = ApplicationStatus.WORKING
        application.total_attachments += 1

        new_info_attachment.save()

    if (
        user == application.author
        and application.status == ApplicationStatus.INFORMATION_REQUIRED
    ):

        new_info_attachment = InfoApplicationAttachments(
            application=application,
            info=f"Информация добавлена пользователем {user.name} {timezone.make_aware(datetime.now()).strftime('%Y.%m.%d %H:%M')}",
            number_in_order=application.total_attachments + 1,
        )

        application.status = ApplicationStatus.WORKING
        application.total_attachments += 1

        new_info_attachment.save()

    text_attachment = TextApplicationAttachments(
        author=user,
        application=application,
        text=text,
        number_in_order=application.total_attachments + 1,
    )

    application.total_attachments += 1

    application.save()
    text_attachment.save()

    return JsonResponse(
        text_attachment.toDTO(),
        status=200,
    )
