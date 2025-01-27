from django.urls import include, path
from django.views.generic import TemplateView

import app.views.city as city
import app.views.parser as parser
import app.views.user as user
from app.views import _forecast, auth
from app.views.application.urls import application_patterns
from app.views.forecast.today import today
from app.views.forecast.today24 import today24
from app.views.forecast.week import week

urlpatterns = [
    path(
        "swagger/",
        TemplateView.as_view(template_name="swagger.html"),
        name="swagger-ui",
    ),
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
        "user/me/edit",
        user.me_edit,
        name="user_me_view",
    ),
    path(
        "status",
        user.status,
        name="status",
    ),
    path(
        "cities/view",
        city.cites_view,
        name="cities_view",
    ),
    path(
        "forecast/today",
        today,
        name="today",
    ),
    path(
        "forecast/week",
        week,
        name="week",
    ),
    path(
        "forecast/today24",
        today24,
        name="today24",
    ),
    path(
        "parser/start",
        parser.parser_start,
        name="parser_start",
    ),
    path(
        "randomizer/start",
        parser.randomizer_start,
        name="randomizer_start",
    ),
    path(
        "application/",
        include(application_patterns),
    ),
]
