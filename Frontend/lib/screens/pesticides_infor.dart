import 'package:flutter/material.dart';

class PesticidesInfo extends StatelessWidget {
  const PesticidesInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
        title: Text('Pesticides Info'),
      ),
      body: Center(
        child: Text('Pesticides info'),
      ),
    );
  }
}
