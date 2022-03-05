

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('contact_farming', '0003_cropsupported_price_post_contact_number_and_more'),
    ]

    operations = [
        migrations.AlterField(
            model_name='image',
            name='image',
            field=models.ImageField(upload_to='static/images/'),
        ),
        migrations.AlterField(
            model_name='post',
            name='image',
            field=models.FileField(upload_to='static/images/'),
        ),
    ]
