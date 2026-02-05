import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

abstract class GpsDevice {
  Future<Position> getCurrentPosition();
  double getDistanceBetween(double startLat, double startLng, double endLat, double endLng);
  Future<List<Placemark>> getAddressFromCoordinates(double lat, double lng);
  Future<bool> handleLocationPermission();
}
