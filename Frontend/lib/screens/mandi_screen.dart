import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hackathon_app/Widget/indian_states.dart';
import 'package:provider/provider.dart';
import '../providers/mandi_prices.dart';

class MandiScreen extends StatefulWidget {
  @override
  _MandiScreenState createState() => _MandiScreenState();
}

class _MandiScreenState extends State<MandiScreen> {
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
    final mandi = Provider.of<MandiPrices>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          centerTitle: true,
          title: Text(
            'Mandi Prices',
            style: GoogleFonts.antic(fontSize: 23),
          ),
        ),
        body: GridView.builder(
          padding: EdgeInsets.all(8),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 4 / 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10),
          itemCount: 21,
          itemBuilder: (ctx, index) => IndianStates(_color[index],
              mandi.states[index]['state_name'] as String, index),
        ));
  }
}
