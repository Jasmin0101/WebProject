import json
import mimetypes
from datetime import datetime
from io import BytesIO

from django.http import (
    FileResponse,
    Http404,
    HttpRequest,
    HttpResponse,
    HttpResponseBadRequest,
    HttpResponseForbidden,
    HttpResponseNotAllowed,
    HttpResponseServerError,
    JsonResponse,
)
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_http_methods
from PIL import Image

from app.decorator import require_login
from app.models import (
    Application,
    FileApplicationAttachments,
    InfoApplicationAttachments,
    TextApplicationAttachments,
    User,
    UserStatus,
)


@require_login
@require_http_methods(["POST"])
@csrf_exempt
def add_file_attachments(
    request: HttpRequest, user: User, application_id: int
) -> HttpResponse:

    if not application_id:
        return HttpResponseBadRequest("APPLICATION_ID_REQUIRED")

    application = Application.objects.get(id=application_id)

    if application == None:
        return HttpResponseBadRequest("APPLICATION_NOT_FOUND")

    if user.status != UserStatus.ADMIN and application.author != user:
        return HttpResponseNotAllowed("ACCESS_DENIED")

    try:
        new_file = FileApplicationAttachments(
            file=request.FILES["file"],
            number_in_order=application.total_attachments + 1,
            author=user,
            application=application,
        )

        application.total_attachments += 1

        application.save()
        new_file.save()
        return HttpResponse()

    except Exception as e:
        print(e)
        return HttpResponseBadRequest("FILE_UPLOAD_ERROR")


@require_login
@require_http_methods(["GET"])
def get_file_attachment(
    request: HttpRequest, user: User, attachment_id: int
) -> HttpResponse:
    try:
        attachment = FileApplicationAttachments.objects.get(id=attachment_id)

        # Check if user has access to this application
        if not (
            user.status == UserStatus.ADMIN or attachment.application.author == user
        ):
            return HttpResponseForbidden("Access denied")

        # Open the file
        file_handle = attachment.file.open()

        # Create response with proper content type
        response = FileResponse(file_handle, content_type="application/octet-stream")
        # response["Content-Disposition"] = (
        #     f'attachment; filename="{attachment.file.name}"'
        # )

        return response

    except FileApplicationAttachments.DoesNotExist:
        raise Http404("File attachment not found")
    except Exception as e:
        return HttpResponseServerError(str(e))
