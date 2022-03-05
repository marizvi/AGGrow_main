

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('contact_farming', '0002_alter_post_image'),
    ]

    operations = [
        migrations.AddField(
            model_name='cropsupported',
            name='price',
            field=models.FloatField(default=0),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='post',
            name='contact_number',
            field=models.CharField(default=0, max_length=15),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='post',
            name='land_area',
            field=models.FloatField(default=0),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='post',
            name='upi_id',
            field=models.CharField(default=0, max_length=100),
            preserve_default=False,
        ),
        migrations.AlterField(
            model_name='post',
            name='image',
            field=models.FileField(upload_to='images/'),
        ),
    ]
