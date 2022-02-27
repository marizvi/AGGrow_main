

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('scrap_data', '0004_alter_news_image'),
    ]

    operations = [
        migrations.AlterField(
            model_name='news',
            name='image',
            field=models.URLField(max_length=1000),
        ),
        migrations.AlterField(
            model_name='news',
            name='title',
            field=models.CharField(max_length=255),
        ),
        migrations.AlterField(
            model_name='news',
            name='url',
            field=models.CharField(max_length=500, unique=True),
        ),
    ]
