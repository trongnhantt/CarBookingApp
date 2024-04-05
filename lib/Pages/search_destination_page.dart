
import 'package:app_car_booking/AppInfor/app_info.dart';
import 'package:app_car_booking/Methods/common_methods.dart';
import 'package:app_car_booking/Models/prediction_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Models/prediction_place_ui.dart';


class SearchDestinationPage extends StatefulWidget {
  const SearchDestinationPage({super.key});

  @override
  State<SearchDestinationPage> createState() => _SearchDestinationPageState();
}

class _SearchDestinationPageState extends State<SearchDestinationPage> {
  TextEditingController pickUpTextEditingController = TextEditingController();
  TextEditingController destinationTextEditingController = TextEditingController();
  List<Map<String,dynamic>> locationListDisplay = [];


  searchLocation(String locationName) async {
    if (locationName.length > 1) {
      // Get Api from url
      String urlApi = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$locationName&key=AIzaSyDuDxriw8CH8NbVLiXtKFQ2Nb64AoRSdyg&components=country:vn";
      var responseFromPlaceApi = await CommonMethods.sendRequestAPI(urlApi) ?? {};
      if (responseFromPlaceApi == "Error") return;


      // Process Data if API response
      if(responseFromPlaceApi["status"] == "OK"){
        List<dynamic> predictions =[];
        List<Map<String,dynamic>> locations = [];
        predictions = responseFromPlaceApi["predictions"] ?? {};
        for(var prediction in predictions ){
          Map<String,dynamic> location = {
            "description" : prediction["description"],
            "place_id" : prediction["place_id"],
            "structured_formatting" : prediction["structured_formatting"],
          };
          locations.add(location);
        }
        setState(() {
          locationListDisplay = locations;
        });
        print(locationListDisplay);
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    String address = Provider
        .of<AppInfor>(context, listen: false)
        .pickUpAddress!
        .addressHumman ?? "";
    pickUpTextEditingController.text = address;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              elevation: 10,
              child: Container(
                height: 230,
                decoration: const BoxDecoration(
                  color: Colors.black12,
                  boxShadow:
                  [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5.0,
                      spreadRadius: 0.5,
                      offset: Offset(0.7, 0.7),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 24, top: 48, right: 24, bottom: 20),
                  child: Column(
                    children: [

                      const SizedBox(height: 6,),

                      //icon button - title
                      Stack(
                        children: [

                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              Icons.arrow_back, color: Colors.white,),
                          ),

                          const Center(
                            child: Text(
                              "Set Dropoff Location",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                        ],
                      ),

                      const SizedBox(height: 18,),

                      //pickup text field
                      Row(
                        children: [

                          Image.asset(
                            "assets/images/initial.png",
                            height: 16,
                            width: 16,
                          ),

                          const SizedBox(width: 18,),

                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(3),
                                child: TextField(
                                  controller: pickUpTextEditingController,
                                  decoration: const InputDecoration(
                                      hintText: "Pickup Address",
                                      fillColor: Colors.white12,
                                      filled: true,
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding: EdgeInsets.only(
                                          left: 11, top: 9, bottom: 9)
                                  ),
                                ),
                              ),
                            ),
                          ),

                        ],
                      ),

                      const SizedBox(height: 11,),

                      //destination text field
                      Row(
                        children: [

                          Image.asset(
                            "assets/images/final.png",
                            height: 16,
                            width: 16,
                          ),

                          const SizedBox(width: 18,),

                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(3),
                                child: TextField(
                                  controller: destinationTextEditingController,
                                  onChanged: (inpuText){
                                    searchLocation(inpuText);
                                  },
                                  decoration: const InputDecoration(
                                      hintText: "Destination Address",
                                      fillColor: Colors.white12,
                                      filled: true,
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding: EdgeInsets.only(
                                          left: 11, top: 9, bottom: 9)
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            //display prediction results for destination place
            (locationListDisplay.length > 0)
                ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListView.separated(
                padding: const EdgeInsets.all(0),
                itemBuilder: (context, index)
                {
                  return Card(
                    elevation: 3,
                    child: PredictionPlaceUI(
                      predictionData : locationListDisplay[index],
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 2,),
                itemCount: locationListDisplay.length,
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
              ),
            )
                : Container(),
            /*SizedBox(
              height: 400, // Adjust the height as per your requirement
              child: ListView.builder(
                itemCount: locationListDisplay.length,
                itemBuilder: (context, index) {
                  final location = locationListDisplay[index];
                  return ListTile(
                    title: Text(location["description"]),
                    onTap: () {
                      print('Bạn đã chọn mục có thứ tự index là: $index');
                      destinationTextEditingController.text =  locationListDisplay[index]["description"].toString();
                      },
                  );
                },
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}
