import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hackathon_app/providers/mandi_prices.dart';
import 'package:provider/provider.dart';

class IndianStates extends StatelessWidget {
  Color color;
  String state;
  int? index;
  IndianStates(this.color, this.state, this.index);
  @override
  Widget build(BuildContext context) {
    final mandi = Provider.of<MandiPrices>(context, listen: false);
    return InkWell(
      // using Inkwell because it also gives ripple effect on tap :)
      onTap: () {
        Navigator.of(context).pushNamed(
          '/mandi_detail',
          arguments: {'state': state, 'index': index.toString()},
        );
      },
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Text(
          state,
          style: GoogleFonts.amaranth(fontSize: 15),
        ),
        decoration: BoxDecoration(
          // image: DecorationImage(
          //     image: AssetImage('assets/images/agri9.jpg'),
          //     fit: BoxFit.cover),
          gradient: LinearGradient(
            colors: [
              color,
              color.withOpacity(0.5),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
