import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:users_app/models/trip_history_model.dart';

class HistoryDesignUIWidget extends StatefulWidget {
  TripHistoryModel? tripHistoryModel;

  HistoryDesignUIWidget({this.tripHistoryModel});

  @override
  _HistoryDesignUIWidgetState createState() => _HistoryDesignUIWidgetState();
}

class _HistoryDesignUIWidgetState extends State<HistoryDesignUIWidget> {
  @override
  String formatDateAndTime(String dateTimeFromDB) {
    DateTime dateTime =
        DateTime.parse(dateTimeFromDB); // convert string type to datetime type
    // Get Month and Date e.g Dec 10, 2022, 1:12 pm
    String formattedDateTime =
        "${DateFormat.MMMd().format(dateTime)}, ${DateFormat.y().format(dateTime)}, ${DateFormat.jm().format(dateTime)}";

    return formattedDateTime;
  }

  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        child: Column(
          children: [
            // Driver info - name + Fare Amount
            Row(
              children: [
                Text(
                  widget.tripHistoryModel!.driverName!,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Text(
                  widget.tripHistoryModel!.fareAmount!,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            // car_details
            Row(
              children: [
                const Icon(
                  Icons.car_repair,
                  color: Colors.grey,
                ),
                const SizedBox(
                  width: 12,
                ),
                Text(
                  widget.tripHistoryModel!.car_details!,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // const SizedBox(
                //   width: 12,
                // ),
              ],
            ),
            // Icon + pickup
            Row(
              children: [
                Image.asset(
                  "img/origin.png",
                  height: 20,
                  width: 20,
                ),
                const SizedBox(
                  width: 12,
                ),
                Text(
                  widget.tripHistoryModel!.originAddress!,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),

            // Icon + picdestinationkup
            Row(
              children: [
                Image.asset(
                  "img/destination.png",
                  height: 20,
                  width: 20,
                ),
                const SizedBox(
                  width: 12,
                ),
                Text(
                  widget.tripHistoryModel!.destinationAddress!,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),

            // Date time
            Text(
              formatDateAndTime(widget.tripHistoryModel!.destinationAddress!),
              style: const TextStyle(
                color: Colors.grey,
                // fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
