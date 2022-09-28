import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:great_places/screens/google_map_screen.dart';
import 'package:location/location.dart';

import './my_text.dart';

class LocationInput extends StatefulWidget {
  final Function myCoordinates;
  const LocationInput({Key? key, required this.myCoordinates}) : super(key: key);

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  double? _latitude;
  double? _longitude;
  var markers = HashSet<Marker>();

  // func to update ui and show map if we press on first button or the second
  void updateUi(double? latitude, double? longitude) {
    setState(() {
      _latitude = latitude;
      _longitude = longitude;
    });
  }

  // will be called if we press first button
  Future<void> _getUserLocation() async {
    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionStatus;
    LocationData locationData;

    // check if detect location service is work or not(i can get rid of next code)
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return;
    }

    // ask the user for permission to detect his current location(i can get rid of next code)
    permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();
      if (permissionStatus != PermissionStatus.granted) return;
    }

    locationData = await location.getLocation();

    updateUi(locationData.latitude, locationData.longitude);

    widget.myCoordinates(locationData.latitude, locationData.longitude);
  }

  // will be called if we press second button
  Future<void> _selectOnMap() async {
    final LatLng? selectedLocation = await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,// nice animation and cross icon instead of back icon
        builder: (context) => GoogleMapScreen(isSelected: true ,),
      ),
    );
    if (selectedLocation == null) return;

    updateUi(selectedLocation.latitude, selectedLocation.longitude);

    widget.myCoordinates(selectedLocation.latitude, selectedLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 250,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(width: 1.5, color: Colors.blueGrey),
            borderRadius: BorderRadius.circular(5),
          ),
          child: _latitude == null
              ? const Text(
                  'No Location Chosen',
                  style: TextStyle(
                    fontFamily: 'AveriaSerifLibre',
                    fontSize: 16,
                    color: Colors.blueGrey,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                )
              : GoogleMap(
                  initialCameraPosition:
                      CameraPosition(target: LatLng(_latitude!, _longitude!), zoom: 10),
                  onMapCreated: (googleMapController) {
                    setState(() {
                      markers.add(
                        Marker(
                          markerId: const MarkerId('1'),
                          position: LatLng(_latitude!, _longitude!),
                        ),
                      );
                    });
                  },
                  markers: markers,
                ),
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton.icon(
              onPressed: _getUserLocation,
              icon: const Icon(
                Icons.location_on_rounded,
                size: 20,
              ),
              label: MyText(
                text: 'Current Loc',
                letterSpace: 0,
                size: 17,
              ),
              style: ElevatedButton.styleFrom(primary: Colors.purple[200]),
            ),
            ElevatedButton.icon(
              onPressed: _selectOnMap,
              icon: const Icon(
                Icons.map_rounded,
                size: 20,
              ),
              label: MyText(
                text: 'Select On Map',
                letterSpace: 0,
                size: 17,
              ),
              style: ElevatedButton.styleFrom(primary: Colors.purple[200]),
            )
          ],
        ),
      ],
    );
  }
}
