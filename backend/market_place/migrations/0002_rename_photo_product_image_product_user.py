

from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
        ('market_place', '0001_initial'),
    ]

    operations = [
        migrations.RenameField(
            model_name='product',
            old_name='photo',
            new_name='image',
        ),
        migrations.AddField(
            model_name='product',
            name='user',
            field=models.ForeignKey(default='', on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL),
            preserve_default=False,
        ),
    ]
