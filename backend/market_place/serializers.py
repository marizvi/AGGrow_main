from drf_extra_fields.fields import Base64ImageField
from rest_framework import serializers
from rest_framework.serializers import ModelSerializer, Serializer

from auth_p.models import User
from auth_p.serializers import UserSerializer
from .models import Product, Query, PRODUCT_TYPES


class ProductSerializer(ModelSerializer):
    image = Base64ImageField(required=True)
    user = UserSerializer(read_only=True)

    class Meta:
        model = Product
        fields = '__all__'
        ready_only_fields = ('id', 'created_at', 'updated_at')

    def save(self, user: 'User', **kwargs):
        return super().save(user=user, **kwargs)


class TypeSerializer(Serializer):
    type = serializers.ChoiceField(choices=PRODUCT_TYPES, required=False)


class QueryAnswerSerializer(ModelSerializer):
    class Meta:
        model = Query
        fields = ['answer', 'created_at', 'updated_at']
        ready_only_fields = ('id', 'created_at', 'updated_at')


class QuerySerializer(ModelSerializer):
    user = UserSerializer(read_only=True)
    answer = QueryAnswerSerializer(read_only=True, allow_null=True)

    class Meta:
        model = Query
        fields = '__all__'
        ready_only_fields = ('id', 'created_at', 'updated_at', 'answer')

    def save(self, user: 'User', **kwargs):
        return super().save(user=user, **kwargs)
