import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CFDetailItem extends StatefulWidget {
  final String title;
  final months;
  final price;
  CFDetailItem(this.title, this.months, this.price);
  @override
  State<CFDetailItem> createState() => _CFDetailItemState();
}

class _CFDetailItemState extends State<CFDetailItem> {
  Widget listViewWidget(String key, String value, Icon icon) {
    return Container(
      height: 30,
      child: ListTile(
        leading: icon,
        title: Text(
          key,
        ),
        trailing: Text(
          value,
        ),
      ),
    );
  }

  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Column(
        children: [
          ListTile(
            title: Text(
              widget.title,
              style: GoogleFonts.alef(fontWeight: FontWeight.bold),
            ),
            trailing: IconButton(
              icon: Icon(
                _expanded ? Icons.expand_less_sharp : Icons.expand_more_sharp,
              ),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 230),
            height: _expanded ? 110.0 : 0,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  listViewWidget("Expexted Duration", widget.months.toString(),
                      Icon(Icons.timelapse_sharp)),
                  listViewWidget(
                    "Cost",
                    widget.price.toString(),
                    Icon(Icons.timeline_rounded),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
