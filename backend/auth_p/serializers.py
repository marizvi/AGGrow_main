from datetime import datetime
from typing import Union, Tuple, TypedDict, Optional, Dict

from django.conf import settings
from django.utils import timezone
from rest_framework import serializers
from rest_framework.authtoken.models import Token

from auth_p.models import User

EXPIRE_HOURS = getattr(settings, 'REST_FRAMEWORK_TOKEN_EXPIRE_HOURS', 24 * 30)


class UserSerializer(serializers.ModelSerializer):
    class Meta:
        fields = ('id', 'username', 'email', 'password', 'pk')
        read_only_fields = ('pk',)
        extra_kwargs = {
            'password': {'write_only': True}
        }
        model = User

    def create(self, validated_data) -> (User, str):
        user: User = User.objects.create_user(
            username=validated_data['username'],
            email=validated_data['email']
        )
        user.set_password(validated_data['password'])
        user.save()
        return user


class LoginSerializer(serializers.Serializer):
    email = serializers.EmailField(max_length=100)
    password = serializers.CharField(max_length=100)

    def authenticate(self, request) -> Union[Tuple[User, str], Tuple[None, None]]:
        username = self.validated_data['email']
        password = self.validated_data['password']
        user = User.authenticate_user(request=request, email=username, password=password)
        if user:
            return user, user.get_token_key()
        return None, None


class TypedErrorDict(TypedDict):
    error_message: str
    error_data: Optional[Dict]


class ErrorSerializer(serializers.Serializer):
    error_message = serializers.CharField(max_length=100)
    error_data = serializers.JSONField(default=None)


class SendTokenSerializer(serializers.ModelSerializer):
    expire_at: int = serializers.SerializerMethodField()
    pk: int = serializers.SerializerMethodField()

    def get_pk(self, obj) -> int:
        obj: Token
        return obj.user.pk

    def get_expire_at(self, obj) -> datetime:
        obj: Token
        return obj.created + timezone.timedelta(hours=EXPIRE_HOURS)

    class Meta:
        model = Token
        fields = ('key', 'expire_at', 'pk')
        read_only_fields = ('key', 'expire_at', 'pk')
