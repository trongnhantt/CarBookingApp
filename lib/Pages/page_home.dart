
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:app_car_booking/Auth/login_screen.dart';
import 'package:app_car_booking/Methods/common_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../Global/global_var.dart';



class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {

  final Completer<GoogleMapController> googleMapCompleter = Completer<GoogleMapController>();
  CommonMethods commonMethods = new CommonMethods();
  GlobalKey<ScaffoldState> sKey = GlobalKey<ScaffoldState>();
  GoogleMapController? controllerGoogleMap;
  Position? currentPosOfUser;

  get floatingActionButton => null;


  void updateMapTheme(GoogleMapController controller)
  {
    getJsonFileFromThemes("themes/map_theme_night.json").then((value)=> setGoogleMapStyle(value, controller));
  }

  Future<String> getJsonFileFromThemes(String mapStylePath) async
  {
    ByteData byteData = await rootBundle.load(mapStylePath);
    var list = byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
    return utf8.decode(list);
  }

  setGoogleMapStyle(String googleMapStyle, GoogleMapController controller)
  {
    controller.setMapStyle(googleMapStyle);
  }


  getCurrentPositionUser() async{
    Position posCurrentUsr = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPosOfUser = posCurrentUsr;
    LatLng latLngUser = LatLng(currentPosOfUser!.latitude, currentPosOfUser!.longitude);
    CameraPosition cameraPosition = CameraPosition(target: latLngUser, zoom: 15);
    controllerGoogleMap!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    await getStatusOfUser();
  }


  getStatusOfUser() async{
    DatabaseReference usrRef = FirebaseDatabase.instance.ref()
        .child("users")
        .child(FirebaseAuth.instance.currentUser!.uid);
    await usrRef.once().then((snap) {
      if(snap.snapshot.value != null){
        if((snap.snapshot.value as Map)["blockedStatus"] == "no"){
          setState(() {
            userName = (snap.snapshot.value as Map)["name"];
          });
        }
        else{
          FirebaseAuth.instance.signOut();
          Navigator.push(context, MaterialPageRoute(builder: (c)=> LoginPage()));
          commonMethods.DisplayBox(context, "Error", "This account is blocked. Contact with admin", ContentType.failure);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      key: sKey,
      drawer: Container(
        width: 255,
        color: Colors.black87,
        child: Drawer(
          backgroundColor: Colors.white10,
          child: ListView(
            children: [

              const Divider(
                height: 1,
                color: Colors.grey,
                thickness: 1,
              ),

              //header
              Container(
                color: Colors.black54,
                height: 160,
                child: DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Colors.white10,
                  ),
                  child: Row(
                    children: [

                      Image.asset(
                        "assets/images/avatarman.png",
                        width: 60,
                        height: 60,
                      ),

                      const SizedBox(width: 16,),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          Text(
                            userName,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 4,),

                          const Text(
                            "Profile",
                            style: TextStyle(
                              color: Colors.white38,
                            ),
                          ),

                        ],
                      ),

                    ],
                  ),
                ),
              ),

              const Divider(
                height: 1,
                color: Colors.grey,
                thickness: 1,
              ),

              const SizedBox(height: 10,),

              //body
              ListTile(
                leading: IconButton(
                  onPressed: (){},
                  icon: const Icon(Icons.info, color: Colors.grey,),
                ),
                title: const Text("About", style: TextStyle(color: Colors.grey),),
              ),

              GestureDetector(

                // Button Logout feature
                onTap: ()
                {
                  FirebaseAuth.instance.signOut();
                  Navigator.push(context, MaterialPageRoute(builder: (c)=> LoginPage()));
                },
                child: ListTile(
                  leading: IconButton(
                    onPressed: (){},
                    icon: const Icon(Icons.logout, color: Colors.grey,),
                  ),
                  title: const Text("Logout", style: TextStyle(color: Colors.grey),),
                ),
              ),

            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(

            mapType: MapType.normal,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            initialCameraPosition: googleInitPos,
            zoomControlsEnabled: false,
            onMapCreated: (GoogleMapController mapController){
              controllerGoogleMap = mapController;
              googleMapCompleter.complete(controllerGoogleMap);
              updateMapTheme(controllerGoogleMap!);
              getCurrentPositionUser();
            },
          ),
          // Draw button
          Positioned(
            top: 36,
            left: 19,
            child: GestureDetector(
              onTap: ()
              {
                sKey.currentState!.openDrawer();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const
                  [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5,
                      spreadRadius: 0.5,
                      offset: Offset(0.7, 0.7),
                    ),
                  ],
                ),
                child: const CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 20,
                  child: Icon(
                    Icons.menu,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 780,
            left: 340,
            child: GestureDetector(
              onTap: ()
              {
                getCurrentPositionUser();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const
                  [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5,
                      spreadRadius: 0.5,
                      offset: Offset(0.7, 0.7),
                    ),
                  ],
                ),
                child: const CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 30,
                  child: Icon(
                    Icons.access_time_outlined,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ),
        ],


      ),

      // Draw Buttun


    );
  }




}


