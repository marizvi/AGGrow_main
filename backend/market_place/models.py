from django.core.exceptions import ObjectDoesNotExist
from django.db import models

PRODUCT_TYPES = (
    ('S', 'Seed'),
    ('F', 'Fertilizer'),
    ('P', 'Pesticide'),
    ('E', 'Equipment'),
    ('O', 'Other'),
)


class Product(models.Model):
    name = models.CharField(max_length=255)
    description = models.TextField()
    price = models.FloatField()
    image = models.ImageField(upload_to='static/images/products')
    address = models.TextField(max_length=1000)
    contact_number = models.CharField(max_length=15)
    type = models.CharField(max_length=1, choices=PRODUCT_TYPES)
    user = models.ForeignKey('auth_p.User', on_delete=models.CASCADE)
    upi_id = models.CharField(max_length=100, null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.name


class Query(models.Model):
    title = models.CharField(max_length=255)
    question = models.TextField()
    user = models.ForeignKey('auth_p.User', on_delete=models.CASCADE)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def get_answer(self):
        try:
            return self.answer
        except ObjectDoesNotExist:
            return None

    def solved(self):
        return hasattr(self, 'answer')

    def __str__(self):
        return self.title


class Answer(models.Model):
    query = models.OneToOneField(Query, on_delete=models.CASCADE)
    answer = models.TextField()
    user = models.ForeignKey('auth_p.User', on_delete=models.CASCADE)

    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.answer
