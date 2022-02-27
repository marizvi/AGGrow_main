import 'package:flutter/material.dart';
import 'package:hackathon_app/Widget/contract_item.dart';

class ContactGrid extends StatelessWidget {
  final bool _showOnlyMine;
  final List<dynamic> element_list;
  ContactGrid(this.element_list, this._showOnlyMine);
  @override
  Widget build(BuildContext context) {
    // print(element_list[0]['image']);
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: element_list.length,
      itemBuilder: (ctx, index) => ContractItem(
          element_list[index]['title'],
          element_list[index]['id'],
          element_list[index]['content'],
          element_list[index]['image'],
          _showOnlyMine),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // amount of columns
        childAspectRatio: 1.0,
        crossAxisSpacing: 10, // spacing between columns
        mainAxisSpacing: 10,
      ),
    );
  }
}
