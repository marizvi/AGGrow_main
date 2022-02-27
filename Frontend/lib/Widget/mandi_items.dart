import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/mandi_prices.dart';
import 'dart:math';
import 'package:intl/intl.dart';

class MandiItems extends StatefulWidget {
  final String title;
  final updated_at;
  final String apmc;
  final String arrival;
  final String traded;
  final String max;
  final String min;
  Color color;

  MandiItems(this.title, this.updated_at, this.apmc, this.arrival, this.traded,
      this.max, this.min, this.color);

  @override
  State<MandiItems> createState() => _MandiItemsState();
}

class _MandiItemsState extends State<MandiItems> {
  bool _expanded = false;
  @override
  Widget listViewWidget(String key, String value, Icon icon) {
    return Container(
      height: 40,
      child: ListTile(
        leading: icon,
        title: Text(
          key,
        ),
        trailing: Text(
          value,
          style: TextStyle(color: widget.color),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    // print('hello there... $title');
    var dateString =
        DateFormat.yMMMd().format(DateTime.parse(widget.updated_at));
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
                color: widget.color,
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
            height: _expanded ? 260.0 : 0,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  listViewWidget("Updated on", dateString, Icon(Icons.update)),
                  listViewWidget(
                      "APMC", widget.apmc, Icon(Icons.shopping_bag_outlined)),
                  listViewWidget(
                    "Arrival",
                    widget.arrival,
                    Icon(Icons.download_for_offline_outlined),
                  ),
                  listViewWidget(
                      "Traded",
                      widget.traded,
                      Icon(
                        Icons.task_alt_rounded,
                      )),
                  listViewWidget(
                      "Max Price",
                      '\u{20B9} ${widget.max}',
                      Icon(
                        Icons.payments,
                      )),
                  listViewWidget(
                      "Min Price",
                      '\u{20B9} ${widget.min}',
                      Icon(
                        Icons.payments_outlined,
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
