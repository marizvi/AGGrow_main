

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('auth_p', '0001_initial'),
    ]

    operations = [
        migrations.AddField(
            model_name='user',
            name='last_accessed',
            field=models.DateTimeField(auto_now=True),
        ),
    ]
