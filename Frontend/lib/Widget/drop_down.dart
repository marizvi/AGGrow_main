import 'package:flutter/material.dart';
import 'package:dropdown_button2/custom_dropdown_button2.dart';

class DropDown extends StatefulWidget {
  final Function selectType;
  DropDown(this.selectType);

  @override
  State<DropDown> createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  String? selectedValue;

  List<String> items = [
    'Seed',
    'Fertilizer',
    'Pesticide',
    'Equipment',
    'Others'
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomDropdownButton2(
        hint: 'Select Type',
        dropdownItems: items,
        value: selectedValue,
        onChanged: (value) {
          setState(() {
            widget.selectType(value);
            selectedValue = value;
          });
        },
      ),
    );
  }
}
