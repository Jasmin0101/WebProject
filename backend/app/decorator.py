from functools import wraps
from django.http import JsonResponse
from rest_framework_simplejwt.tokens import AccessToken
from app.models import *


def require_login(view_func):
    @wraps(view_func)
    def _wrapped_view(request, *args, **kwargs):

        token = request.headers.get("Auth")

        if token is None:
            return JsonResponse({"error": "Unauthorized"}, status=401)

        try:
            user = AccessToken(token)

            user_id = user.payload.get("user_id")

            if user_id is None:
                return JsonResponse({"error": "User id not found"}, status=401)

            if not User.objects.filter(id=str(user_id)).exists():
                return JsonResponse({"error": "User not found"}, status=401)

            user = User.objects.get(id=user_id)

        except Exception as e:
            return JsonResponse({"error": str(e)}, status=401)

        return view_func(request, *args, user=user, **kwargs)

    return _wrapped_view
