import 'package:flutter/material.dart';
import 'package:hackathon_app/Widget/carousel.dart';
import 'package:hackathon_app/Widget/loaders/loading_screen.dart';
import 'package:hackathon_app/Widget/menu_grid.dart';
import 'package:hackathon_app/Widget/weather_widget.dart';
import 'package:hackathon_app/providers/weather_pro.dart';
import 'package:location/location.dart' as Location;
import 'package:provider/provider.dart';
import 'package:alan_voice/alan_voice.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geocoding/geocoding.dart';
import '../providers/auth.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  _MainScreenState() {}
  final List _source = [
    'https://akm-img-a-in.tosshub.com/indiatoday/images/story/202012/Paddy_farmer_Srinagar__PTI__1200x768.jpeg?4N03oyPg6DcnxAdDolBsoxrAjihgadPX&size=770:433',
    'https://thelogicalindian.com/h-upload/2020/08/09/178976-farmerweb.jpg',
    'https://gumlet.assettype.com/newslaundry/2021-07/26690e5e-0241-4ad9-a5b9-0fb45da44db6/agricluture.jpg?w=1200&h=675',
    'https://tfipost.com/wp-content/uploads/2019/02/Modifarmers.jpg',
    'https://images.indianexpress.com/2018/01/indian-farmer.jpg',
  ];

  String? lat;

  String? lon;

  String address = '';

  Future<void> _getLocation(BuildContext context) async {
    // setState(() {});
    // print('printing..');
    final locData = await Location.Location().getLocation();
    // print('${locData.latitude}, ${locData.longitude}');
    await Provider.of<ProWeather>(context, listen: false).getCurrentTemperature(
        locData.latitude.toString(), locData.longitude.toString());
    lat = locData.latitude.toString();
    lon = locData.longitude.toString();
    // var addresses = await Geocoder.local.findAddressesFromCoordinates(locData);
    // print('adressing...');
    List<Placemark> placemarks = await placemarkFromCoordinates(
        double.parse(lat as String), double.parse(lon as String));
    address = placemarks.first.subAdministrativeArea.toString();
    // print('address is: ${placemarks.first.toString()}');
  }

  // Future<void> _getLocation(BuildContext context) async {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);
    final weather = Provider.of<ProWeather>(context, listen: false);
    return Scaffold(
      body: FutureBuilder(
          future: Future.value(_getLocation(context)),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return LoadingScreen();
            else
              return RefreshIndicator(
                onRefresh: () => Future.value(_getLocation(context)),
                child: Consumer<ProWeather>(builder: (context, proweath, _) {
                  return Column(
                    children: [
                      Flexible(
                        flex: 1,
                        child: Carousel(_source),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      WeatherWidget(address),
                      SizedBox(
                        height: 4,
                      ),
                      Flexible(
                        flex: 2,
                        child: MenuGrid(),
                      ),
                    ],
                  );
                }),
              );
          }),
    );
  }
}
