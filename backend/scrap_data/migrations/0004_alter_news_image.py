

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('scrap_data', '0003_news'),
    ]

    operations = [
        migrations.AlterField(
            model_name='news',
            name='image',
            field=models.URLField(max_length=255),
        ),
    ]
