import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/place.dart';
import '../widgets/my_text.dart';

class GoogleMapScreen extends StatefulWidget {
  bool isSelected;
  final PlaceLocation placeLocation;

  GoogleMapScreen(
      {this.placeLocation = const PlaceLocation(lat: 30.630, long: 30.996),
      this.isSelected = false});

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  LatLng? _myLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20)),
        title: MyText(
          text: 'Your Map',
        ),
        actions: [
          IconButton(
              onPressed: _myLocation == null
                  ? null
                  : () {
                      Navigator.of(context).pop(_myLocation);
                    },
              icon: const Icon(Icons.check_rounded))
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
            target: LatLng(widget.placeLocation.lat, widget.placeLocation.long), zoom: 10),
        onTap: (latlng) {
          setState(() {
            widget.isSelected = true;
            _myLocation = latlng;
          });
        },
        markers: (_myLocation == null && widget.isSelected)
            ? {
                Marker(
                    markerId: const MarkerId('2'),
                    position: LatLng(widget.placeLocation.lat, widget.placeLocation.long))
              }
            : {
                Marker(
                    markerId: const MarkerId('3'),
                    position: LatLng(_myLocation!.latitude, _myLocation!.longitude))
              },
      ),
    );
  }
}
