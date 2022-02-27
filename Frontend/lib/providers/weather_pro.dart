import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'dart:convert';

class ProWeather with ChangeNotifier {
  final String? received_api_key;
  ProWeather(
    this.received_api_key,
  );
  double? currentTemp;
  var current;

  String temp() {
    return (currentTemp?.toStringAsPrecision(2) ?? '');
  }

  // String humid() {
  //   return (current[?.toStringAsPrecision(2) ?? '');
  // }

  Map<String, dynamic> get current_condition {
    print("mkmkmkmkmkmkmkmmk $current");
    return current != null ? current['weather'][0] : {};
  }

  void Listener() {
    notifyListeners();
  }

  Future<void> getCurrentTemperature(String lat, String lon) async {
    String api_key = received_api_key!.trim();
    print(api_key);
    // String lat = "23.14595828910444";
    // String lon = "72.63002115508168";
    // final url = Uri.parse(
    // 'https://api.openweathermap.org/data/2.5/weather?lat=23.14595828910444&lon=72.63002115508168&appid=${api_key}');
    final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lon&exclude=minutely&appid=$api_key');
    final response = await get(url);
    // print(json.decode(response.body));
    if (response.statusCode == 200) {
      String data = response.body;
      var currentWeather = jsonDecode(data);

      try {
        currentTemp = currentWeather['current']['temp'] - 273;
        current = currentWeather['current'];
        // current_main = currentWeather['current']['weather'][0];
        // print('dhgfdbfbi');
        // print(current);
        // print(currentCondition = currentWeather['weather'][0]['id']);
      } catch (e) {
        print('in catch');
        print(e);
      }
    }
    notifyListeners();
  }
}
