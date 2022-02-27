

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('market_place', '0004_query_title'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='product',
            name='available_stock',
        ),
        migrations.AddField(
            model_name='product',
            name='upi_id',
            field=models.CharField(blank=True, max_length=100, null=True),
        ),
    ]
