import 'package:geocoding/geocoding.dart';

class LocationHelper {

  static Future<List<Placemark>> getAddress(double lat, double long) async{
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);
    return placemarks;
  }

}
