import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hackathon_app/Widget/market_dropdown.dart';

class MarketItem extends StatelessWidget {
  final title;
  final int id;
  final desc;
  final img_url;
  final price;
  MarketItem(this.title, this.id, this.desc, this.img_url, this.price);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        Navigator.of(context).pushNamed('/mp_detail', arguments: id);
      },
      //to avoid height error we need to set childAspectRatio: 1,
      child: Hero(
        tag: id.toString(),
        child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Stack(
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.084,
                      width: double.infinity,
                      child: Image.network(
                        img_url,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    height: 74,
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
                                  title,
                                  maxLines: 1,
                                  style: GoogleFonts.sourceSansPro(
                                      fontSize: 14,
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
                            width: 95,
                            child: Text(
                              desc,
                              maxLines: 2,
                              style: GoogleFonts.sourceSansPro(
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.fade,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8)),
                    child: Container(
                      alignment: Alignment.center,
                      color: Colors.indigo,
                      width: double.infinity,
                      padding: EdgeInsets.all(3),
                      child: Text(
                        '\u{20B9}${price.toString()}',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ]),
                // Positioned(right: 5, bottom: 35, child: MarketDropDown()),
              ],
            )),
      ),
    );
  }
}
