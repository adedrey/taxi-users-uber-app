import 'package:flutter/material.dart';
import 'package:users_app/models/trip_history_model.dart';
import './directions.dart';

class AppInfo extends ChangeNotifier {
  Directions? userPickUpLocation;
  Directions? userDropOffLocation;
  int countTotalTrips = 0;
  List<String> historyTripKeysList = [];
  List<TripHistoryModel> allTripHistoryInformationList = [];

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

  // Update user number of ride request - AssistantMethod
  void updateOverallTripsCounter(int overAllTripsCounter) {
    countTotalTrips = overAllTripsCounter;
  }

  // Get user ride request keys/ids - AssistantMethod
  void updateOverallTripsKeys(List<String> tripsKeysList) {
    historyTripKeysList = tripsKeysList;
  }

  // Update user each ride request history - AssistantMethod
  void updateOverAllTripsHistoryInformation(TripHistoryModel eachTripHistory) {
    allTripHistoryInformationList.add(eachTripHistory);
  }
}
