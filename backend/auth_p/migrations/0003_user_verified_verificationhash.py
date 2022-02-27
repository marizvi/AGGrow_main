

import datetime
from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('auth_p', '0002_user_last_accessed'),
    ]

    operations = [
        migrations.AddField(
            model_name='user',
            name='verified',
            field=models.BooleanField(default=False),
        ),
        migrations.CreateModel(
            name='VerificationHash',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('hash', models.CharField(default='', max_length=100, unique=True)),
                ('created', models.DateTimeField(auto_now_add=True)),
                ('valid_until', models.DateTimeField(default=datetime.datetime(2022, 3, 10, 0, 00, 00, 000000))),
                ('type', models.CharField(choices=[('R', 'registerVerification'), ('P', 'passwordResetVerification')], max_length=1)),
                ('user', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL)),
            ],
        ),
    ]
