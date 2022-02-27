import 'package:flutter/material.dart';

class NewCrop extends StatefulWidget {
  final Function addCrops;
  NewCrop(this.addCrops);
  @override
  State<NewCrop> createState() => _NewCropState();
}

class _NewCropState extends State<NewCrop> {
  final _formKey = GlobalKey<FormState>();

  String? _name;

  String? _duration;

  double? _price;

  void _submit() {
    Navigator.of(context).pop();
    FocusScope.of(context).unfocus(); //will close the keyboard
    final isValid = _formKey.currentState?.validate() ?? false;
    // .validate is a boolean type and will return true if all
    // validated fields return null
    if (isValid) {
      print('inside valid');
      _formKey.currentState!.save();
      //trim() is use to remove leading and trailing white spaces
      widget.addCrops(_name, _price, _duration);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        // height: 320,
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                // decoration: BoxDecoration(color: Colors.blue),
                padding: EdgeInsets.all(8),
                child: Container(
                  child: Text(
                    'Add Section',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Divider(
                height: 0.3,
                thickness: 1.5,
              ),
              Form(
                key: _formKey,
                child: Container(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    children: [
                      TextFormField(
                        key: ValueKey('cropName'),
                        decoration: InputDecoration(
                          labelText: 'Crop Name.',
                        ),
                        validator: (value) {
                          if (value!.isEmpty || value.length < 4) {
                            return 'name should contain at least 4 characters';
                          }
                          return null; //means everything is alright
                        },
                        onSaved: (value) {
                          _name = value;
                        },
                      ),
                      TextFormField(
                        key: ValueKey('months'),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Expected months',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter valid value';
                          }
                          return null; //means everything is alright
                        },
                        onSaved: (value) {
                          _duration = value;
                        },
                      ),
                      TextFormField(
                        key: ValueKey('price'),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Price (in rupees)',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter valid value';
                          }
                          return null; //means everything is alright
                        },
                        onSaved: (value) {
                          _price = double.parse(value as String);
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: _submit,
                        child: Text('Add'),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
