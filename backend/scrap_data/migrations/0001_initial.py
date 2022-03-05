

from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='LatestMandi',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('added_on', models.DateTimeField()),
                ('commodity_uom', models.CharField(max_length=100)),
                ('apmc', models.CharField(max_length=100)),
                ('commodity', models.CharField(max_length=100)),
                ('commodity_arrivals', models.IntegerField()),
                ('commodity_traded', models.IntegerField()),
                ('created_at', models.DateTimeField()),
                ('pid', models.IntegerField()),
                ('max_price', models.IntegerField()),
                ('min_price', models.IntegerField()),
                ('modal_price', models.IntegerField()),
                ('state', models.CharField(max_length=100)),
                ('status', models.IntegerField()),
            ],
        ),
    ]
