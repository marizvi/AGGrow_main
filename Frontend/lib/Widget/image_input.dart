import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

class ImageInput extends StatefulWidget {
  final Function onSelectImage;
  final String existingimg;
  ImageInput(this.onSelectImage, this.existingimg);
  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _pickedImage;
  Future<void> _takePicture() async {
    //ImagePicker retirns a future
    // final picker = await ImagePicker();
    //can also chose ImageSource.gallery
    // final _picker = ImagePicker();
    // final image =
    //     await _picker.pickImage(source: ImageSource.camera, maxWidth: 600);
    // if (image == null) return;
    // setState(() {
    //   _storedImage = File(image.path);
    // });

    // //now sotring it on device
    // final appDir = await syspaths.getApplicationDocumentsDirectory();
    // final fileName = path.basename(image.path);
    // final saveImage = await File(image.path).copy('${appDir.path}/$fileName');
    // widget.onSelectImage(saveImage);
    await showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: Icon(Icons.photo_library),
                      title: Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: Icon(Icons.photo_camera),
                    title: Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  _imgFromCamera() async {
    final ImagePicker _picker = ImagePicker();
    XFile? pickedImage;
    pickedImage = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 60,
      maxWidth: 500,
    );
    //imageQuality varies from 0 to 100
    setState(() {
      _pickedImage = File(pickedImage!.path);
    });
    widget.onSelectImage(File(_pickedImage!.path));
  }

  _imgFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    XFile? pickedImage;
    pickedImage = await _picker.pickImage(
        source: ImageSource.gallery, imageQuality: 60, maxWidth: 500);

    setState(() {
      _pickedImage = File(pickedImage!.path);
    });
    widget.onSelectImage(File(_pickedImage!.path));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        //preview
        Container(
            margin: EdgeInsets.only(left: 8),
            width: 150,
            height: 100,
            alignment: Alignment.center,
            decoration:
                BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
            child: Column(
              children: [
                if (_pickedImage != null)
                  Container(
                    height: 98,
                    child: Image.file(_pickedImage as File,
                        fit: BoxFit.cover,
                        width: double
                            .infinity //image can take full width of surrounding container,
                        ),
                  )
                else if (widget.existingimg != '')
                  Container(
                    height: 98,
                    child: Image.network(
                      widget.existingimg,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  )
                else
                  Text(
                    'No Image Taken',
                    textAlign: TextAlign.center,
                  ),
              ],
            )),
        Expanded(
          child: TextButton.icon(
              onPressed: _takePicture,
              icon: Icon(Icons.camera),
              label: Text("Take Picture")),
        ),
      ],
    );
  }
}
