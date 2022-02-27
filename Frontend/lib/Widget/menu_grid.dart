import 'package:flutter/material.dart';
import 'package:hackathon_app/Widget/menu_option.dart';

class MenuGrid extends StatelessWidget {
  final List<String> _titles = [
    'Contact Farming',
    'Mandi Prices',
    'Market Place',
    'Gov Schemes',
    'Farming Tips',
    'Pesticides info.'
  ];
  final List<String> _urls = [
    'assets/images/agri12.jpg',
    'assets/images/agri10.png',
    'assets/images/agri16.jpg',
    'assets/images/agri2.png',
    'assets/images/agri9.jpg',
    'assets/images/agri13.jpg',
  ];
  final List<String> _routes = [
    '/contract_tab',
    '/mandi_prices',
    '/marketplace',
    '/gov_policies',
    '/farming_tips',
    '/pesticides_info',
  ];
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(9),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
      itemCount: 6,
      itemBuilder: (ctx, index) =>
          MenuOption(_urls[index], _titles[index], _routes[index]),
    );
  }
}
