
import 'dart:async';
import 'package:app_car_booking/Global/global_var.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {

  final Completer<GoogleMapController> googleMapCompleter = Completer<GoogleMapController>();
  GoogleMapController? controllerGoogleMap;
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
              googleMapCompleter.complete(controllerGoogleMap);
            },
          )
        ],
      ),
    );
  }


}