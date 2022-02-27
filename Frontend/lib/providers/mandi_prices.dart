import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MandiPrices with ChangeNotifier {
  List<Map<String, String>>? crops;
  // List<dynamic>? crops;
  final token;
  int? len;
  var temp;
  MandiPrices(this.token);
  final List<Map<String, String>> states = [
    {"state_name": "ANDHRA PRADESH", "state_id": "276"},
    {"state_name": "CHANDIGARH", "state_id": "526"},
    {"state_name": "CHHATTISGARH", "state_id": "100", "url": ""},
    {"state_name": "GUJARAT", "state_id": "22"},
    {"state_name": "HARYANA", "state_id": "32"},
    {"state_name": "HIMACHAL PRADESH", "state_id": "43"},
    {"state_name": "JAMMU AND KASHMIR", "state_id": "696"},
    {"state_name": "JHARKHAND", "state_id": "47"},
    {"state_name": "KARNATAKA", "state_id": "695"},
    {"state_name": "KERALA", "state_id": "694"},
    {"state_name": "MADHYA PRADESH", "state_id": "20"},
    {"state_name": "MAHARASHTRA", "state_id": "296"},
    {"state_name": "ODISHA", "state_id": "384"},
    {"state_name": "PUDUCHERRY", "state_id": "599"},
    {"state_name": "PUNJAB", "state_id": "602"},
    {"state_name": "RAJASTHAN", "state_id": "26"},
    {"state_name": "TAMIL NADU", "state_id": "509"},
    {"state_name": "TELANGANA", "state_id": "28"},
    {"state_name": "UTTAR PRADESH", "state_id": "46"},
    {"state_name": "UTTARAKHAND", "state_id": "385"},
    {"state_name": "WEST BENGAL", "state_id": "569"}
  ];
  Future<void> getDetails(String state_name) async {
    print('inside get details');
    final url = Uri.parse(
        "http://itsrandom.cf/api/v1/mandi-prices/$state_name/?page=1&page_size=100");
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Token $token',
      },
    );
    final extractedData = json.decode(response.body);
    // print(extractedData['results'][0]);
    Iterable list = extractedData['results'];
    len = list.length;
    // print(len);
    // print(list.toList());
    // crops = list.toList();
    // list.forEach((element) => crops!.add(element));
    // print(list);
    temp = list.map((e) => e).toList();
    // print('printing..');
    // // crops = temp;
    // print(temp);
    // print(temp[0]['commodity']);
    // final crop = list.map((i) => jsonDecode(i)).toList();
    // print(crops!.length);
  }
}
