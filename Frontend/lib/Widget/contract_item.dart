import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hackathon_app/Widget/market_dropdown.dart';
import 'package:hackathon_app/providers/contract_provider.dart';
import 'package:provider/provider.dart';

class ContractItem extends StatefulWidget {
  final title;
  final int id;
  final desc;
  final img_url;
  final bool _isMe;
  ContractItem(this.title, this.id, this.desc, this.img_url, this._isMe);

  @override
  State<ContractItem> createState() => _ContractItemState();
}

class _ContractItemState extends State<ContractItem> {
  @override
  Widget build(BuildContext context) {
    // print(widget.img_url);
    final contract = Provider.of<ContactProvider>(context, listen: false);
    void getResponse(String response) async {
      if (response == 'Delete') {
        try {
          await contract.deleteElem(widget.id);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              "Deleted Successsfully",
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.green,
          ));
        } catch (error) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              "Deleting Failed",
              textAlign: TextAlign.center,
            ),
            backgroundColor: Theme.of(context).errorColor,
          ));
        }
      }
      if (response == 'Edit') {
        print('edit');
        Navigator.of(context)
            .pushNamed('/add_place', arguments: widget.id)
            .then((value) {
          // setState(() {});
        });
      }
      // setState(() {
      //   print('huehuehue $response');
      // });
    }

    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        Navigator.of(context).pushNamed('/cf_detail', arguments: widget.id);
      },
      //to avoid height error we need to set childAspectRatio: 1,
      child: Hero(
        tag: widget.id.toString(),
        child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                          child: Container(
                            height: 72,
                            width: double.infinity,
                            child: Image.network(
                              widget.img_url,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          height: 71.5,
                          margin: EdgeInsets.all(6),
                          child: SingleChildScrollView(
                            // child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        widget.title,
                                        maxLines: 1,
                                        style: GoogleFonts.sourceSansPro(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Icon(
                                      Icons.star_outlined,
                                      color: Colors.amber,
                                      size: 15,
                                    ),
                                    Icon(
                                      Icons.star_outlined,
                                      color: Colors.amber,
                                      size: 15,
                                    ),
                                    Icon(
                                      Icons.star_outlined,
                                      color: Colors.amber,
                                      size: 15,
                                    ),
                                    Icon(
                                      Icons.star_half_outlined,
                                      color: Colors.amber,
                                      size: 15,
                                    ),
                                  ],
                                ),
                                Container(
                                  width: 102,
                                  child: Text(
                                    widget.desc,
                                    maxLines: 2,
                                    style: GoogleFonts.sourceSansPro(
                                      fontSize: 14,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]),
                  if (widget._isMe)
                    Positioned(
                      right: 9,
                      bottom: 15,
                      child: MarketDropDown(getResponse),
                    ),
                ],
              ),
            )),
      ),
    );
  }
}
