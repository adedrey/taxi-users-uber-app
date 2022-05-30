import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:users_app/assistants/assistant_methods.dart';
import 'package:users_app/assistants/geofire_assistant.dart';
import 'package:users_app/infoHandler/app_info.dart';
import 'package:users_app/main.dart';
import 'package:users_app/models/active_nearby_available_drivers.dart';
import 'package:users_app/models/direction_details_info.dart';
import 'package:users_app/screens/select_nearest_active_driver_screen.dart';
import 'package:users_app/widgets/progress_dialog.dart';
import './search_places_screen.dart';
import '../widgets/app_drawer.dart';

import '../global/global.dart';

class MainScreen extends StatefulWidget {
  static const routeName = "/home";

  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController? _newGoogleMapController;
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  GlobalKey<ScaffoldState> sKey = GlobalKey<ScaffoldState>();
  double searchLocationContainerHeight = 220;
  Position? userCurrentPosiiton;
  var geoLocator = Geolocator();
  LocationPermission? _locationPermission;
  double bottomPaddingOfMap = 0;
  String userName = 'your Name';
  String userEmail = 'your Email';
  String userPickUpLocation = 'Your Current Location';
  // List of e_points
  List<LatLng> pLineCoOrdinatesList = [];
  Set<Polyline> polyLineSet = {};
  // Define Markers
  Set<Marker> markersSet = {};
  Set<Circle> circleSet = {};
  // User Either Opens Draw to switch Screen or Cancel ride Request
  bool openNavigationDrawer = true;
  // Show when there are active nearby drivers key is loaded
  bool activeNearbyDriverKeyLoaded = false;
  //  Show marker icon for nearby Drivers
  BitmapDescriptor? activeNearbyIcon;

  // Show Active Nearby Available Riders
  List<ActiveNearbyAvaibleDrivers> onlineNearbyAvailableDriversList = [];

  void _blackThemeGoogleMap() {
    _newGoogleMapController!.setMapStyle('''
                    [
                      {
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#242f3e"
                          }
                        ]
                      },
                      {
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#746855"
                          }
                        ]
                      },
                      {
                        "elementType": "labels.text.stroke",
                        "stylers": [
                          {
                            "color": "#242f3e"
                          }
                        ]
                      },
                      {
                        "featureType": "administrative.locality",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "poi",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "poi.park",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#263c3f"
                          }
                        ]
                      },
                      {
                        "featureType": "poi.park",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#6b9a76"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#38414e"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "geometry.stroke",
                        "stylers": [
                          {
                            "color": "#212a37"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#9ca5b3"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#746855"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "geometry.stroke",
                        "stylers": [
                          {
                            "color": "#1f2835"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#f3d19c"
                          }
                        ]
                      },
                      {
                        "featureType": "transit",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#2f3948"
                          }
                        ]
                      },
                      {
                        "featureType": "transit.station",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#17263c"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#515c6d"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "labels.text.stroke",
                        "stylers": [
                          {
                            "color": "#17263c"
                          }
                        ]
                      }
                    ]
                ''');
  }

  void _locateUserPosition() async {
    Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    userCurrentPosiiton = currentPosition;
    LatLng latLngPosition =
        LatLng(userCurrentPosiiton!.latitude, userCurrentPosiiton!.longitude);
    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 14);
    _newGoogleMapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    String humanReadableAddress =
        await AssistantMethods.searchAddressForGeographicCoordinates(
            userCurrentPosiiton!, context);

    // Display all nearby drivers
    _initializeGeoFireListener();
  }

  void _checkIfLocationPermissionAllowed() async {
    _locationPermission = await Geolocator.requestPermission();
    if (_locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
    }
  }

  // Create Active Nearby Driver Marker Icon
  void _createActiveNearbyDriverMarkerIcon() {
    if (activeNearbyIcon == null) {
      ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context, size: const Size(1, 1));
      BitmapDescriptor.fromAssetImage(imageConfiguration, 'assets/img/car.png')
          .then((value) {
        activeNearbyIcon = value;
      });
    }
  }

  // Display active drivers on the Map
  void _displayActiveDriversOnUserMap() {
    setState(() {
      // Clear all markers
      markersSet.clear();
      circleSet.clear();
      // Create a set of markers to display those markers
      Set<Marker> driverMarkerSet = Set<Marker>();

      // Add Marker to each Driver Position
      for (ActiveNearbyAvaibleDrivers eachDriver
          in GeoFireAssistant.activeNearbyAvailableDriversList) {
        LatLng eachDriverActivePosition =
            LatLng(eachDriver.locationLatitude!, eachDriver.locationLongitude!);
        Marker maker = Marker(
          markerId: MarkerId(eachDriver.driverId!),
          position: eachDriverActivePosition,
          // icon:
          //     BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
          icon: activeNearbyIcon!,
          rotation: 360,
        );
        driverMarkerSet.add(maker);
      }
      setState(() {
        // Assign DriverMarker to MarkerSet
        markersSet = driverMarkerSet;
      });
    });
  }

  void _initializeGeoFireListener() {
    Geofire.initialize("activeDrivers");
    Geofire.queryAtLocation(
      userCurrentPosiiton!.latitude,
      userCurrentPosiiton!.longitude,
      10,
    )!
        .listen((map) {
      print(map);
      if (map != null) {
        var callBack = map['callBack'];

        //latitude will be retrieved from map['latitude']
        //longitude will be retrieved from map['longitude']

        switch (callBack) {
          case Geofire.onKeyEntered: //Whenever any driver become online.
            ActiveNearbyAvaibleDrivers activeNearbyAvaibleDriver =
                ActiveNearbyAvaibleDrivers();
            activeNearbyAvaibleDriver.driverId = map['key'];
            activeNearbyAvaibleDriver.locationLatitude = map['latitude'];
            activeNearbyAvaibleDriver.locationLongitude = map['longitude'];
            GeoFireAssistant.activeNearbyAvailableDriversList
                .add(activeNearbyAvaibleDriver);
            // Check if the nearby active driver key is loaded
            if (activeNearbyDriverKeyLoaded == true) {
              _displayActiveDriversOnUserMap();
            }
            break;

          case Geofire
              .onKeyExited: // Whenever any driver become non-active/offline
            GeoFireAssistant.deleteOfflineDriverFromList(map['key']);
            _displayActiveDriversOnUserMap();
            break;

          case Geofire
              .onKeyMoved: // Whenever driver moves - Update Driver Locatino
            ActiveNearbyAvaibleDrivers activeNearbyAvaibleDriver =
                ActiveNearbyAvaibleDrivers();
            activeNearbyAvaibleDriver.driverId = map['key'];
            activeNearbyAvaibleDriver.locationLatitude = map['latitude'];
            activeNearbyAvaibleDriver.locationLongitude = map['longitude'];
            GeoFireAssistant.updateNearbyAvailableDriverLocation(
                activeNearbyAvaibleDriver);
            // Display with marker
            _displayActiveDriversOnUserMap();
            break;

          //  Display Online Active Drivers on users map
          case Geofire.onGeoQueryReady:
            activeNearbyDriverKeyLoaded = true;
            _displayActiveDriversOnUserMap();
            break;
        }
      }

      setState(() {});
    });
  }

  // Retrieve Online Drivers Information
  _retrieveOnlineDriversInformation(
      List<ActiveNearbyAvaibleDrivers> onlineNearestDriversList) async {
    DatabaseReference ref =
        await FirebaseDatabase.instance.ref().child("drivers");
    for (int i = 0; i < onlineNearbyAvailableDriversList.length; i++) {
      await ref
          .child(onlineNearestDriversList[i].driverId.toString())
          .once()
          .then(
        (dataSnapshot) {
          var driverKeyInfo = dataSnapshot.snapshot.value;
          dList.add(driverKeyInfo);
        },
      );
    }
  }

  // Checks if there is any online available driver
  void _searchNearstOnlineDrivers() async {
    if (onlineNearbyAvailableDriversList.length == 0) {
      // Check if the length is zero
      // Cancel the ride request
      // Clear the polyline and marker set
      setState(() {
        polyLineSet.clear();
        markersSet.clear();
        circleSet.clear();
        pLineCoOrdinatesList.clear();
      });

      Fluttertoast.showToast(msg: "No online nearest driver available.");
      Fluttertoast.showToast(msg: "Search again for riders. Restarting now");
      Future.delayed(
        const Duration(milliseconds: 4000),
        () {
          MyApp.restartApp(context);
        },
      );
      // Then return;
      return;
    }
    // Retrieve Online Drivers Information
    await _retrieveOnlineDriversInformation(onlineNearbyAvailableDriversList);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SelectNearestActiveDriverScreen(),
      ),
    );
  }

  // Initialize available riders once dropoff location has been set
  void _saveRideRequestInformation() {
    // Save the RideRequest Information

    // Assisgn nearby available drivers list
    onlineNearbyAvailableDriversList =
        GeoFireAssistant.activeNearbyAvailableDriversList;
    // Checks if there is any online available driver
    _searchNearstOnlineDrivers();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkIfLocationPermissionAllowed();
  }

  // Get trip direction info from origin to destination and draw the
  // polyline on the map
  Future<void> _drawPolyLineFromOriginToDestination() async {
    // Get Useer origin position
    var originPosition =
        Provider.of<AppInfo>(context, listen: false).userPickUpLocation;
    // Get User destination Posiiton
    var destinationPosition =
        Provider.of<AppInfo>(context, listen: false).userDropOffLocation;
    // Origgin latlng
    var originLatLng = LatLng(
        originPosition!.locationLatitude!, originPosition.locationLongitude!);
    // destination latln
    var destinationLatLng = LatLng(destinationPosition!.locationLatitude!,
        destinationPosition.locationLongitude!);

    showDialog(
      context: context,
      builder: (context) => ProgressDialog(
        message: "Please wait...",
      ),
    );
    var directionDetailsInfo =
        await AssistantMethods.obtainOriginToDestinationDirectionDetails(
            originLatLng, destinationLatLng);
    // Assign to trip from origin to destination direction ifo to get fare amount
    setState(() {
      tripDirectionDetailInfo = directionDetailsInfo;
    });
    Navigator.of(context).pop();
    // Decode the encoded points
    PolylinePoints pPoints = PolylinePoints();
    List<PointLatLng> decodedPpointsReultList =
        pPoints.decodePolyline(directionDetailsInfo!.e_points!);
    pLineCoOrdinatesList.clear();
    if (decodedPpointsReultList.isNotEmpty) {
      decodedPpointsReultList.forEach(
        (PointLatLng pointLatLng) {
          pLineCoOrdinatesList.add(
            LatLng(pointLatLng.latitude, pointLatLng.longitude),
          );
        },
      );
    }
    polyLineSet.clear();
    setState(() {
      Polyline polyLine = Polyline(
        polylineId: const PolylineId("PolylineID"),
        color: Colors.redAccent,
        jointType: JointType.round,
        points: pLineCoOrdinatesList,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );

      polyLineSet.add(polyLine);
    });
    // Fix polyline zoom
    LatLngBounds boundsLatLng;
    if (originLatLng.latitude > destinationLatLng.latitude &&
        originLatLng.longitude > destinationLatLng.longitude) {
      boundsLatLng = LatLngBounds(
        southwest: destinationLatLng,
        northeast: originLatLng,
      );
    } else if (originLatLng.longitude > destinationLatLng.longitude) {
      boundsLatLng = LatLngBounds(
        southwest: LatLng(originLatLng.latitude, destinationLatLng.longitude),
        northeast: LatLng(destinationLatLng.latitude, originLatLng.longitude),
      );
    } else if (originLatLng.latitude > destinationLatLng.latitude) {
      boundsLatLng = LatLngBounds(
        southwest: LatLng(destinationLatLng.latitude, originLatLng.longitude),
        northeast: LatLng(originLatLng.latitude, destinationLatLng.longitude),
      );
    } else {
      boundsLatLng = LatLngBounds(
        southwest: originLatLng,
        northeast: destinationLatLng,
      );
    }
    _newGoogleMapController!
        .animateCamera(CameraUpdate.newLatLngBounds(boundsLatLng, 65));
    Marker originMarker = Marker(
      markerId: const MarkerId("originId"),
      infoWindow: InfoWindow(
        title: originPosition.locationName,
        snippet: "Origin",
      ),
      position: originLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueYellow,
      ),
    );
    Marker destinationMarker = Marker(
      markerId: const MarkerId("destinationId"),
      infoWindow: InfoWindow(
        title: destinationPosition.locationName,
        snippet: "Destination",
      ),
      position: destinationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    );
    setState(() {
      markersSet.add(originMarker);
      markersSet.add(destinationMarker);
    });
    Circle originCircle = Circle(
      circleId: const CircleId("originId"),
      fillColor: Colors.green,
      radius: 12,
      strokeWidth: 3,
      strokeColor: Colors.white,
      center: originLatLng,
    );
    Circle destinationCircle = Circle(
      circleId: const CircleId("destinationId"),
      fillColor: Colors.red,
      radius: 12,
      strokeWidth: 3,
      strokeColor: Colors.white,
      center: destinationLatLng,
    );
    setState(() {
      circleSet.add(originCircle);
      circleSet.add(destinationCircle);
    });
  }

  @override
  Widget build(BuildContext context) {
    // To Add Active Nearby Marker
    _createActiveNearbyDriverMarkerIcon();
    return Scaffold(
      key: sKey,
      drawer: Container(
        width: 265,
        child: Theme(
          data: Theme.of(context).copyWith(canvasColor: Colors.black),
          child: AppDrawer(
            name: userName,
            email: userEmail,
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
            mapType: MapType.normal,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            initialCameraPosition: _kGooglePlex,
            polylines: polyLineSet,
            markers: markersSet,
            circles: circleSet,
            onMapCreated: (GoogleMapController controller) {
              _controllerGoogleMap.complete(controller);
              _newGoogleMapController = controller;

              // Black Theme Google Map
              _blackThemeGoogleMap();

              // Making Google Map logo visible
              setState(() {
                bottomPaddingOfMap = 245;
              });

              // Get User Current Location;
              _locateUserPosition();
              setState(() {
                userName = userModelCurrentInfo!.name!;
                userEmail = userModelCurrentInfo!.email!;
              });
            },
          ),
          // Custom Hamburger button for drawer
          Positioned(
            top: 30,
            left: 14,
            child: GestureDetector(
              onTap: () {
                if (openNavigationDrawer) {
                  sKey.currentState!.openDrawer();
                } else {
                  // restart-refresh-minimize app programmatically
                  // SystemNavigator.pop();
                  MyApp.restartApp(context);
                }
              },
              child: CircleAvatar(
                backgroundColor: Colors.grey,
                child: Icon(
                  openNavigationDrawer ? Icons.menu : Icons.close,
                  color: Colors.black54,
                ),
              ),
            ),
          ),

          // UI for searching location
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedSize(
              curve: Curves.easeIn,
              duration: const Duration(milliseconds: 120),
              child: Container(
                height: searchLocationContainerHeight,
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 13,
                  ),
                  child: Column(
                    children: [
                      // From Location
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.add_location_alt_outlined,
                            color: Colors.grey,
                          ),
                          const SizedBox(
                            width: 12.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'From',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 17,
                                ),
                              ),
                              Text(
                                Provider.of<AppInfo>(context)
                                            .userPickUpLocation !=
                                        null
                                    ? (Provider.of<AppInfo>(context)
                                                .userPickUpLocation!
                                                .locationName!)
                                            .substring(0, 24) +
                                        "..."
                                    : "not getting address",
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      // Space between
                      const SizedBox(
                        height: 16,
                      ),
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.grey,
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      // To Location
                      GestureDetector(
                        onTap: () async {
                          // Search Places Screen
                          var responseFromSearchScreen =
                              await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => SearchPlacesScreen(),
                            ),
                          );
                          if (responseFromSearchScreen == "obtainedDropOff") {
                            setState(() {
                              openNavigationDrawer = false;
                            });
                            await _drawPolyLineFromOriginToDestination();
                          }
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.add_location_alt_outlined,
                              color: Colors.grey,
                            ),
                            const SizedBox(
                              width: 12.0,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'User Dropoff Location',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 17,
                                  ),
                                ),
                                Text(
                                  Provider.of<AppInfo>(context)
                                              .userDropOffLocation !=
                                          null
                                      ? Provider.of<AppInfo>(context)
                                                  .userDropOffLocation!
                                                  .locationName!
                                                  .length >
                                              24
                                          ? (Provider.of<AppInfo>(context)
                                                      .userDropOffLocation!
                                                      .locationName!)
                                                  .substring(0, 24) +
                                              '...'
                                          : Provider.of<AppInfo>(context)
                                              .userDropOffLocation!
                                              .locationName!
                                      : "Where to go!",
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      // Space between
                      const SizedBox(
                        height: 16,
                      ),
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.grey,
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      // Button
                      ElevatedButton(
                        onPressed: () {
                          // Check if User Drop-off location has been picked
                          if (Provider.of<AppInfo>(context, listen: false)
                                  .userDropOffLocation !=
                              null) {
                            // Search for rides for drivers
                            _saveRideRequestInformation();
                          } else {
                            // If it is null
                            // Display a messsage
                            Fluttertoast.showToast(
                              msg: "Please select destination location",
                            );
                          }
                        },
                        child: const Text(
                          'Request a Ride',
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
