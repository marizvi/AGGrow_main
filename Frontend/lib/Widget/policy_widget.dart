// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PolicyWidget extends StatelessWidget {
  final title;
  final id;
  final url;
  PolicyWidget(this.title, this.id, this.url);
  @override
  Widget build(BuildContext context) {
    print(url);
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed('/policy_detail', arguments: id);
      },
      child: Container(
        padding: EdgeInsets.all(8),
        height: 230,
        child: Card(
            elevation: 3,
            child: Stack(
              children: [
                Container(
                    height: 200,
                    width: double.infinity,
                    // padding: EdgeInsets.all(4),
                    child: Image.network(
                      url.toString(),
                      fit: BoxFit.cover,
                    )),
                Positioned(
                    bottom: 0,
                    height: 80,
                    width: MediaQuery.of(context).size.width * 0.94,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                        // color: Colors.black54,
                        child: Center(
                          child: Text(title,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.merriweather(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    )),
              ],
            )),
      ),
    );
  }
}
