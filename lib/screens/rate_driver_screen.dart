import 'package:flutter/material.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';
import 'package:users_app/global/global.dart';

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
      backgroundColor: Colors.grey[200],
      body: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        backgroundColor: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.all(8),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Rate Trip Experience",
                style: TextStyle(
                  fontSize: 22,
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
                onRatingChanged: (valueOfStarChoosed) {
                  countRatingStar = valueOfStarChoosed;
                  if (countRatingStar == 1) {}
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
