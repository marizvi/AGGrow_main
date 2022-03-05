from rest_framework import serializers

from .models import News


class GetLatestMandiGetSerializer(serializers.Serializer):
    state = serializers.CharField(max_length=100, required=False)


class SendLatestMandiSerializer(serializers.Serializer):
    commodity_uom = serializers.CharField(max_length=100, required=True)
    apmc = serializers.CharField(max_length=100, required=True)
    commodity = serializers.CharField(max_length=100, required=True)
    commodity_arrivals = serializers.IntegerField(required=True)
    commodity_traded = serializers.IntegerField(required=True)
    created_at = serializers.DateTimeField(required=True)
    id = serializers.IntegerField(required=True)
    max_price = serializers.IntegerField(required=True)
    min_price = serializers.IntegerField(required=True)
    modal_price = serializers.IntegerField(required=True)
    state = serializers.CharField(max_length=100, required=True)
    status = serializers.IntegerField(required=True)


class NewsSerializer(serializers.ModelSerializer):
    class Meta:
        model = News
        fields = '__all__'
