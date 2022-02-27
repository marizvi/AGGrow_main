import 'package:flutter/material.dart';
import 'package:hackathon_app/Widget/contact_grid.dart';
import 'package:hackathon_app/providers/contract_provider.dart';
import 'package:provider/provider.dart';

import 'loaders/loading_screen.dart';

class AllContract extends StatefulWidget {
  final _showOnlyMine;
  AllContract(this._showOnlyMine);
  @override
  _AllContractState createState() => _AllContractState();
}

class _AllContractState extends State<AllContract> {
  String urlSection = '?my=false';
  List<dynamic> _temp = [];
  Future<void> _fetchAndUpdate(BuildContext context) async {
    final contract_provider =
        Provider.of<ContactProvider>(context, listen: false);
    if (widget._showOnlyMine) {
      contract_provider.isMe = true;
      print('inside only mine');
      urlSection = '?my=true';
    } else {
      contract_provider.isMe = false;
      urlSection = '?my=false';
    }
    await contract_provider.fetchAndUpdate(urlSection);
    // _temp = contract_provider.temp.toList();
    // print(_temp);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _fetchAndUpdate(context),
        builder: (ctx, snapShot) =>
            snapShot.connectionState == ConnectionState.waiting
                ? LoadingScreen()
                : RefreshIndicator(
                    onRefresh: () => _fetchAndUpdate(ctx),
                    child: Consumer<ContactProvider>(builder: (ctx, objec, _) {
                      return ContactGrid(objec.temp, objec.isMe);
                    }),
                  ));
  }
}
