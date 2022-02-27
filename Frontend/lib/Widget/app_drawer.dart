import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/auth.dart';

class AppDrawer extends StatelessWidget {
  final userName;
  final userEmail;
  AppDrawer(this.userName, this.userEmail);
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "Hello!",
                    style: GoogleFonts.antic(fontSize: 17),
                  ),
                ),
                Column(
                  children: [
                    Text(
                      userName ?? '',
                      style: GoogleFonts.antic(fontSize: 18),
                    ),
                    Text(
                      userEmail ?? '',
                      style: GoogleFonts.antic(fontSize: 10),
                    ),
                  ],
                ),
                Icon(
                  Icons.account_circle_outlined,
                  size: 40,
                )
              ],
            ),
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
          Divider(), // will add nice horizontal line
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home', style: TextStyle(color: Colors.black)),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          ListTile(
            leading: Icon(Icons.contact_mail),
            title:
                Text('Contract Farming', style: TextStyle(color: Colors.black)),
            onTap: () {
              Navigator.of(context).pushNamed('/contract_tab');
              ;
            },
          ),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text(
              'Mandi Prices',
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {
              Navigator.of(context).pushNamed('/mandi_prices');
              // Navigator.of(context).pushReplacement(
              // CustomRoute(builder: (ctx) => OrdersScreen()));
            },
          ),
          // Divider(), // will add nice horizontal line
          ListTile(
            leading: Icon(Icons.shop),
            title: Text(
              'Market Place',
              style: TextStyle(color: Colors.black),
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () {
              Navigator.of(context).pushNamed('/marketplace');
              ;
            },
          ),
          // Divider(), // will add nice horizontal line
          ListTile(
            leading: Icon(Icons.policy),
            title: Text('Gov. Policies', style: TextStyle(color: Colors.black)),
            onTap: () {
              // Navigator.of(context).pop();
              Navigator.of(context).pushNamed('/gov_policies'); //not necessary
              // Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
