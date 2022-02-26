import datetime

from django.contrib.auth import authenticate as django_authenticate
from django.contrib.auth.models import AbstractUser
from django.db import models
from django.http import HttpRequest
from django.utils.timezone import utc
from rest_framework.authtoken.models import Token


class User(AbstractUser):
    username = models.CharField(max_length=100, unique=False, null=False)
    email = models.EmailField(unique=True, null=False)

    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = ['username']

    @staticmethod
    def authenticate_user(request: HttpRequest, email, password):
        user: User = django_authenticate(request=request, email=email, password=password)
        if user is None:
            return None

        return user

    def get_token_key(self) -> str:
        token = self.get_token()
        return token.key

    def get_token(self) -> Token:
        token, created = Token.objects.get_or_create(user=self)
        if not created:
            token.created = datetime.datetime.utcnow().replace(tzinfo=utc)
            token.save()

        return token
