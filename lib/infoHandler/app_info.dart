
import 'package:flutter/cupertino.dart';

import '../model/directions.dart';

class AppInfo extends ChangeNotifier{
  Directions? userPickUpLocation,userDropOffLocation;
  int countTotalTrips = 0;


  void updatePickUpLocationAddress(Directions userPickUpAddress){
    userPickUpLocation = userPickUpAddress;
    notifyListeners();
  }

  void updateDropOffLocationAddress(Directions userDropOffAddress){
    userDropOffLocation = userDropOffAddress;
    notifyListeners();
  }
}