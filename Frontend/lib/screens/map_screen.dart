import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/place.dart';

class MapScreen extends StatefulWidget {
  final PlaceLocation initialLocation;
  final bool isSelecting;

//here both arguements of MapScreen are optional as enclosed inside {}
  MapScreen(this.initialLocation, {this.isSelecting = false});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _picekdLocation;
  void _selectLocation(LatLng position) {
    setState(() {
      _picekdLocation = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Map'),
        actions: [
          if (widget.isSelecting)
            IconButton(
                onPressed: _picekdLocation == null
                    ? null
                    : () {
                        Navigator.of(context).pop(
                            _picekdLocation); //will now send data to location_input.dart
                      },
                icon: Icon(Icons.check))
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
            widget.initialLocation.latitude,
            widget.initialLocation.longitude,
          ),
          zoom: 16,
        ),
        //onTap method automatically provides tapped position in LatLng form
        onTap: //(value) {
            //print('latitude is here');
            //print(value.latitude);
            //},
            widget.isSelecting ? _selectLocation : null,
        markers: (_picekdLocation == null && widget.isSelecting)
            ? {}
            : {
                Marker(
                    markerId: MarkerId('m1'),
                    position: _picekdLocation ??
                        LatLng(widget.initialLocation.latitude,
                            widget.initialLocation.longitude))
              },
      ),
    );
  }
}
