

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('market_place', '0003_query_answer'),
    ]

    operations = [
        migrations.AddField(
            model_name='query',
            name='title',
            field=models.CharField(default='asdsada', max_length=255),
            preserve_default=False,
        ),
    ]
