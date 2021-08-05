import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class getUserCoordinates {
  Position? position;
  List<Placemark>? placemarks;

  Future<void> getCurrentLocation() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);

    placemarks =
        await placemarkFromCoordinates(position!.latitude, position!.longitude);
  }
}
