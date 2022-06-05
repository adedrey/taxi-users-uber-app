import 'package:flutter/material.dart';
import './directions.dart';

class AppInfo extends ChangeNotifier {
  Directions? userPickUpLocation;
  Directions? userDropOffLocation;

  void updatePickupLocationAddress(Directions userPickUpAddress) {
    userPickUpLocation = Directions(
      locationLatitude: userPickUpAddress.locationLatitude,
      locationLongitude: userPickUpAddress.locationLongitude,
      locationName: userPickUpAddress.locationName,
      humanReadableAddress: userPickUpAddress.locationName,
    );
    notifyListeners();
  }

  void updateDropOffLocationAddress(Directions dropOffAddress) {
    userDropOffLocation = Directions(
      locationLatitude: dropOffAddress.locationLatitude,
      locationLongitude: dropOffAddress.locationLongitude,
      locationName: dropOffAddress.locationName,
      locationId: dropOffAddress.locationId,
      humanReadableAddress: dropOffAddress.locationName,
    );
    notifyListeners();
  }
}
