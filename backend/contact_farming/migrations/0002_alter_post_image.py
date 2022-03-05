

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('contact_farming', '0001_initial'),
    ]

    operations = [
        migrations.AlterField(
            model_name='post',
            name='image',
            field=models.ImageField(upload_to='images/'),
        ),
    ]
