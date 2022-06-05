import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';
import 'package:users_app/assistants/assistant_methods.dart';
import 'package:users_app/global/global.dart';
import 'package:users_app/main.dart';

class SelectNearestActiveDriverScreen extends StatefulWidget {
  DatabaseReference? referenceRideRequest;
  SelectNearestActiveDriverScreen({this.referenceRideRequest});

  @override
  _SelectNearestActiveDriverScreenState createState() =>
      _SelectNearestActiveDriverScreenState();
}

class _SelectNearestActiveDriverScreenState
    extends State<SelectNearestActiveDriverScreen> {
  String fareAMount = "";
  // Get Fare Amount according to Vehicle type using the Drivers List and
  // sendinf index number of each driver
  getFareAmountAccordingToVehicleType(int index) {
    // Check if a trip as being assigned
    if (tripDirectionDetailInfo != null) {
      // Check car type
      if (dList[index]["car_details"]["car_type"].toString() == "bike") {
        // For Bike, divide total amount by 2
        fareAMount =
            (AssistantMethods.calculuateFareAmountFromOriginToDestination(
                        tripDirectionDetailInfo!) /
                    2)
                .toStringAsFixed(0);
      }
      if (dList[index]["car_details"]["car_type"].toString() == "uber-x") {
        // For uber-x, mutiply total amount by 2
        fareAMount =
            (AssistantMethods.calculuateFareAmountFromOriginToDestination(
                        tripDirectionDetailInfo!) *
                    2)
                .toStringAsFixed(0);
      }
      if (dList[index]["car_details"]["car_type"].toString() == "uber-go") {
        // For uber-go
        fareAMount =
            AssistantMethods.calculuateFareAmountFromOriginToDestination(
                    tripDirectionDetailInfo!)
                .toStringAsFixed(0);
      }

      return fareAMount;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.white54,
        title: const Text(
          'Nearest Online Drivers',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: Colors.white,
          ),
          onPressed: () {
            // Delete write request from the Database
            widget.referenceRideRequest!.remove();
            Fluttertoast.showToast(
                timeInSecForIosWeb: 4000,
                msg:
                    "You have cancelled your ride request. Resetting trip now...");
            Future.delayed(
              const Duration(milliseconds: 4000),
              () {
                MyApp.restartApp(context);
              },
            );
          },
        ),
      ),
      body: ListView.builder(
        itemBuilder: (content, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                choosenDriverId = dList[index]["id"].toString();
              });
              Navigator.pop(context, "driverSelected");
            },
            child: Card(
              color: Colors.grey,
              elevation: 1,
              shadowColor: Colors.green,
              margin: EdgeInsets.all(8),
              child: ListTile(
                leading: Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Image.asset(
                    "assets/img/" +
                        dList[index]["car_details"]["car_type"].toString() +
                        ".png",
                    width: 70,
                  ),
                ),
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      dList[index]["name"],
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    Text(
                      dList[index]["car_details"]["car_model"],
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white54,
                      ),
                    ),
                    SmoothStarRating(
                      rating: 3.5,
                      color: Colors.black,
                      borderColor: Colors.black,
                      allowHalfRating: true,
                      starCount: 5,
                      size: 15,
                    )
                  ],
                ),
                trailing: Column(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "₦ " + getFareAmountAccordingToVehicleType(index),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        // color: Colors.white54,
                      ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      tripDirectionDetailInfo != null
                          ? tripDirectionDetailInfo!.duration_text!
                          : "",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        // fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      tripDirectionDetailInfo != null
                          ? tripDirectionDetailInfo!.distance_text!
                          : "",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        // fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        itemCount: dList.length,
      ),
    );
  }
}
