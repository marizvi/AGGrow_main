import 'package:flutter/material.dart';

class FarmingTips extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
        title: Text('Farming Tips.'),
      ),
      body: Center(
        child: Text('Farming Tips here'),
      ),
    );
  }
}
