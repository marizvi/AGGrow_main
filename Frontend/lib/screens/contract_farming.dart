import 'package:flutter/material.dart';
import 'package:hackathon_app/Widget/contact_grid.dart';
import 'package:hackathon_app/Widget/loaders/loading_screen.dart';
import 'package:hackathon_app/providers/contract_provider.dart';
import 'package:provider/provider.dart';

enum FilterOptions {
  Mine,
  All,
}

class ContactFarming extends StatefulWidget {
  @override
  State<ContactFarming> createState() => _ContactFarmingState();
}

class _ContactFarmingState extends State<ContactFarming> {
  var _showOnlyMine = false;
  String urlSection = '?my=false';
  List<dynamic> _temp = [];
  Future<void> _fetchAndUpdate(BuildContext context) async {
    if (_showOnlyMine) {
      print('inside only mine');
      urlSection = '?my=true';
    } else {
      urlSection = '?my=false';
    }
    final contract_provider =
        Provider.of<ContactProvider>(context, listen: false);
    await contract_provider.fetchAndUpdate(urlSection);
    // _temp = contract_provider.temp.toList();
    // print(_temp);
  }

  @override
  Widget build(BuildContext context) {
    // Provider.of<ContactProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.8,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
        title: Text('Contract Farming'),
        actions: [
          PopupMenuButton(
            onSelected: (selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Mine) {
                  print(selectedValue);
                  _showOnlyMine = true;
                } else {
                  print(selectedValue);
                  _showOnlyMine = false;
                }
              });
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text("My Upload"),
                value: FilterOptions.Mine,
              ),
              PopupMenuItem(
                child: Text("Show All"),
                value: FilterOptions.All,
              )
            ],
            icon: Icon(Icons.more_vert),
          ),
        ],
      ),
      body: FutureBuilder(
          future: _fetchAndUpdate(context),
          builder: (ctx, snapShot) => snapShot.connectionState ==
                  ConnectionState.waiting
              ? LoadingScreen()
              : RefreshIndicator(
                  onRefresh: () => _fetchAndUpdate(ctx),
                  child: Consumer<ContactProvider>(builder: (ctx, objec, _) {
                    return ContactGrid(objec.temp, _showOnlyMine);
                  }),
                )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/add_place').then((value) {
            setState(() {});
          });
        },
        splashColor: Colors.red,
        child: Icon(Icons.add),
      ),
    );
  }
}
