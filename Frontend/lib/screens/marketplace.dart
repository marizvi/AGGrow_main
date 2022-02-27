import 'package:dropdown_button2/custom_dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_app/Widget/loaders/loading_screen.dart';
import 'package:hackathon_app/Widget/market_grid.dart';
import 'package:hackathon_app/providers/market_provider.dart';
import 'package:provider/provider.dart';

class MarketPlace extends StatefulWidget {
  @override
  State<MarketPlace> createState() => _MarketPlaceState();
}

class _MarketPlaceState extends State<MarketPlace> {
  String? selectedValue = 'All';
  void filter(String type) {
    setState(() {});
    selectedValue = type;
  }

  String urlSection = '';

  List<dynamic> _temp = [];

  Future<void> _fetchAndUpdate(BuildContext context) async {
    if (selectedValue == 'All') urlSection = '';
    if (selectedValue == 'Others') urlSection = 'O';
    if (selectedValue == 'Fertilizer') urlSection = 'F';
    if (selectedValue == 'Pesticide') urlSection = 'P';
    if (selectedValue == 'Equipment') urlSection = 'E';
    if (selectedValue == 'Seed') urlSection = 'S';
    print(selectedValue);
    final market_provider = Provider.of<MarketProvider>(context, listen: false);
    await market_provider.fetchAndUpdate(urlSection);
    _temp = market_provider.list!.toList();
    // print(_temp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
        title: Text('Marketplace.'),
      ),
      body: FutureBuilder(
          future: _fetchAndUpdate(context),
          builder: (ctx, snapShot) {
            if (snapShot.connectionState == ConnectionState.waiting)
              return LoadingScreen();
            else
              return MarketGrid(_temp, filter, selectedValue);
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/add_market').then((value) {
            setState(() {});
          });
        },
        splashColor: Colors.white,
        child: Icon(Icons.add),
      ),
    );
  }
}
