import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:users_app/global/global.dart';
import '../assistants/request_assistant.dart';
import '../global/map_key.dart';
import '../infoHandler/app_info.dart';
import '../infoHandler/directions.dart';
import '../models/predicted_places.dart';
import './progress_dialog.dart';

class PlacePredictionListTile extends StatefulWidget {
  final PredictedPlaces? predictedPlaces;

  PlacePredictionListTile(this.predictedPlaces);

  @override
  State<PlacePredictionListTile> createState() =>
      _PlacePredictionListTileState();
}

class _PlacePredictionListTileState extends State<PlacePredictionListTile> {
  void getPlaceDirectionDetails(String placeId, BuildContext context) async {
    showDialog(
        context: context,
        builder: (context) => ProgressDialog(
              message: "Setting Up Drop-off. Please wait...",
            ));
    String placeDirectionDetailsUrl =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$googleApiKey";
    var responseApi =
        await RequestAssistant.receiveRequest(placeDirectionDetailsUrl);

    Navigator.of(context).pop();
    if (responseApi == "failed") {
      return;
    }

    if (responseApi["status"] == "OK") {
      Directions directions = Directions();
      directions.locationName = responseApi["result"]["name"];
      directions.locationLatitude =
          responseApi["result"]["geometry"]["location"]["lat"];
      directions.locationLongitude =
          responseApi["result"]["geometry"]["location"]["lng"];
      directions.locationId = placeId;

      Provider.of<AppInfo>(context, listen: false)
          .updateDropOffLocationAddress(directions);

      setState(() {
        userDropOffAddress = directions.locationName!;
      });

      Navigator.of(context).pop("obtainedDropOff");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        FocusScope.of(context).unfocus();
        getPlaceDirectionDetails(widget.predictedPlaces!.place_id!, context);
      },
      style: ElevatedButton.styleFrom(primary: Colors.white10),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: [
            const Icon(
              Icons.add_location,
              color: Colors.grey,
            ),
            const SizedBox(
              width: 14,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    widget.predictedPlaces!.main_text!,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 16, color: Colors.white54),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    widget.predictedPlaces!.secondary_text!,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, color: Colors.white54),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
