from django.urls import path


from app.views import auth, forecast
import app.views.user as user
import app.views.application as application
import app.views.city as city
import app.views.parser as parser

urlpatterns = [
    path(
        "login",
        auth.login,
        name="login",
    ),
    path(
        "registration",
        auth.registration,
        name="registration",
    ),
    path(
        "checkPassword",
        auth.checkPassword,
        name="currentPassword",
    ),
    path(
        "user/me/view",
        user.me_view,
        name="user_me_view",
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
    path(
        "forecast/today/",
        forecast.today,
        name="today",
    ),
    path(
        "forecast/week/",
        forecast.week,
        name="week",
    ),
    path(
        "forecast/today24/",
        forecast.today24,
        name="today24",
    ),
    path(
        "parser/start/",
        parser.parser_start,
        name="parser_start",
    ),
    path(
        "randomizer/start/",
        parser.randomizer_start,
        name="randomizer_start",
    ),
]
