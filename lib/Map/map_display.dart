
import 'dart:async';
import 'dart:convert';
import 'package:app_car_booking/Global/global_var.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {

  final Completer<GoogleMapController> googleMapCompleter = Completer<GoogleMapController>();
  GoogleMapController? controllerGoogleMap;

  updateThemeMap(GoogleMapController controller){
    getDataFromJson("themes/map_theme_night.json").then((value) => setStyleMap(controller, value));
  }


  Future<String> getDataFromJson(String path) async{
    ByteData byteData = await rootBundle.load(path);
    var list = byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
    return utf8.decode(list);
  }

  setStyleMap(GoogleMapController controller,String dataMapStyle){
    controller.setMapStyle(dataMapStyle);
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            myLocationEnabled: true,
            initialCameraPosition: googleInitPos,
            onMapCreated: (GoogleMapController mapController){
              controllerGoogleMap = mapController;
              updateThemeMap(controllerGoogleMap!);
              googleMapCompleter.complete(controllerGoogleMap);
            },
          )
        ],
      ),
    );
  }


}