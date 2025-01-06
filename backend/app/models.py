from django.db import models
from django.contrib.auth.hashers import make_password


class City(models.Model):
    city = models.CharField(max_length=200, null=True)
    city_en = models.CharField(max_length=200)
    id = models.BigAutoField(primary_key=True)


class User(models.Model):
    # Поле id является первичным ключом, и в Django оно создаётся автоматически.
    id = models.BigAutoField(primary_key=True)

    # Поле для хэшированного пароля
    password = models.CharField(max_length=255, null=True)

    # date of birth
    dob = models.DateField(null=True)

    # Поле для имени пользователя с ограничением длины
    login = models.CharField(max_length=180, null=True)
    name = models.CharField(max_length=255, null=True)
    surname = models.CharField(max_length=255, null=True)
    city = models.ForeignKey(City, on_delete=models.CASCADE, related_name="cities")
    email = models.EmailField(max_length=255)

    def __str__(self):
        return self.login or "Unnamed User"


class Application(models.Model):

    STATUS_CHOICE = {
        "SEND": "Отправленно",
        "READ": "Прочитано",
        "RECEIVED": "Получено",
        "REJECTED": "Отклонено",
    }

    status = models.CharField(
        max_length=30,
        choices=STATUS_CHOICE,
        default="SEND",
    )

    id = models.BigAutoField(primary_key=True)
    title = models.CharField(max_length=255)
    text = models.TextField()
    date_created = models.DateTimeField(auto_now_add=True)
    author = models.ForeignKey(
        User, on_delete=models.CASCADE, related_name="applications"
    )
