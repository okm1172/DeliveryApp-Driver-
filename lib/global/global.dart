import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

import '../model/direction_details_info.dart';
import '../model/driver_data.dart';
import '../model/user_model.dart';
import 'package:geolocator/geolocator.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
User? currentUser;

StreamSubscription<Position>? streamSubscriptionPosition;
StreamSubscription<Position>? streamSubscriptionDriverLivePosition;

Position? driverCurrentPosition;

UserModel? userModelCurrentInfo;
DirectionDetailsInfo? tripDirectionDetailsInfo;
String userDropOffAddress = "";

DriverData onlineDriverData = DriverData();

String? driverVehicleTypes = "";