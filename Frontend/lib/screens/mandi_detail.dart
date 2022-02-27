import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hackathon_app/Widget/loaders/loading_screen.dart';
import 'package:hackathon_app/Widget/mandi_items.dart';
import 'package:hackathon_app/providers/mandi_prices.dart';
import 'package:provider/provider.dart';

class MandiDetail extends StatelessWidget {
  final List<Color> _color = [
    Colors.pink,
    Colors.orange,
    Colors.blue,
    Colors.brown,
    Colors.purple,
    Colors.green,
    Colors.red,
    Colors.cyan,
    Colors.amber.shade700,
    Colors.indigo,
    Colors.teal,
    Colors.deepOrange,
    Colors.lightBlue,
    Colors.pink,
    Colors.purple,
    Colors.green,
    Colors.red,
    Colors.cyan,
    Colors.amber.shade700,
    Colors.indigo,
    Colors.deepOrange,
    Colors.lightBlue,
  ];
  @override
  Widget build(BuildContext context) {
    final mandi = Provider.of<MandiPrices>(context);
    final routeArgs =
        ModalRoute.of(context)?.settings.arguments as Map<String, String>;
    String state_name = routeArgs['state'] as String;
    int ind = int.parse(routeArgs['index'].toString());

    Future<void> getData() async {
      await Provider.of<MandiPrices>(context).getDetails(state_name);
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: _color[ind],
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          state_name,
          style: GoogleFonts.antic(fontSize: 19, fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder(
          future: getData(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return LoadingScreen();
            else
              return SingleChildScrollView(
                physics: ScrollPhysics(),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 12, bottom: 8),
                      child: Text('Realtime Mandi Prices'),
                    ),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: EdgeInsets.all(8),
                      itemCount: mandi.len,
                      itemBuilder: (context, index) => MandiItems(
                          mandi.temp[index]['commodity'],
                          mandi.temp[index]['created_at'],
                          mandi.temp[index]['apmc'],
                          mandi.temp[index]['commodity_arrivals'].toString(),
                          mandi.temp[index]['commodity_traded'].toString(),
                          mandi.temp[index]['max_price'].toString(),
                          mandi.temp[index]['min_price'].toString(),
                          _color[ind]),
                    ),
                  ],
                ),
              );
          }),
    );
  }
}
