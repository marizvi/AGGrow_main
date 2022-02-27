import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hackathon_app/Widget/image_input.dart';
import 'package:hackathon_app/Widget/location_input.dart';
import 'package:hackathon_app/Widget/new_crop.dart';
import 'dart:io' as Io;
import 'package:hackathon_app/models/place.dart';
import 'package:geocoding/geocoding.dart';
import 'package:hackathon_app/providers/contract_provider.dart';
import 'package:provider/provider.dart';
import 'package:slider_button/slider_button.dart';
// import 'package:geocode/geocode.dart';

class AddPlace extends StatefulWidget {
  @override
  State<AddPlace> createState() => _AddPlaceState();
}

class _AddPlaceState extends State<AddPlace> {
  List<Map<String, dynamic>> _crops = [];
  Map<String, Object>? editElement;
  void _addCrops(String cropname, double price, String duration) {
    // _crops.clear();
    _crops.add({
      'name': cropname,
      'months_to_harvest': duration,
      'price': price.toString(),
    });
    setState(() {
      print(_crops.length);
    });
  }

  void startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return NewCrop(_addCrops);
        });
  }

  File? _pickedImage;
  PlaceLocation? _placeLocation;
  String address = '';
  final _locationController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _title;
  String? _desc;
  int? landArea;
  String? _phno;
  String? _upi;

  void _selectImage(File pickedImage) {
    this._pickedImage = pickedImage;
  }

  void _selectLocation(double lat, double lang) async {
    //..
    _placeLocation = PlaceLocation(latitude: lat, longitude: lang);

    //this section is from my side
    //finding address from coordinates
    List<Placemark> placemarks = await placemarkFromCoordinates(
        double.parse(lat.toString()), double.parse(lang.toString()));
    address = placemarks.first.street.toString() +
        " " +
        placemarks.first.subAdministrativeArea.toString() +
        ", " +
        placemarks.first.administrativeArea.toString();
    // print('heleofnvl');
    setState(() {
      _locationController.text = address;
    });
  }

  bool _isLoading = false;

  void _updatePlace(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    FocusScope.of(context).unfocus();
    final isValid = _formKey.currentState!.validate();
    if (_pickedImage == null && editElement == null) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please Pick an Image.'),
        backgroundColor: Theme.of(context).errorColor,
      ));
      return;
    }
    if (!isValid)
      setState(() {
        _isLoading = false;
      });
    if (isValid) {
      var image = editElement!['image'] ?? '';
      bool _isISO = false;
      if (_pickedImage != null) {
        _isISO = true;
        final bytes = await Io.File(_pickedImage!.path).readAsBytes();
        String img64 = base64.encode(bytes);
        image = img64;
      }
      _formKey.currentState!.save();
      //trim() is use to remove leading and trailing white spaces
      final request = await Provider.of<ContactProvider>(context, listen: false)
          .updatePlace(
              editElement!['id'].toString(),
              _title.toString(),
              _desc.toString(),
              _phno.toString(),
              address.toString(),
              image.toString(),
              landArea as int,
              _upi as String,
              _crops,
              _isISO);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Updated Successsfully",
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.green,
      ));
      Navigator.of(context).pop();
    }
  }

  void _savePlace(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    FocusScope.of(context).unfocus(); //will close the keyboard
    final isValid = _formKey.currentState!.validate();
    // print("picked image: $_pickedImage");
    if (_pickedImage == null) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please Pick an Image.'),
        backgroundColor: Theme.of(context).errorColor,
      ));
      return;
    }
    if (_placeLocation == null) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Kindly Chose Location'),
        backgroundColor: Theme.of(context).errorColor,
      ));
      return;
    }
    if (_crops.length == 0) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Insert At least one crop'),
        backgroundColor: Theme.of(context).errorColor,
      ));
      return;
    }
    if (!isValid)
      setState(() {
        _isLoading = false;
      });
    if (isValid) {
      _formKey.currentState!.save();
      //trim() is use to remove leading and trailing white spaces
      final request = await Provider.of<ContactProvider>(context, listen: false)
          .addPlace(_title as String, _desc as String, _phno as String, address,
              _pickedImage as File, landArea as int, _upi as String, _crops);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Added Successfully",
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.green,
      ));
      Navigator.of(context).pop();
    }
  }

  // var isInit = true;
  void didChangeDependencies() {
    final landId = ModalRoute.of(context)?.settings.arguments;
    if (landId != null) {
      editElement = Provider.of<ContactProvider>(context, listen: false)
          .findById(int.parse(landId.toString()));
      Iterable list = editElement!['crop_supported'] as List<dynamic>;
      _crops = list
          .map((e) => {
                'name': e['name'],
                'months_to_harvest': e['months_to_harvest'],
                'price': double.parse(e['price'].toString()),
              })
          .toList();
      address = editElement!['address'].toString();
      // print(list);
    }
    print('did change dependencies');
    // print(editElement);
    // isInit = true;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    int index = 1;
    return Scaffold(
      appBar: AppBar(
          elevation: 0.8,
          centerTitle: true,
          title: Text('Add Screen'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            initialValue: editElement != null
                                ? editElement!['title'].toString()
                                : '',
                            decoration: InputDecoration(
                              labelText: 'Title',
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Title cannot be empty.';
                              }
                              return null; //means everything is alright
                            },
                            onSaved: (value) {
                              _title = value;
                            },
                          ),
                          TextFormField(
                            initialValue: editElement != null
                                ? editElement!['content'].toString()
                                : '',
                            decoration: InputDecoration(
                              labelText: 'Description',
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Description cannot be empty.';
                              }
                              return null; //means everything is alright
                            },
                            onSaved: (value) {
                              _desc = value;
                            },
                          ),
                          TextFormField(
                            initialValue: editElement != null
                                ? editElement!['land_area'].toString()
                                : '',
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Land Area(hectares)',
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Land Area cannot be empty';
                              }
                              return null; //means everything is alright
                            },
                            onSaved: (value) {
                              landArea = double.parse(value as String).toInt();
                            },
                          ),
                          TextFormField(
                            initialValue: editElement != null
                                ? editElement!['contact_number'].toString()
                                : '',
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Phone Number here',
                            ),
                            validator: (value) {
                              if (value!.length < 10) {
                                return 'phone number contains at least 10 digits';
                              }
                              return null; //means everything is alright
                            },
                            onSaved: (value) {
                              _phno = value;
                            },
                          ),
                          TextFormField(
                            initialValue: editElement != null
                                ? editElement!['upi_id'].toString()
                                : '',
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'UPI ID here.',
                            ),
                            onSaved: (value) {
                              _upi = value;
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ImageInput(
                              _selectImage,
                              editElement != null
                                  ? editElement!['image'].toString()
                                  : ''),
                        ],
                      ),
                    ),
                    if (_crops.length > 0)
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'Crop_name',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Expected months',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Price demand',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    Column(
                      children: [
                        for (int i = 0; i < _crops.length; i++)
                          Container(
                            padding: EdgeInsets.all(6),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  _crops[i]['name'] as String,
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  _crops[i]['months_to_harvest'].toString(),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  _crops[i]['price'].toString(),
                                  textAlign: TextAlign.right,
                                ),
                              ],
                            ),
                          )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.indigo),
                      onPressed: () {
                        startAddNewTransaction(context);
                        setState(() {});
                      },
                      child: Text('Add Crops'),
                    ),
                    LocationInput(_selectLocation),
                    Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Colors.indigo[100],
                            border: Border.all(width: 1),
                            borderRadius: BorderRadius.circular(10)),
                        width: (_placeLocation == null && editElement == null)
                            ? 0
                            : 250,
                        child: Text(
                          address,
                          style: TextStyle(color: Colors.black),
                          textAlign: TextAlign.center,
                        ))
                  ],
                ),
              ),
            ),
          ),
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : ElevatedButton.icon(
                  onPressed: () => editElement == null
                      ? _savePlace(context)
                      : _updatePlace(context),
                  icon: Icon(Icons.save),
                  label: editElement != null ? Text('Update') : Text('Save'),
                  style: ElevatedButton.styleFrom(
                      //to remove extra margins
                      primary: Colors.indigo,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                ),
        ],
      ),
    );
  }
}
