

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('scrap_data', '0006_news_breaking'),
    ]

    operations = [
        migrations.AddField(
            model_name='news',
            name='source',
            field=models.CharField(default='techu news', max_length=100),
            preserve_default=False,
        ),
    ]
