from django.contrib.auth.hashers import make_password
from django.db import models


class City(models.Model):
    city = models.CharField(max_length=200, null=True)
    city_en = models.CharField(max_length=200)
    id = models.BigAutoField(primary_key=True)


class UserStatus(models.TextChoices):
    ADMIN = "AD", "Администратор"
    USER = "US", "Пользователь"


class User(models.Model):
    # Поле id является первичным ключом, и в Django оно создаётся автоматически.
    id = models.BigAutoField(primary_key=True)

    # Поле для хэшированного пароля
    password = models.CharField(max_length=255, null=True)

    # date of birth
    dob = models.DateField(null=True)

    status = models.CharField(
        max_length=2,
        choices=UserStatus.choices,
        default=UserStatus.USER,
    )

    # Поле для имени пользователя с ограничением длины
    login = models.CharField(max_length=180, null=True)
    name = models.CharField(max_length=255, null=True)
    surname = models.CharField(max_length=255, null=True)
    city = models.ForeignKey(City, on_delete=models.CASCADE, related_name="cities")
    email = models.EmailField(max_length=255)

    def __str__(self):
        return self.login or "Unnamed User"


class ApplicationStatus(models.TextChoices):
    WAITING = "WA", "Ожидает рассмотрения"
    WORKING = "WO", "В работе"
    INFORMATION_REQUIRED = "IR", "Требуется информация"
    COMPLETED = "CO", "Завершено"


class Application(models.Model):

    status = models.CharField(
        max_length=2,
        choices=ApplicationStatus.choices,
        default=ApplicationStatus.WAITING,
    )

    id = models.BigAutoField(primary_key=True)
    title = models.CharField(max_length=255)
    date_created = models.DateTimeField(auto_now_add=True)
    total_attachments = models.IntegerField(default=0)
    author = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name="applications",
    )


class TextApplicationAttachments(models.Model):

    id = models.BigAutoField(primary_key=True)
    number_in_order = models.IntegerField()
    author = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name="text_attachments",
    )
    application = models.ForeignKey(
        Application,
        on_delete=models.CASCADE,
        related_name="text_attachments",
    )
    text = models.TextField()

    def toDTO(self):
        return {
            "id": self.id,
            "type": "text",
            "author": self.author.id,
            "text": self.text,
        }


class InfoApplicationAttachments(models.Model):

    id = models.BigAutoField(primary_key=True)
    number_in_order = models.IntegerField()

    application = models.ForeignKey(
        Application,
        on_delete=models.CASCADE,
        related_name="info_attachments",
    )
    info = models.TextField()

    def toDTO(self):
        return {
            "id": self.id,
            "type": "info",
            "info": self.info,
        }


class FileApplicationAttachments(models.Model):

    id = models.BigAutoField(primary_key=True)
    number_in_order = models.IntegerField()
    author = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name="file_attachments",
    )
    application = models.ForeignKey(
        Application,
        on_delete=models.CASCADE,
        related_name="file_attachments",
    )
    file = models.FileField(
        upload_to="attachments/%Y/%m/%d",
    )

    def toDTO(self):
        return {
            "id": self.id,
            "type": "file",
            "author": self.author.id,
            "file": self.file.url,
        }


class Forecast(models.Model):

    city = models.ForeignKey(
        City, on_delete=models.CASCADE, related_name="forecast_city"
    )

    date = models.DateField(null=True)
    time = models.TimeField(null=True)

    temperature = models.FloatField(null=True)
    conditions = models.CharField(max_length=255, null=True)
    pressure = models.FloatField(null=True)
    humidity = models.FloatField(null=True)

    wind_speed = models.FloatField(null=True)
