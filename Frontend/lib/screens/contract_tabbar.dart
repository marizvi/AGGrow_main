import 'package:flutter/material.dart';
import 'package:hackathon_app/Widget/all_contract.dart';
import 'package:hackathon_app/Widget/mine_contrat.dart';
import 'package:hackathon_app/providers/contract_provider.dart';
import 'package:provider/provider.dart';

class ContractTab extends StatefulWidget {
  @override
  _ContractTebState createState() => _ContractTebState();
}

class _ContractTebState extends State<ContractTab> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.8,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          centerTitle: true,
          title: Text('Contract Farming'),
          // titleSpacing: 50
          bottom: TabBar(
            indicatorColor: Colors.black,
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(width: 3.0, color: Colors.black),
              insets: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
            ),
            labelColor: Colors.black,
            padding: EdgeInsets.all(0),
            tabs: [
              Tab(
                icon: Icon(
                  Icons.all_inclusive_outlined,
                  size: 25,
                ),
                text: 'All',
                // height: 2,
              ),
              Tab(
                icon: Icon(Icons.cloud_upload),
                text: 'My Uploads',
              )
            ],
          ),
        ),
        body: Consumer(builder: (context, obj, _) {
          return TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [AllContract(false), MineContract(true)],
          );
        }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/add_place').then((value) {
              // setState(() {});
            });
          },
          splashColor: Colors.red,
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
