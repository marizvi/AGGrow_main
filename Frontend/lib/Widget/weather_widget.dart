import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hackathon_app/providers/weather_pro.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:weather_icons/weather_icons.dart';

class WeatherWidget extends StatefulWidget {
  final address;
  WeatherWidget(this.address);

  @override
  State<WeatherWidget> createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  @override
  Widget build(BuildContext context) {
    final weather = Provider.of<ProWeather>(context);
    Map<String, BoxedIcon> icons = {
      '01d': BoxedIcon(
        WeatherIcons.day_cloudy_high,
        color: Colors.orange[300],
        size: 45,
      ),
      '01n': BoxedIcon(
        WeatherIcons.night_clear,
        color: Colors.blueGrey[600],
        size: 45,
      ),
      '02d': BoxedIcon(
        WeatherIcons.day_cloudy_gusts,
        color: Colors.orange[300],
        size: 45,
      ),
      '02n': BoxedIcon(
        WeatherIcons.night_cloudy_gusts,
        color: Colors.blueGrey[600],
        size: 45,
      ),
      '03d': BoxedIcon(
        WeatherIcons.day_cloudy_high,
        color: Colors.orange[300],
        size: 45,
      ),
      '03n': BoxedIcon(
        WeatherIcons.night_cloudy_high,
        color: Colors.blueGrey[600],
        size: 45,
      ),
      '04d': BoxedIcon(
        WeatherIcons.day_cloudy_windy,
        color: Colors.orange[300],
        size: 45,
      ),
      '04n': BoxedIcon(
        WeatherIcons.night_cloudy_windy,
        color: Colors.blueGrey[600],
        size: 45,
      ),
      '09d': BoxedIcon(
        WeatherIcons.day_showers,
        color: Colors.orange[300],
        size: 45,
      ),
      '09n': BoxedIcon(
        WeatherIcons.night_showers,
        color: Colors.blueGrey[600],
        size: 45,
      ),
      '10d': BoxedIcon(
        WeatherIcons.day_rain,
        color: Colors.orange[300],
        size: 45,
      ),
      '10n': BoxedIcon(
        WeatherIcons.night_rain,
        color: Colors.blueGrey[600],
        size: 45,
      ),
      '11d': BoxedIcon(
        WeatherIcons.day_thunderstorm,
        color: Colors.orange[300],
        size: 45,
      ),
      '11n': BoxedIcon(
        WeatherIcons.night_thunderstorm,
        color: Colors.blueGrey[600],
        size: 45,
      ),
      '13d': BoxedIcon(
        WeatherIcons.night_thunderstorm,
        color: Colors.orange[300],
        size: 45,
      ),
      '13n': BoxedIcon(
        WeatherIcons.night_thunderstorm,
        color: Colors.blueGrey[600],
        size: 45,
      ),
      '50d': BoxedIcon(
        WeatherIcons.day_haze,
        color: Colors.orange[300],
        size: 45,
      ),
      '50n': BoxedIcon(
        WeatherIcons.day_haze,
        color: Colors.blueGrey[600],
        size: 45,
      ),
    };
    // print('hello');
    // print(weather.current);
    // Future<void> getPermission() async {
    //   await Permission.location.request();
    //   // Either the permission was already granted before or the user just granted it.
    // }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          // decoration: BoxDecoration(color: Colors.grey),
          width: MediaQuery.of(context).size.width * 0.938,
          child: Card(
            // color: Colors.grey[600],
            elevation: 3,
            child: ListTile(
              trailing: weather.current != null
                  ? Text(
                      '${weather.current != null ? '${weather.temp()}\u2103' : ''}',
                      style: TextStyle(fontSize: 30),
                    )
                  : TextButton(
                      child: Text('turn on permission'),
                      onPressed: () async {
                        await openAppSettings();
                        setState(() {});
                      },
                    ),
              leading: icons['${weather.current_condition['icon']}'],
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    weather.current_condition['main'] ?? '',
                    // textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.07 + 1,
                  ),
                  Expanded(
                    child: Text(
                      widget.address,
                      style:
                          TextStyle(fontSize: 11, overflow: TextOverflow.fade),
                    ),
                  ),
                ],
              ),
              subtitle: weather.current != null
                  ? Text(
                      'Humidity: '
                      '${weather.current['humidity'].toString()}%',
                      style: TextStyle(fontSize: 12),
                    )
                  : Text(
                      'Location Permission Denied!',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.dmSans(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
