from django.contrib.contenttypes.fields import GenericForeignKey
from django.contrib.contenttypes.models import ContentType
from django.db import models

from auth_p.models import User


class Image(models.Model):
    image = models.ImageField(upload_to='static/images/')
    owner_type = models.ForeignKey(ContentType, on_delete=models.CASCADE)
    owner_id = models.PositiveIntegerField()
    owner = GenericForeignKey("owner_type", 'owner_id')
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f'{self.image.url}?owner={self.owner}'


class Post(models.Model):
    title = models.CharField(max_length=100)
    content = models.TextField()
    land_area = models.FloatField()
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    address = models.TextField(max_length=1000)
    contact_number = models.CharField(max_length=15)
    upi_id = models.CharField(max_length=100, null=True, blank=True)
    image = models.ImageField(upload_to="static/images/posts/")

    def __str__(self):
        return self.title


class CropSupported(models.Model):
    name = models.CharField(max_length=100)
    months_to_harvest = models.IntegerField()
    price = models.FloatField()
    post = models.ForeignKey(Post, on_delete=models.CASCADE)

    def __str__(self):
        return self.name
