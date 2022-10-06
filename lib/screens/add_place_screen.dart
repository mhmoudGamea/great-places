import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';

import '../helpers/location_helper.dart';
import '../models/place.dart';
import '../providers/great_places_provider.dart';
import '../widgets/image_input.dart';
import '../widgets/location_input.dart';
import '../widgets/my_text.dart';

class AddPlaceScreen extends StatefulWidget {
  static const rn = '/add_place_screen';

  const AddPlaceScreen({Key? key}) : super(key: key);

  @override
  State<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final _form = GlobalKey<FormState>();
  final _controller = TextEditingController();
  bool cursorAndLabelError = false;

  File? _pickedImage;

  void _selectImage(File picked) {
    _pickedImage = picked;
  }

  late PlaceLocation _pickedLocation;

  void _selectedCoordinates(double latitude, double longitude) async {
    final List<Placemark> placemarks =
        await LocationHelper.getAddress(latitude, longitude); // locationHelper class
    _pickedLocation = PlaceLocation(
        lat: latitude,
        long: longitude,
        address:
            '${placemarks[0].country}, ${placemarks[0].administrativeArea}, ${placemarks[0].subAdministrativeArea}');
  }

  void _savePlace() {
    _form.currentState!.validate();
    if (_pickedImage == null) {
      return;
    }
    Provider.of<GreatPlacesProvider>(context, listen: false)
        .addPlace(_controller.text, _pickedImage!, _pickedLocation);
    Navigator.pop(context);
  }

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
          text: 'Add new place',
          letterSpace: 0.2,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 15.0, right: 12, left: 12),
                child: Column(
                  children: [
                    Form(
                      key: _form,
                      child: TextFormField(
                        controller: _controller,
                        validator: (value) {
                          if (value!.isEmpty) {
                            setState(() {
                              cursorAndLabelError = true;
                            });
                            return 'please enter a value';
                          }
                          setState(() {
                            cursorAndLabelError = false;
                          });
                          return null;
                        },
                        cursorColor: cursorAndLabelError ? Colors.red : Colors.blueGrey,
                        decoration: InputDecoration(
                          labelText: 'Title',
                          labelStyle: TextStyle(
                              fontFamily: 'AveriaSerifLibre',
                              color: cursorAndLabelError ? Colors.red : Colors.blueGrey,
                              letterSpacing: 1.2),
                          border: const OutlineInputBorder(),
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(width: 1.3, color: Colors.blueGrey)),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(width: 1.3, color: Colors.blueGrey)),
                          errorBorder: const OutlineInputBorder(borderSide: BorderSide(width: 1.3, color: Colors.red)),
                          focusedErrorBorder: const OutlineInputBorder(borderSide: BorderSide(width: 1.3, color: Colors.red)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ImageInput(onSelectedImage: _selectImage),
                    const SizedBox(
                      height: 10,
                    ),
                    LocationInput(myCoordinates: _selectedCoordinates),
                  ],
                ),
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              _savePlace();
              if(_controller.text.isNotEmpty && _pickedImage != null) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.purple[200]?.withOpacity(0.7),
                  elevation: 0,
                  content: MyText(text: 'One place is added', letterSpace: 1.3, size: 16,)));
              }
            },
            label: MyText(
              text: 'Add Place',
              size: 17,
            ),
            icon: const Icon(
              Icons.add_rounded,
              size: 21,
            ),
            style: ElevatedButton.styleFrom(
                primary: Colors.purple[200],
                elevation: 0,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: const EdgeInsets.symmetric(vertical: 12)),
          ),
        ],
      ),
    );
  }
}
