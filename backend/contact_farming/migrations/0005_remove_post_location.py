

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('contact_farming', '0004_alter_image_image_alter_post_image'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='post',
            name='location',
        ),
    ]
