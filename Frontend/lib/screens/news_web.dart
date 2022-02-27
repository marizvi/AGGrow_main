import 'package:flutter/material.dart';
import 'package:web_browser/web_browser.dart';

class NewsWeb extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final website_url = ModalRoute.of(context)?.settings.arguments;
    return Scaffold(
      appBar: AppBar(
          elevation: 0.8,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          centerTitle: true,
          title: Text('News')),
      body: SafeArea(
        child: WebBrowser(
          initialUrl: '$website_url',
          javascriptEnabled: true,
        ),
      ),
    );
  }
}
