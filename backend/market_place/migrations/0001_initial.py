

from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Product',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=255)),
                ('description', models.TextField()),
                ('price', models.FloatField()),
                ('photo', models.ImageField(upload_to='static/images/products')),
                ('available_stock', models.IntegerField()),
                ('address', models.TextField(max_length=1000)),
                ('contact_number', models.CharField(max_length=15)),
                ('type', models.CharField(choices=[('S', 'Seed'), ('F', 'Fertilizer'), ('P', 'Pesticide'), ('E', 'Equipment'), ('O', 'Other')], max_length=1)),
                ('created_at', models.DateTimeField(auto_now_add=True)),
                ('updated_at', models.DateTimeField(auto_now=True)),
            ],
        ),
    ]
