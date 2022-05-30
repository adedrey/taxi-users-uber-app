import 'package:flutter/material.dart';
import 'package:users_app/assistants/request_assistant.dart';
import 'package:users_app/global/map_key.dart';
import 'package:users_app/models/predicted_places.dart';
import 'package:users_app/widgets/place_prediction_tile.dart';

class SearchPlacesScreen extends StatefulWidget {
  const SearchPlacesScreen({Key? key}) : super(key: key);

  @override
  _SearchPlacesScreenState createState() => _SearchPlacesScreenState();
}

class _SearchPlacesScreenState extends State<SearchPlacesScreen> {
  List<PredictedPlaces> placePredictedList = [];
  void _findPlaceAutoCompleteSearch(String inputText) async {
    if (inputText.length > 1) {
      String urlAutoCompleteSearch =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$inputText&key=$googleApiKey&components=country:NG';
      var responseAutoCompleteSearch =
          await RequestAssistant.receiveRequest(urlAutoCompleteSearch);
      if (responseAutoCompleteSearch == 'failed') {
        return;
      }
      if (responseAutoCompleteSearch["status"] == "OK") {
        var placePredictions = responseAutoCompleteSearch["predictions"];
        var placePredictionsList = (placePredictions as List)
            .map((place) => PredictedPlaces.fromJson(place))
            .toList();
        setState(() {
          placePredictedList = placePredictionsList;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // Search Place UI
          Container(
            height: 160,
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Colors.black54,
              boxShadow: [
                BoxShadow(
                  color: Colors.white54,
                  blurRadius: 8,
                  spreadRadius: 0.5,
                  offset: Offset(0.7, 0.7),
                )
              ],
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 25,
                ),
                Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        Navigator.of(context).pop();
                      },
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.grey,
                      ),
                    ),
                    const Center(
                      child: Text(
                        "Search & Set DropOff Location",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.adjust_sharp,
                      color: Colors.grey,
                    ),
                    const SizedBox(
                      width: 18.0,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: 'search here...',
                            fillColor: Colors.white54,
                            filled: true,
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(
                              left: 11,
                              top: 8.0,
                              bottom: 8.0,
                            ),
                          ),
                          onChanged: (value) {
                            _findPlaceAutoCompleteSearch(value);
                          },
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          // Display Place Predictions
          if (placePredictedList.length > 0)
            Expanded(
              child: ListView.separated(
                  physics: const ClampingScrollPhysics(),
                  itemBuilder: (context, index) =>
                      PlacePredictionListTile(placePredictedList[index]),
                  separatorBuilder: (context, index) => const Divider(
                        height: 1,
                        color: Colors.white,
                        thickness: 1,
                      ),
                  itemCount: placePredictedList.length),
            )
        ],
      ),
    );
  }
}
