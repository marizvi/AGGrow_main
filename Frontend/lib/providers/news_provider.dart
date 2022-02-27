import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewsProvider with ChangeNotifier {
  String? _token;
  String? title;
  String? content;
  var len;
  var newsMap;
  var breakingNews;
  NewsProvider(this._token);
  Future<void> fetchAndUpdate() async {
    final url = Uri.parse('http://itsrandom.cf/api/v1/news/?page_size=100');
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Token $_token',
      },
    );
    // print(json.decode(response.body));
    final extractedData = json.decode(response.body);
    newsMap = extractedData['results'];
    Iterable list = extractedData['results'];
    // newsMap = list.map((e) => e).toList();
    len = list.length;
    print('printing news $len');
    // print(newsMap);
    notifyListeners();
  }

  Future<void> fetchBreaking() async {
    try {
      final url = Uri.parse('http://itsrandom.cf/api/v1/breaking-news/');
      final response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Token $_token',
        },
      );
      print('in breaking news');
      print(response.statusCode);
      if (response.statusCode >= 400) throw "404 error";
      // print(json.decode(response.body));
      final extractedData = json.decode(response.body);
      // print(extractedData);
      breakingNews = extractedData;
      // print(newsMap);
    } catch (error) {
      print(error);
    }
  }
}
