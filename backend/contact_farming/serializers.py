from drf_extra_fields.fields import Base64ImageField
from rest_framework import serializers

from auth_p.models import User
from auth_p.serializers import UserSerializer
from contact_farming.models import Post, CropSupported


class CropSupportedSerializer(serializers.ModelSerializer):
    class Meta:
        model = CropSupported
        fields = ['name', 'months_to_harvest', 'price']


class IdSerializer(serializers.Serializer):
    id = serializers.IntegerField()


class MySerializer(serializers.Serializer):
    my = serializers.BooleanField(default=False)


class PostSerializer(serializers.ModelSerializer):
    crop_supported = CropSupportedSerializer(many=True, source='cropsupported_set')
    image = Base64ImageField(required=True)
    user = UserSerializer(read_only=True)

    class Meta:
        model = Post
        fields = ['title', 'content', 'created_at', 'updated_at', 'user', 'address', 'image',
                  'crop_supported', 'land_area', 'contact_number', 'upi_id', 'id']
        extra_kwargs = {
            'user': {'read_only': True},
        }

    def save(self, user: 'User', **kwargs):
        return super().save(user=user, **kwargs)

    def create(self, validated_data):
        crop_supported_data = validated_data.pop('cropsupported_set')
        _post = Post.objects.create(**validated_data)
        for crop_supported in crop_supported_data:
            CropSupported.objects.create(post=_post, **crop_supported)
        return _post

    def update(self, instance, validated_data):
        try:
            validated_data.pop('user')
        except KeyError:
            pass
        try:
            crop_supported_data = validated_data.pop('cropsupported_set')
        except KeyError:
            crop_supported_data = []
        super().update(instance, validated_data)
        for crop_supported in crop_supported_data:
            CropSupported.objects.update_or_create(post=instance, **crop_supported)
        return instance
