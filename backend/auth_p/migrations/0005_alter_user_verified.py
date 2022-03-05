

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('auth_p', '0004_alter_verificationhash_hash_and_more'),
    ]

    operations = [
        migrations.AlterField(
            model_name='user',
            name='verified',
            field=models.BooleanField(default=True),
        ),
    ]
