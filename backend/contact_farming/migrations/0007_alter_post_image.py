

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('contact_farming', '0006_alter_post_upi_id'),
    ]

    operations = [
        migrations.AlterField(
            model_name='post',
            name='image',
            field=models.ImageField(upload_to='static/images/posts/'),
        ),
    ]
