

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('scrap_data', '0002_alter_latestmandi_added_on'),
    ]

    operations = [
        migrations.CreateModel(
            name='News',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('added_on', models.DateTimeField(auto_now_add=True)),
                ('title', models.CharField(max_length=100)),
                ('url', models.CharField(max_length=255, unique=True)),
                ('image', models.ImageField(upload_to='static/images/news/')),
                ('created_at', models.DateTimeField()),
            ],
        ),
    ]
