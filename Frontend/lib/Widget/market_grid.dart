import 'package:dropdown_button2/custom_dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hackathon_app/Widget/market_dropdown.dart';
import 'package:hackathon_app/Widget/market_item.dart';
import 'package:hackathon_app/providers/contract_provider.dart';
import 'package:provider/provider.dart';

class MarketGrid extends StatefulWidget {
  final List<dynamic> element_list;
  final Function filter;
  final current;
  MarketGrid(this.element_list, this.filter, this.current);

  @override
  State<MarketGrid> createState() => _MarketGridState();
}

class _MarketGridState extends State<MarketGrid> {
  String? selectedValue;

  List<String> items = [
    'All',
    'Seed',
    'Fertilizer',
    'Pesticide',
    'Equipment',
    'Others',
  ];

  @override
  Widget build(BuildContext context) {
    print(widget.element_list.length);
    Provider.of<ContactProvider>(context);
    return SingleChildScrollView(
      physics: ScrollPhysics(),
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Center(
            child: CustomDropdownButton2(
              hint: widget.current.toString(),
              dropdownItems: items,
              value: selectedValue,
              onChanged: (value) {
                setState(() {
                  widget.filter(value);
                  selectedValue = value;
                });
              },
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(10),
            itemCount: widget.element_list.length,
            itemBuilder: (ctx, index) => MarketItem(
              widget.element_list[index]['name'],
              widget.element_list[index]['id'],
              widget.element_list[index]['description'],
              widget.element_list[index]['image'],
              widget.element_list[index]['price'],
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // amount of columns
              childAspectRatio: 0.91,
              crossAxisSpacing: 10, // spacing between columns
              mainAxisSpacing: 10,
            ),
          ),
        ],
      ),
    );
  }
}
