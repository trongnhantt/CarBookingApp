
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:app_car_booking/Auth/login_screen.dart';
import 'package:app_car_booking/Methods/common_methods.dart';
import 'package:app_car_booking/Pages/search_destination_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../AppInfor/app_info.dart';
import '../Global/global_var.dart';
import '../Models/prediction_place_ui.dart';



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
  double serachContainerHeight = 276;



  TextEditingController pickUpTextEditingController = TextEditingController();
  TextEditingController destinationTextEditingController = TextEditingController();
  List<Map<String,dynamic>> locationListDisplay = [];




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
    await CommonMethods.convertGeoGraphicsIntoAddress(currentPosOfUser!, context);
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


    const BorderRadiusGeometry radius = BorderRadius.only(
      topLeft: Radius.circular(24.0),
      topRight: Radius.circular(24.0),
    );

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



         SlidingUpPanel(
            panel:  Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start, // Đẩy biểu tượng lên phía trên
                children: [
                  Container(
                    child: Center(
                      child: Container(
                        margin: const EdgeInsets.only(top:10),
                        height: 5,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey,
                        ),

                      ),
                    ),
                  ),
                  const SizedBox(height: 4.0,),
                   SafeArea(
                    top: false,
                    child: Column(
                      children: [
                        const Text(
                            "Set your destination",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 20,
                            ),
                        ),
                        const SizedBox(height: 4.0,),
                        const Text(
                          "Type and pick from suggestion",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        const Divider(height: 30,color: Colors.grey,),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Column(
                                children: [
                                  Container(
                                    height: 8.0,
                                    width: 8.0,
                                    margin: const EdgeInsets.all(2.0),
                                    decoration: const BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  Container(
                                    height: 40.0,
                                    width: 2.0,
                                    decoration: const BoxDecoration(
                                      color: Colors.green,
                                    ),
                                  ),
                                  Container(
                                    height: 8.0,
                                    width: 8.0,
                                    margin: const EdgeInsets.all(2.0),
                                    decoration: const BoxDecoration(color: Colors.green,),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 20.0),
                                child: Column(
                                  children: [
                                    TextFormField(
                                      readOnly: true,
                                      controller: pickUpTextEditingController,
                                      decoration: const InputDecoration(
                                        isDense: true,
                                        prefixIcon: Icon(Icons.search),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                    TextFormField(
                                      onChanged: (inpuText){

                                      },
                                      controller: destinationTextEditingController,
                                      decoration: const InputDecoration(
                                        isDense: true,
                                        prefixIcon: Icon(Icons.search),
                                        hintText: "Where go ?",
                                        hintStyle: TextStyle(color: Colors.greenAccent),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5.0),
                        Container(
                          height: 200,
                          child: ListView.builder(
                            itemCount: 5,
                            padding: EdgeInsets.only(right: 10),
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                leading: const Icon(Icons.location_on),
                                title: Text("Index $index"),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Index address $index"),
                                    Container(
                                      height: 1,
                                      margin: const EdgeInsets.only(top: 8.0),
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 15.0,),
                        Container(
                          child: Center(
                            child: Container(
                              margin: const EdgeInsets.only(top:10),
                              height: 20,
                              width: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey,
                              ),

                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

             collapsed: Container(
               decoration: const BoxDecoration(
                 color: Colors.white,
                 borderRadius: radius,
               ),
               child:  Column(
                 mainAxisAlignment: MainAxisAlignment.start, // Đẩy biểu tượng lên phía trên
                 children: [
                   Container(
                     child: Center(
                       child: Container(
                         margin: const EdgeInsets.only(top:10),
                         height: 10,
                         width: 50,
                         decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(10),
                           color: Colors.grey,
                         ),

                       ),
                     ),
                   ),
                 ],
               ),
             ),
            borderRadius: radius,
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
            top: 40,
            left: 350,
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
                  radius: 20,
                  child: Icon(
                    Icons.my_location,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ),
          /*Positioned(
              left: 0,
              right: 0,
              bottom: -80,
              child: Container(
                height: serachContainerHeight,
                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children:
                  [
                    ElevatedButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (c)=>SearchDestinationPage()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(24),
                        ),
                        child: const Icon(
                          Icons.search_rounded,
                          color: Colors.white,
                          size: 25,
                        ),
                    ),
                    ElevatedButton(
                      onPressed: (){

                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(24),
                      ),
                      child: const Icon(
                        Icons.home,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: (){

                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(24),
                      ),
                      child: const Icon(
                        Icons.work,
                        color: Colors.white,
                        size: 25,
                      ),
                    )
                  ],
                ),
              ),
          ),*/
        ],
      ),

      // Draw Buttun
    );



  }


}


