from django.urls import path

from app.views.application.views.create import create_application
from app.views.application.views.my import view_application_my
from app.views.application.views.page import view_application_page

application_patterns = [
    path(
        "create/",
        create_application,
        name="create_application",
    ),
    path(
        "view/page/",
        view_application_page,
        name="view_application_page",
    ),
    path(
        "view/my/",
        view_application_my,
        name="view_application_my",
    ),
]
