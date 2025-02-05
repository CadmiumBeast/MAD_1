import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../Services/location_service.dart';

class LocationProvider extends ChangeNotifier {
  String _currentLocation = "Fetching location...";
  String _address = "Fetching address...";


  String get currentLocation => _currentLocation;
  String get address => _address;


  Future<void> fetchCurrentLocation() async {
    try {
      Position position = await LocationService().getCurrentLocation();
      _currentLocation = "Lat: ${position.latitude}, Lon: ${position.longitude}";

      // Perform reverse geocoding
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        _address = "${place.street}, ${place.locality}, ${place.country}";
      } else {
        _address = "Address not found.";
      }

      notifyListeners();
    } catch (e) {
      _currentLocation = "Unable to fetch location.";
      _address = "Unable to fetch address.";
      notifyListeners();
    }
  }

  void updateLocation(String newLocation) {
    _currentLocation = newLocation;
    notifyListeners();
  }
}