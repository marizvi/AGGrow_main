import 'package:dropdown_button2/custom_dropdown_button2.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class MarketDropDown extends StatefulWidget {
  final Function getResponse;
  MarketDropDown(this.getResponse);
  @override
  State<MarketDropDown> createState() => _MarketDropDownState();
}

enum FilterOptions {
  Edit,
  Delete,
}
List<Map<String, dynamic>> map = [
  {
    'icon': Icon(
      Icons.edit,
      color: Colors.black,
    ),
    'value': 'Edit',
  },
  {
    'icon': Icon(
      Icons.delete,
      color: Colors.red,
    ),
    'value': 'Delete',
  }
];

class _MarketDropDownState extends State<MarketDropDown> {
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      // color: Colors.black87,
      width: 50,
      height: 30,
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          dropdownElevation: 8,
          dropdownWidth: 60,
          onChanged: (value) => widget.getResponse(value),
          customButton: Icon(
            Icons.more_vert,
            size: 30,
          ),
          customItemsIndexes: [3],
          dropdownDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.white70,
          ),
          items: [
            ...map.map((item) =>
                DropdownMenuItem(value: item['value'], child: item['icon'])),
          ],
        ),
      ),
    );
  }
}
