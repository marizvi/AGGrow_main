import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:io' as Io;
import 'dart:io';
import 'dart:async';
import 'dart:convert';

class ContactProvider with ChangeNotifier {
  bool isMe = false;
  final _token;
  var len;
  List temp = [];
  // List<dynamic> elemnets;
  ContactProvider(this._token, this.temp);
  Map<String, Object>? item_detail;
  Future<void> addPlace(
      String title,
      String desc,
      String ph,
      String address,
      File image,
      int land_area,
      String? upi,
      List<Map<String, dynamic>> _crops) async {
    final bytes = await Io.File(image.path).readAsBytes();
    String img64 = base64.encode(bytes);
    // print(img64);
    // print(_crops);
    print("inside contact provider");
    // print(_token);
    // print(_crops.map((e) => e['name']).toList());
    final url = Uri.parse('https://itsrandom.cf/api/v1/contact-farming/');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Token $_token',
        },
        body: json.encode({
          'title': title,
          'content': desc,
          'address': address,
          'image': img64,
          'crop_supported': _crops
              .map((e) => {
                    'name': e['name'],
                    'months_to_harvest': e['months_to_harvest'],
                    'price': double.parse(e['price'].toString()),
                  })
              .toList(),
          'land_area': land_area,
          'contact_number': ph,
          'upi_id': upi == null ? '' : upi
        }));
    // print(response.body);
    temp.insert(0, json.decode(response.body));
    print(json.decode(response.body));
    notifyListeners();
  }

  Map<String, Object>? findById(int id) {
    // print(templist[0]['title']);
    return temp.firstWhere((element) => element['id'] == id);
  }

  Future<void> fetchAndUpdate(String urlSection) async {
    final url = Uri.parse(
        'http://itsrandom.cf/api/v1/contact-farming-posts/$urlSection');
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Token $_token',
      },
    );
    final extractedData =
        json.decode(response.body)['results'] as List<dynamic>;
    // print(extractedData);
    Iterable list = extractedData;
    len = list.length;
    temp = list.map((e) => e).toList();
    print('fecthed');
    notifyListeners();
  }

  Future<void> getItemDetails(int id) async {
    item_detail = findById(id);
    // print("item details");
    // print(item_detail);
  }

  Future<void> deleteElem(int id) async {
    var dele_index = temp.indexWhere((element) => element['id'] == id);
    var toDelete = temp[dele_index];
    temp.removeAt(dele_index);
    print('deleted');
    notifyListeners();
    final url =
        Uri.parse('https://itsrandom.cf/api/v1/contact-farming/?id=$id');
    final response = await http.delete(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Token $_token',
      },
    );
    print(response.statusCode);
    if (response.statusCode >= 400) {
      temp.insert(dele_index, toDelete);
      notifyListeners();
      throw HttpException('Could not delete product').toString();
    }

    // print(response);
  }

  Future<void> updatePlace(
      String id,
      String title,
      String desc,
      String ph,
      String address,
      String image,
      int land_area,
      String? upi,
      List<Map<String, dynamic>> _crops,
      bool _isISO) async {
    // print(img64);
    // print(_crops);
    print("inside contact provider");
    // print(_token);
    // print(_crops.map((e) => e['name']).toList());
    final url = Uri.parse(
        'https://itsrandom.cf/api/v1/contact-farming/?id=${int.parse(id)}');
    if (_isISO) {
      print("iso $ph");
      final response = await http.patch(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Token $_token',
          },
          body: json.encode({
            'title': title,
            'content': desc,
            'address': address,
            'image': image,
            'crop_supported': _crops
                .map((e) => {
                      'name': e['name'],
                      'months_to_harvest': e['months_to_harvest'],
                      'price': double.parse(e['price'].toString()),
                    })
                .toList(),
            'land_area': land_area,
            'contact_number': ph,
            'upi_id': upi == null ? '' : upi
          }));
      print(response.statusCode);
      print(json.decode(response.body));
      var element_index =
          temp.indexWhere((element) => element['id'] == int.parse(id));
      temp[element_index] = json.decode(response.body);
    } else {
      print("not iso $ph");
      final response = await http.patch(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Token $_token',
          },
          body: json.encode({
            'title': title,
            'content': desc,
            'address': address,
            'crop_supported': _crops
                .map((e) => {
                      'name': e['name'],
                      'months_to_harvest': e['months_to_harvest'],
                      'price': double.parse(e['price'].toString()),
                    })
                .toList(),
            'land_area': land_area,
            'contact_number': ph,
            'upi_id': upi == null ? '' : upi
          }));
      print(response.statusCode);
      print(json.decode(response.body));
      var element_index =
          temp.indexWhere((element) => element['id'] == int.parse(id));
      // print(id);
      // print(element_index);
      temp[element_index] = json.decode(response.body);
    }
    // print(response.body);
    // print(json.decode(response.body));
    notifyListeners();
  }
}
