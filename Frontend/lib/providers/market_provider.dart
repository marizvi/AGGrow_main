import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:io' as Io;

class MarketProvider with ChangeNotifier {
  String? _token;
  Iterable? list;
  Map<String, Object>? item_detail;

  var len;
  // var temp;
  MarketProvider(this._token, this.list);
  Future<void> fetchAndUpdate(String urlSection) async {
    print('type: $urlSection');
    final url =
        Uri.parse('http://itsrandom.cf/api/v1/product-list/?type=$urlSection');
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Token $_token',
      },
    );
    final extractedData =
        json.decode(response.body)['results'] as List<dynamic>;
    print(json.decode(response.body));
    Iterable list2 = extractedData;
    len = list2.length;
    list = list2;
    print(list);

    notifyListeners();
  }

  Future<void> addPlace(String title, String desc, String ph, String address,
      File image, String? upi, String type, String price) async {
    var selectType = 'O';
    if (type == 'Seed') selectType = 'S';
    if (type == 'Fertilizer') selectType = 'F';
    if (type == 'Pesticide') selectType = 'P';
    if (type == 'Equipment') selectType = 'E';
    if (type == 'Others') selectType = 'O';
    final bytes = await Io.File(image.path).readAsBytes();
    String img64 = base64.encode(bytes);
    print("inside market provider");
    print(type);
    final url = Uri.parse('https://itsrandom.cf/api/v1/product/');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Token $_token',
        },
        body: json.encode({
          'name': title,
          'description': desc,
          'address': address,
          'image': img64,
          'type': selectType,
          'contact_number': ph,
          'price': price,
          'upi_id': upi == null ? '' : upi
        }));
    print(response.statusCode);
    print(json.decode(response.body));
  }

  Map<String, Object>? findById(int id) {
    final templist = list!.map((e) => e).toList();
    // print(templist[0]['title']);
    return templist.firstWhere((element) => element['id'] == id);
  }

  Future<void> getItemDetails(int id) async {
    item_detail = findById(id);
    // print("item details");
    // print(item_detail);
  }
}
