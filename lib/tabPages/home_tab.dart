import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:driverapp/global/global.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_geofire/flutter_geofire.dart';

import '../assist/assist_methods.dart';

class HomeTabPage extends StatefulWidget {
  const HomeTabPage({super.key});

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {

  GoogleMapController? newGoogleMapController;
  //Completer는..future랑 비슷한데..요청이 있을때까지 값을 가지고 있거나, 설정 가능하고..
  //요청할땐,containsKey로 확인하고, _controllerGoogleMap.complete(리턴값)으로 리턴한다.
  final Completer<GoogleMapController> _controllerGooleMap = Completer();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  var geoLocator = Geolocator();

  LocationPermission? _locationPermission;

  String statusText = "Now Offline";
  Color buttonColor = Colors.amber.shade400;
  bool isDriverActive = false;

  locationDriverPosition() async{
    Position cPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    driverCurrentPosition = cPosition;

    LatLng latLngPosition = LatLng(driverCurrentPosition!.latitude, driverCurrentPosition!.longitude);
    CameraPosition cameraPosition = CameraPosition(target: latLngPosition,zoom: 15);

    newGoogleMapController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    //여기서 address를 처음에 구해줌
    String humanReadbleAddress = await AssistMethods.searchAddressForGeographinCoOrdinates(driverCurrentPosition!, context);

    print("This is our address = " + humanReadbleAddress);

  }

  readCurrentDriverInformation(){
    currentUser = firebaseAuth.currentUser;

    FirebaseDatabase.instance.ref().child("driverapp").child(currentUser!.uid).once().then((snap){
      if(snap.snapshot.value!=null){
        onlineDriverData.id = (snap.snapshot.value as Map)["id"];
        onlineDriverData.name = (snap.snapshot.value as Map)["name"];
        onlineDriverData.phone = (snap.snapshot.value as Map)["phone"];
        onlineDriverData.email = (snap.snapshot.value as Map)["email"];
        //onlineDriverData.address = (snap.snapshot.value as Map)["address"];
        onlineDriverData.car_color = (snap.snapshot.value as Map)["car_details"]["car_color"];
        onlineDriverData.car_number = (snap.snapshot.value as Map)["car_details"]["car_number"];
        onlineDriverData.car_model = (snap.snapshot.value as Map)["car_details"]["car_model"];

        driverVehicleTypes = (snap.snapshot.value as Map)["car_details"]["type"];
      }
    });
  }

  checkIfLocationPermissionAllowed() async{
    _locationPermission = await Geolocator.requestPermission();

    if(_locationPermission == LocationPermission.denied){
      _locationPermission = await Geolocator.requestPermission();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkIfLocationPermissionAllowed();
    readCurrentDriverInformation();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          padding: EdgeInsets.only(top: 40),
          mapType: MapType.normal,
          myLocationEnabled: true,
          zoomGesturesEnabled: true,
          zoomControlsEnabled: true,
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controllerGooleMap.complete(controller);

            newGoogleMapController = controller;

            locationDriverPosition();
          },
        ),
        //ui online/offline 버튼구현
        statusText != "Now Online" ?
        Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            color: Colors.black87
        ) : Container(),
        Positioned(
            top: statusText != "Now Online" ? MediaQuery.of(context).size.height * 0.45 : 60,
            left: 0,
            right : 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: (){
                      if(isDriverActive != true) {
                         driverIsOnlineNow();
                         updateDriverLocationAtRealTime();
                        setState(() {
                          statusText = "Now Online";
                          isDriverActive = true;
                          //어느정도 투명하게 나타내줌.
                          buttonColor = Colors.transparent;
                        });
                      } else{
                        driverIsOfflineNow();
                        setState(() {
                          statusText = "Now Offline";
                          isDriverActive = false;
                          buttonColor = Colors.amber.shade400;
                        });
                        Fluttertoast.showToast(msg: "You are Offline Now");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      padding: EdgeInsets.symmetric(horizontal: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                      ),
                    ),
                    child: statusText!="Now Online"?
                        //offline
                        Text(statusText,
                            style: TextStyle(
                             fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54
                           )
                        ) :
                      //online
                      Icon(
                      Icons.phonelink_ring,
                      color: Colors.white,
                      size:26
                    )
                )
              ],
            )
        ),
      ],
    );
  }

  driverIsOnlineNow() async {
    Position pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    driverCurrentPosition = pos;

    //path에다가 왜 string값을 넣는건지 아직도 모름..geofire 문서 자체가 많지 않음.
    Geofire.initialize("activeDrivers");
    Geofire.setLocation(currentUser!.uid, driverCurrentPosition!.latitude, driverCurrentPosition!.longitude);

    DatabaseReference ref = FirebaseDatabase.instance.ref().child("driverapp").child(currentUser!.uid).child("newRideStatus");

    ref.set("idle");
    ref.onValue.listen((event) { });
  }

  updateDriverLocationAtRealTime(){
    //이걸로 뭘한단건진 모르겠지만 나중가면 알게 되겠죠?
    streamSubscriptionPosition = Geolocator.getPositionStream().listen((Position position) {
      if(isDriverActive == true){
        Geofire.setLocation(currentUser!.uid,driverCurrentPosition!.latitude,driverCurrentPosition!.longitude);
      }

      LatLng latLng = LatLng(driverCurrentPosition!.latitude,driverCurrentPosition!.longitude);

      newGoogleMapController!.animateCamera(CameraUpdate.newLatLng(latLng));
    });
  }

  driverIsOfflineNow(){
    Geofire.removeLocation(currentUser!.uid);

    DatabaseReference? ref = FirebaseDatabase.instance.ref().child("driverapp").child(currentUser!.uid).child("newRideStatus");

    ref.onDisconnect();
    ref.remove();
    ref = null;

    //Flutter에서는 SystemChannels.platform을 사용하여 네이티브 기능을 호출할 수 있습니다.
    //이 경우에는 "platform" 채널을 통해 invokeMethod를 호출하고,
    //"SystemNavigator.pop"을 인자로 전달하여 앱 종료 동작을 수행합니다.
    /*Future.delayed(Duration(milliseconds: 2000),() {
      SystemChannels.platform.invokeMethod("SystemNavigator.pop");
    },);*/
  }
}
