from django.urls import path

from app.views.application.views.admin_view import view_application_admin
from app.views.application.views.close import close_application
from app.views.application.views.create import create_application
from app.views.application.views.file import add_file_attachments, get_file_attachment
from app.views.application.views.info_req import info_req_application
from app.views.application.views.my import view_application, view_application_my
from app.views.application.views.page import view_application_page
from app.views.application.views.text import add_text_attachment

application_patterns = [
    path(
        "create",
        create_application,
        name="create_application",
    ),
    path(
        "view/page",
        view_application_page,
        name="view_application_page",
    ),
    path(
        "view/my",
        view_application_my,
        name="view_application_my",
    ),
    path(
        "view",
        view_application,
        name="view_application",
    ),
    path(
        "close",
        close_application,
        name="close_application",
    ),
    path(
        "info_req",
        info_req_application,
        name="info_req_application",
    ),
    path(
        "add/text",
        add_text_attachment,
        name="add_text_attachment",
    ),
    path(
        "<int:application_id>/add/file",
        add_file_attachments,
        name="add_file_attachment",
    ),
    path(
        "admin/view",
        view_application_admin,
        name="view_application_admin",
    ),
    path(
        "file/<int:attachment_id>",
        get_file_attachment,
        name="get_file_attachment",
    ),
]
