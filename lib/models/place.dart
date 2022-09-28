import 'dart:io';

import 'package:flutter/cupertino.dart';

class PlaceLocation {
  final double lat;
  final double long;
  final String? address;

  const PlaceLocation({this.address, required this.lat, required this.long});
}

class Place {
  final String id;
  final String title;
  final File image;
  final PlaceLocation? location;

  const Place({required this.id, required this.title, required this.image, required this.location});
}