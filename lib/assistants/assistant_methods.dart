import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../infoHandler/app_info.dart';
import '../models/direction_details_info.dart';
import '../assistants/request_assistant.dart';
import '../global/global.dart';
import '../infoHandler/directions.dart';
import '../models/user_model.dart';

import '../global/map_key.dart';

class AssistantMethods {
  static Future<String> searchAddressForGeographicCoordinates(
      Position position, context) async {
    String apiURL =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$googleApiKey';
    String humanReadableAddress = '';

    var requestResponse = await RequestAssistant.receiveRequest(apiURL);

    if (requestResponse != 'failed') {
      humanReadableAddress = requestResponse['results'][0]["formatted_address"];
      Directions userPickUpAddress = Directions();
      userPickUpAddress.locationLatitude = position.latitude;
      userPickUpAddress.locationLongitude = position.longitude;
      userPickUpAddress.locationName = humanReadableAddress;
      Provider.of<AppInfo>(context, listen: false)
          .updatePickupLocationAddress(userPickUpAddress);
    }
    return humanReadableAddress;
  }

  static readCurrentOnlineUserInfo() async {
    currentFirebaseUser = fAuth.currentUser;
    DatabaseReference userRef = FirebaseDatabase.instance
        .ref()
        .child('users')
        .child(currentFirebaseUser!.uid);
    userRef.once().then(
      (snap) {
        if (snap.snapshot.value != null) {
          userModelCurrentInfo = UserModel.fromSnapshot(snap.snapshot);
        }
      },
    );
  }

  // Get routes from origin to destination
  static Future<DirectionDetailsInfo?>
      obtainOriginToDestinationDirectionDetails(
          LatLng originPosition, LatLng destinationPosition) async {
    String ultToObtainOriginToDestinationDirectionDetails =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${originPosition.latitude},${originPosition.longitude}&destination=${destinationPosition.latitude},${destinationPosition.longitude}&key=$googleApiKey";
    var responseDirectionApi = await RequestAssistant.receiveRequest(
        ultToObtainOriginToDestinationDirectionDetails);

    if (responseDirectionApi == "failed") {
      return null;
    }
    if (responseDirectionApi["status"] == "OK") {
      DirectionDetailsInfo directionDetailsInfo = DirectionDetailsInfo();
      directionDetailsInfo.e_points =
          responseDirectionApi["routes"][0]["overview_polyline"]["points"];
      directionDetailsInfo.distance_text =
          responseDirectionApi["routes"][0]["legs"][0]["distance"]["text"];
      directionDetailsInfo.distance_value =
          responseDirectionApi["routes"][0]["legs"][0]["distance"]["value"];
      directionDetailsInfo.duration_text =
          responseDirectionApi["routes"][0]["legs"][0]["duration"]["text"];
      directionDetailsInfo.duration_value =
          responseDirectionApi["routes"][0]["legs"][0]["duration"]["value"];
      return directionDetailsInfo;
    } else {
      return null;
    }
  }

  // Calculate Fare AMount

  static calculuateFareAmountFromOriginToDestination(
      DirectionDetailsInfo directionDetailsInfo) {
    // Calculate how much to charge per minute
    double timeTraveledFareAmountPerMinute =
        (directionDetailsInfo.duration_value! / 60) * 0.1;
    // Calcate how much per kilometre
    double distanceTraveledFareAMountPerKilometer =
        (directionDetailsInfo.distance_value! / 1000) * 0.1;
    // Calcutae total fare amount to get overall fare amount from origin to destination

    double totalFareAmount = timeTraveledFareAmountPerMinute +
        distanceTraveledFareAMountPerKilometer;
    // To convert from USD to other currency
    // 1 USD = 400 Naira
    double localCurrencyTotalFareAmount = totalFareAmount * 400;

    return double.parse(localCurrencyTotalFareAmount.toStringAsFixed(1));
  }

  // Send Notification To Driver
  static sendNotificationToDriverNow(String deviceRegistrationToken,
      String userRideRequestId, BuildContext context) async {
    // Get User Drop Off Location
    var destinationAddress = userDropOffAddress;
    // Define Header of the Notification
    Map<String, String> headerNotification = {
      'Content-Type': 'application/json',
      'Authorization': cloudMessagingServerToken,
    };
    // Define Body of Notification
    Map bodyNotification = {
      "body": "Destination Address is $destinationAddress",
      "title": "New Trip Request",
    };
    // Define Data of the Notification
    Map dataMap = {
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      "id": "1",
      "status": "done",
      "rideRequestId": userRideRequestId,
    };
    // Define the official notification format
    Map officialNotificationFormat = {
      "notification": bodyNotification,
      "priority": "high",
      "data": dataMap,
      "to": deviceRegistrationToken,
    };
    // Send Notification to User
    var responseNotificationUrl = http.post(
      Uri.parse("https://fcm.googleapis.com/fcm/send"),
      headers: headerNotification,
      body: jsonEncode(officialNotificationFormat),
    );
  }
}
