import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hackathon_app/Widget/loaders/loading_screen.dart';
import 'package:hackathon_app/providers/market_provider.dart';
import 'package:provider/provider.dart';

class ProductDetail extends StatelessWidget {
  Map<String, dynamic>? item_detail;
  String? imgUrl;
  String selectType = 'O';
  var _crops = [];
  Future<void> _getItemDetail(BuildContext context, int id) async {
    final pro = Provider.of<MarketProvider>(context, listen: false);
    await pro.getItemDetails(id);
    item_detail = pro.item_detail;
    // print(item_detail);
    imgUrl = pro.item_detail!['image'] as String;
    // selectType = 'O';
    if (pro.item_detail!['type'] == 'S') selectType = 'Seed';
    if (pro.item_detail!['type'] == 'F') selectType = 'Fertilizer';
    if (pro.item_detail!['type'] == 'P') selectType = 'Pesticide';
    if (pro.item_detail!['type'] == 'E') selectType = 'Equipment';
    if (pro.item_detail!['type'] == 'O') selectType = 'Others';
    // _crops = pro.item_detail!['crop_supported'];
    // item_detail.forEach()
    // print(item_detail!['crop_supported']);

    // print(item_detail);
  }

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)?.settings.arguments;
    return Scaffold(
        body: FutureBuilder(
            future: _getItemDetail(context, int.parse(id.toString())),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return LoadingScreen();
              else {
                return CustomScrollView(slivers: [
                  SliverAppBar(
                    backgroundColor: Colors.teal,
                    elevation: 0.5,
                    // shadowColor: Colors.teal,
                    // foregroundColor: Colors.black,
                    expandedHeight: 300,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                        title: Container(
                            width: 130,
                            height: 30,
                            child: Text(
                              'Details',
                              style: TextStyle(color: Colors.white),
                            )),
                        background: ClipRRect(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12)),
                          child: Hero(
                            tag: id.toString(),
                            child: Container(
                              height: 400,
                              width: 400,
                              child: Image.network(
                                imgUrl as String,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ), //this is to be displayed when expanded
                        )),
                  ),
                  SliverList(
                      delegate: SliverChildListDelegate([
                    Container(
                      // color: Colors.indigo,
                      padding: EdgeInsets.all(8),
                      child: Text(
                        item_detail!['name'],
                        textAlign: TextAlign.center,
                        style: GoogleFonts.sourceSansPro(
                            fontSize: 26, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 8),
                      child: Text('Type: ',
                          style: GoogleFonts.sourceSansPro(
                              fontSize: 19, fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        '$selectType',
                        style: GoogleFonts.sourceSansPro(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        item_detail!['description'],
                        style: GoogleFonts.sourceSansPro(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          'Price: \u{20B9}${item_detail!['price'].toString()}',
                          style: GoogleFonts.sourceSansPro(
                              fontSize: 19, fontWeight: FontWeight.bold)),
                    ),
                    Divider(
                      thickness: 1,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.all(8),
                      width: 100,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Contact Number: ',
                                style: GoogleFonts.sourceSansPro(
                                    fontSize: 19, fontWeight: FontWeight.bold)),
                            Text('${item_detail!['contact_number']}',
                                style: GoogleFonts.sourceSansPro(fontSize: 17)),
                            SizedBox(
                              height: 8,
                            ),
                            if (!item_detail!['upi_id'].toString().isEmpty)
                              Text('UPI id: ',
                                  style: GoogleFonts.sourceSansPro(
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold)),
                            Text('${item_detail!['upi_id']}',
                                style: GoogleFonts.sourceSansPro(fontSize: 17)),
                            SizedBox(
                              height: 8,
                            ),
                            Text('Address: ',
                                style: GoogleFonts.sourceSansPro(
                                    fontSize: 19, fontWeight: FontWeight.bold)),
                            Text('${item_detail!['address']}',
                                // textAlign: TextAlign.center,
                                style: GoogleFonts.sourceSansPro(fontSize: 17)),
                          ]),
                    ),
                    SizedBox(
                      height: 160,
                    ),
                  ]))
                ]);
              }
            }));
  }
}
