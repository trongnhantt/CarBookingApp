import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../Global/global_var.dart';
import '../Methods/common_methods.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final Completer<GoogleMapController> googleMapCompleter = Completer<GoogleMapController>();
  CommonMethods commonMethods = new CommonMethods();
  GlobalKey<ScaffoldState> sKey = GlobalKey<ScaffoldState>();
  GoogleMapController? controllerGoogleMap;
  Position? currentPosOfUser;
  double searchContainerHeight = 276;

  void updateMapTheme(GoogleMapController controller) {
    getJsonFileFromThemes("themes/map_theme_night.json").then((value)=> setGoogleMapStyle(value, controller));
  }

  Future<String> getJsonFileFromThemes(String mapStylePath) async {
    ByteData byteData = await rootBundle.load(mapStylePath);
    var list = byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
    return utf8.decode(list);
  }

  setGoogleMapStyle(String googleMapStyle, GoogleMapController controller) {
    controller.setMapStyle(googleMapStyle);
  }

  getLiveLocationOfDriver() async{
    Position posCurrentUsr = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPosOfUser = posCurrentUsr;
    LatLng latLngUser = LatLng(currentPosOfUser!.latitude, currentPosOfUser!.longitude);
    CameraPosition cameraPosition = CameraPosition(target: latLngUser, zoom: 15);
    controllerGoogleMap!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    await CommonMethods.convertGeoGraphicsIntoAddress(currentPosOfUser!, context);
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Stack(
        children: [

        GoogleMap(
        mapType: MapType.normal,
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        initialCameraPosition: googleInitPos,
        zoomControlsEnabled: false,
        onMapCreated: (GoogleMapController mapController)
        {
          controllerGoogleMap = mapController;
          googleMapCompleter.complete(controllerGoogleMap);
          updateMapTheme(controllerGoogleMap!);
          getLiveLocationOfDriver();
        },
      ),
      ],
      ),
    );
  }
}
