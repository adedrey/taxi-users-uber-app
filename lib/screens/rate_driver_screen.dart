import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';
import 'package:users_app/global/global.dart';
import 'package:users_app/main.dart';

class RateDriverScreen extends StatefulWidget {
  String? assignedDriverId;
  RateDriverScreen({this.assignedDriverId});

  @override
  _RateDriverScreenState createState() => _RateDriverScreenState();
}

class _RateDriverScreenState extends State<RateDriverScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        backgroundColor: Colors.white60,
        child: Container(
          margin: const EdgeInsets.all(8),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white54,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 22,
              ),
              const Text(
                "Rate Trip Experience",
                style: TextStyle(
                  fontSize: 22,
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              const Divider(
                thickness: 4,
                height: 4,
              ),
              const SizedBox(
                height: 24,
              ),
              SmoothStarRating(
                rating: countRatingStar,
                // allowHalfRating: true,
                starCount: 5,
                size: 46,
                color: Colors.green,
                borderColor: Colors.green,
                onRatingChanged: (valueOfStarChoosed) {
                  countRatingStar = valueOfStarChoosed;
                  if (countRatingStar == 1) {
                    setState(() {
                      titleStarRating = "Very Bad";
                    });
                  }
                  if (countRatingStar == 2) {
                    setState(() {
                      titleStarRating = "Bad";
                    });
                  }
                  if (countRatingStar == 3) {
                    setState(() {
                      titleStarRating = "Good";
                    });
                  }
                  if (countRatingStar == 4) {
                    setState(() {
                      titleStarRating = "Very Good";
                    });
                  }
                  if (countRatingStar == 5) {
                    setState(() {
                      titleStarRating = "Excellent";
                    });
                  }
                  if (countRatingStar == 1) {
                    setState(() {
                      titleStarRating = "Very Bad";
                    });
                  }
                },
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                titleStarRating,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              ElevatedButton(
                onPressed: () {
                  DatabaseReference rateDriverRef = FirebaseDatabase.instance
                      .ref()
                      .child("drivers")
                      .child(widget.assignedDriverId!)
                      .child("ratings");
                  rateDriverRef.once().then((snapShot) {
                    if (snapShot.snapshot.value == null) {
                      rateDriverRef.set(countRatingStar.toString());
                    } else {
                      double pastRatings =
                          double.parse(snapShot.snapshot.value.toString());
                      double newDriverAverageRatings =
                          (pastRatings + countRatingStar) / 2;
                      rateDriverRef.set(newDriverAverageRatings.toString());
                    }
                    Fluttertoast.showToast(msg: "Please Restart App Now");
                    MyApp.restartApp(context);
                  });
                },
                style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 74)),
                child: const Text(
                  "Submit",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
