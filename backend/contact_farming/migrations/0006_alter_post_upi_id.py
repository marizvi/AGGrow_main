

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('contact_farming', '0005_remove_post_location'),
    ]

    operations = [
        migrations.AlterField(
            model_name='post',
            name='upi_id',
            field=models.CharField(blank=True, max_length=100, null=True),
        ),
    ]
