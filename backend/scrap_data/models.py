from datetime import datetime

import pytz
from django.db import models


class LatestMandi(models.Model):
    added_on = models.DateTimeField(auto_now_add=True)
    commodity_uom = models.CharField(max_length=100)
    apmc = models.CharField(max_length=100)
    commodity = models.CharField(max_length=100)
    commodity_arrivals = models.IntegerField()
    commodity_traded = models.IntegerField()
    created_at = models.DateTimeField()
    pid = models.IntegerField()
    max_price = models.IntegerField()
    min_price = models.IntegerField()
    modal_price = models.IntegerField()
    state = models.CharField(max_length=100)
    status = models.IntegerField()

    @staticmethod
    def save_from_raw_dict(data: dict):
        timezone = pytz.timezone('UTC')
        created_at = timezone.localize(datetime.fromisoformat(data["created_at"]))
        state = data["state"]
        pid = int(data["id"])
        if (_x := LatestMandi.objects.filter(created_at=created_at, state=state, pid=pid)).exists():
            return _x.first()

        return LatestMandi.objects.create(
            commodity_uom=data["Commodity_Uom"],
            apmc=data["apmc"],
            commodity=data["commodity"],
            commodity_arrivals=int(data["commodity_arrivals"]),
            commodity_traded=int(data["commodity_traded"]),
            created_at=created_at,
            pid=pid,
            max_price=int(data["max_price"]),
            min_price=int(data["min_price"]),
            modal_price=int(data["modal_price"]),
            state=state,
            status=int(data["status"]),
        )

    def __str__(self):
        return f"{self.commodity} - {self.state}"


class News(models.Model):
    added_on = models.DateTimeField(auto_now_add=True)
    title = models.CharField(max_length=255)
    url = models.CharField(max_length=500, unique=True)
    breaking = models.BooleanField(default=False)
    image = models.URLField(max_length=1000)
    source = models.CharField(max_length=100)
    created_at = models.DateTimeField()

    def __str__(self):
        return self.title
