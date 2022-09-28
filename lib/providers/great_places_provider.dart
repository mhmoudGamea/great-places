import 'dart:io';

import 'package:flutter/material.dart';

import '../helpers/db_helper.dart';
import '../models/place.dart';

class GreatPlacesProvider with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get getItems {
    return [..._items];
  }

  Place findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  void addPlace(String locTitle, File locImage, PlaceLocation placeLocation) async {
    final Place newPlace = Place(
        id: DateTime.now().toString(), title: locTitle, image: locImage, location: placeLocation);
    _items.add(newPlace);
    notifyListeners();
    await DBHelper.putData('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,// the image always stored as a path in DB not as a File
      'latitude': newPlace.location!.lat,
      'longitude': newPlace.location!.long,
      'address': newPlace.location!.address
    });
  }

  Future<void> fetchAndSetData() async {
    final myPlaces = await DBHelper.getData('user_places');
    // item = Map<String, dynamic>
    _items = myPlaces
        .map((item) =>
            Place(id: item['id'], title: item['title'], image: File(item['image']), location: PlaceLocation(lat: item['latitude'], long: item['longitude'], address: item['address'])))
        .toList();
    notifyListeners();
  }

  Future<void> deletePlace(String id) async {
    _items.removeWhere((element) => element.id == id);
    DBHelper.deleteData('user_places', id);
    notifyListeners();
  }
}
