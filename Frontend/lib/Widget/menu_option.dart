import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MenuOption extends StatelessWidget {
  final url;
  final title;
  final route;
  MenuOption(this.url, this.title, this.route);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(route);
      },
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    url as String,
                  ),
                  fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.only(top: 4, right: 4),
              width: 130,
              height: 25,
              color: Colors.black54,
              child: Text(
                title,
                textAlign: TextAlign.right,
                style: GoogleFonts.alatsi(color: Colors.white, fontSize: 15),
              ),
            ),
          )
        ],
      ),
    );
  }
}
