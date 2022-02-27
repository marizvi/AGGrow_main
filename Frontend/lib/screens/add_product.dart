import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hackathon_app/Widget/drop_down.dart';
import 'package:hackathon_app/Widget/image_input.dart';
import 'package:hackathon_app/Widget/loaders/loading_screen.dart';
import 'package:hackathon_app/Widget/location_input.dart';
import 'package:hackathon_app/Widget/new_crop.dart';
import 'dart:io';
import 'package:hackathon_app/models/place.dart';
import 'package:geocoding/geocoding.dart';
import 'package:hackathon_app/providers/contract_provider.dart';
import 'package:hackathon_app/providers/market_provider.dart';
import 'package:provider/provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:slider_button/slider_button.dart';
// import 'package:geocode/geocode.dart';

class AddProduct extends StatefulWidget {
  @override
  State<AddProduct> createState() => _AddPlaceState();
}

class _AddPlaceState extends State<AddProduct> {
  List<Map<String, String>> _crops = [];
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
  String? _phno;
  String? _upi;
  String? _type;
  int? _price;

  void _selectImage(File pickedImage) {
    this._pickedImage = pickedImage;
  }

  bool _addloading = false;
  void _selectLocation(double lat, double lang) async {
    //..
    setState(() {
      _addloading = true;
      print(_addloading);
    });
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
      _addloading = false;
      _locationController.text = address;
    });
  }

  bool _isLoading = false;
  void _savePlace(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    FocusScope.of(context).unfocus(); //will close the keyboard
    final isValid = _formKey.currentState!.validate();
    // print("picked image: $_pickedImage");
    if (_type == null) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please Select the type.'),
        backgroundColor: Theme.of(context).errorColor,
      ));
      return;
    }
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

    if (!isValid)
      setState(() {
        _isLoading = false;
      });
    if (isValid) {
      _formKey.currentState!.save();
      //trim() is use to remove leading and trailing white spaces
      final request = await Provider.of<MarketProvider>(context, listen: false)
          .addPlace(
              _title as String,
              _desc as String,
              _phno as String,
              address,
              _pickedImage as File,
              _upi as String,
              _type as String,
              _price.toString());
      Navigator.of(context).pop();
    }
  }

  void selectType(String? temp) {
    _type = temp;
  }

  @override
  Widget build(BuildContext context) {
    int index = 1;
    return Scaffold(
      appBar: AppBar(
          elevation: 0.8,
          centerTitle: true,
          title: Text('Add Product'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 10,
          ),
          DropDown(selectType),
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
                            // initialValue: 'Hello',
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
                            // initialValue: 'Hello',
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
                            // initialValue: '123',
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Price',
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Price cannot be empty.';
                              }
                              return null; //means everything is alright
                            },
                            onSaved: (value) {
                              _price = int.parse(value.toString());
                            },
                          ),
                          TextFormField(
                            // initialValue: '123776768899',
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
                          ImageInput(_selectImage, ''),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    LocationInput(_selectLocation),
                    _addloading
                        ? CircularProgressIndicator()
                        : Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: Colors.indigo[100],
                                border: Border.all(width: 1),
                                borderRadius: BorderRadius.circular(10)),
                            width: _placeLocation == null ? 0 : 250,
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
                  onPressed: () => _savePlace(context),
                  icon: Icon(Icons.save),
                  label: Text('Save'),
                  style: ElevatedButton.styleFrom(
                      //to remove extra margins
                      primary: Colors.indigo,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                ),
          // Container(
          //   margin: EdgeInsets.only(top: 2),
          //   height: 50,
          //   child: FractionallySizedBox(
          //     // heightFactor: 1,
          //     widthFactor: 0.8,
          //     child: SliderButton(
          //       action: () => _savePlace(context),
          //       label: Text('Slide to Save',
          //           textAlign: TextAlign.center,
          //           style: GoogleFonts.dmSans(
          //               fontWeight: FontWeight.bold,
          //               fontSize: 19,
          //               color: Colors.white)),
          //       icon: Icon(Icons.save),
          //       alignLabel: Alignment(0, 0),
          //       width: 320,
          //       height: 60,
          //       radius: 40,
          //       buttonColor: Colors.grey.shade300,
          //       backgroundColor: Colors.indigo,
          //       buttonSize: 60,
          //       highlightedColor: Colors.black,
          //       baseColor: Colors.white,
          //       // disable: false,
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}
