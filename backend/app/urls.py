from django.urls import path


import app.views.user as user
import app.views.application as application
import app.views.city as city

urlpatterns = [
    path(
        "login",
        user.login,
        name="login",
    ),
    path(
        "registration",
        user.registration,
        name="registration",
    ),
    path(
        "status",
        user.status,
        name="status",
    ),
    path(
        "application/create",
        application.application_create,
        name="create_application",
    ),
    path(
        "application/view/",
        application.application_view,
        name="view_application ",
    ),
    path(
        "application/my/view",
        application.my_application_view,
        name="my_application_view",
    ),
    path(
        "application/my/edit",
        application.my_application_edit,
        name="my_application_edit",
    ),
    path(
        "cities/view/",
        city.cites_view,
        name="cities_view",
    ),
]
