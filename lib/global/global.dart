import 'package:firebase_auth/firebase_auth.dart';
import 'package:users_app/models/user_model.dart';

import '../models/direction_details_info.dart';

final FirebaseAuth fAuth = FirebaseAuth.instance;
User? currentFirebaseUser;
UserModel? userModelCurrentInfo;
// Drivers Key Info list
List dList = [];

// Store Trip Direction Detail Info
DirectionDetailsInfo? tripDirectionDetailInfo;

// Store Choosen Driver ID
String choosenDriverId = "";

// Initialize UserDropOFfAddress for Notification
String userDropOffAddress = "";
//To Display on AssignedDriverContainer
String driverCarDetails = "";
String driverName = "";
String driverPhone = "";
// Rating Assigned Driver
double countRatingStar = 0.0;
String titleStarRating = "";
