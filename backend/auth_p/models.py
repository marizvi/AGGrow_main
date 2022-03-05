import datetime

from django.contrib.auth import authenticate as django_authenticate
from django.contrib.auth.models import AbstractUser
from django.db import models
from django.dispatch import receiver
from django.http import HttpRequest
from django.utils.crypto import get_random_string
from django.utils.timezone import utc
from rest_framework.authtoken.models import Token

from auth_p.utils import send_registration_verification_mail

DEF_TOKEN_EXPIRATION = datetime.timedelta(hours=1)


class User(AbstractUser):
    username = models.CharField(max_length=100, unique=False, null=False)
    email = models.EmailField(unique=True, null=False)
    verified = models.BooleanField(default=True)
    last_accessed = models.DateTimeField(auto_now=True)

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

    def __str__(self):
        return self.username


VERIFICATION_HASH_TYPES = (
    ('R', 'registerVerification'),
    ('P', 'passwordResetVerification'),
)


def generate_hash() -> str:
    _hash = get_random_string(length=50)
    while True:
        if not VerificationHash.objects.filter(hash=_hash).exists():
            break
        _hash = get_random_string(length=50)
    return _hash


def createVerificationHashValidUntil():
    return datetime.datetime.utcnow().replace(tzinfo=utc) + DEF_TOKEN_EXPIRATION


class VerificationHash(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    hash = models.CharField(max_length=100, unique=True, default=generate_hash)
    created = models.DateTimeField(auto_now_add=True)
    valid_until = models.DateTimeField(default=createVerificationHashValidUntil)
    type = models.CharField(max_length=1, choices=VERIFICATION_HASH_TYPES)

    def __str__(self):
        return f'{self.user}:{self.hash[10:]}'


# @receiver(models.signals.post_save, sender=User)
def user_post_save(sender, instance, created, **kwargs):
    if created:
        send_registration_verification_mail(instance, VerificationHash.objects.create(user=instance, type='R').hash,
                                            threaded=True)
