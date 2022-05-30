import 'package:users_app/models/active_nearby_available_drivers.dart';

class GeoFireAssistant {
  static List<ActiveNearbyAvaibleDrivers> activeNearbyAvailableDriversList = [];

  static void deleteOfflineDriverFromList(String driverId) {
    int indexNumber = activeNearbyAvailableDriversList
        .indexWhere((driver) => driver.driverId == driverId);
    activeNearbyAvailableDriversList.removeAt(indexNumber);
  }

  static void updateNearbyAvailableDriverLocation(
      ActiveNearbyAvaibleDrivers driverOnMove) {
    int indexNumber = activeNearbyAvailableDriversList
        .indexWhere((driver) => driver.driverId == driverOnMove.driverId);
    activeNearbyAvailableDriversList[indexNumber].locationLatitude =
        driverOnMove.locationLatitude;
    activeNearbyAvailableDriversList[indexNumber].locationLongitude =
        driverOnMove.locationLongitude;
  }
}
