

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('scrap_data', '0005_alter_news_image_alter_news_title_alter_news_url'),
    ]

    operations = [
        migrations.AddField(
            model_name='news',
            name='breaking',
            field=models.BooleanField(default=False),
        ),
    ]
