import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:presensi_application_1/core/device/repositories/gps_device.dart';

class GpsDeviceImpl implements GpsDevice {
  @override
  Future<Position> getCurrentPosition() async {
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  @override
  double getDistanceBetween(
      double startLat, double startLng, double endLat, double endLng) {
    return Geolocator.distanceBetween(startLat, startLng, endLat, endLng);
  }

  @override
  Future<List<Placemark>> getAddressFromCoordinates(double lat, double lng) async {
    try {
      return await placemarkFromCoordinates(lat, lng);
    } catch (e) {
      return [];
    }
  }

  @override
  Future<bool> handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      return false;
    } 

    return true;
  }
}
