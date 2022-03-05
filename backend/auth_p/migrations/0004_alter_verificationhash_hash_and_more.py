

import auth_p.models
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('auth_p', '0003_user_verified_verificationhash'),
    ]

    operations = [
        migrations.AlterField(
            model_name='verificationhash',
            name='hash',
            field=models.CharField(default=auth_p.models.generate_hash, max_length=100, unique=True),
        ),
        migrations.AlterField(
            model_name='verificationhash',
            name='valid_until',
            field=models.DateTimeField(default=auth_p.models.createVerificationHashValidUntil),
        ),
    ]
