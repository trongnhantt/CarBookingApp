import 'dart:convert';
import 'dart:ui';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;


class CommonMethods{
  checkConnectivity(BuildContext context) async{
    var connectionResult = await Connectivity().checkConnectivity();
    /*if(connectionResult != ConnectivityResult.mobile && connectionResult != ConnectivityResult.wifi){
      if(context.mounted) return;
      DisplayBox(context, "Oh No !!!! ", "Connection errors!! Please check the connection",ContentType.warning);
    }*/
  }


  DisplaySnackBar(String message,BuildContext context){
    var snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  DisplayBox(BuildContext context,String titleOfBox, String messageOfBox, ContentType contentTypeOfBox){
    final materialBanner = MaterialBanner(
      elevation: 0,
      backgroundColor: Colors.transparent,
      forceActionsBelow: false,
      content: AwesomeSnackbarContent(
        title: titleOfBox,
        message: messageOfBox,
        contentType: contentTypeOfBox,
        inMaterialBanner: true,
      ),
      actions: const [SizedBox.shrink()],
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentMaterialBanner()
      ..showMaterialBanner(materialBanner);
    Future.delayed(Duration(seconds: 3), () {
      ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
    });
  }

  String extractContent(String inputString) {
    int startIndex = inputString.indexOf("[");
    int endIndex = inputString.indexOf("]");

    if (startIndex != -1 && endIndex != -1 && endIndex > startIndex) {
      return inputString.substring(endIndex + 1).trim();
    } else return "";
  }

  static sendRequestAPI(String apiUrl) async{
    http.Response reponseFromApi = await http.get(Uri.parse(apiUrl));
    try
    {
      if(reponseFromApi.statusCode == 200){
        String jsonData = reponseFromApi.body;
        var dataDecode = jsonDecode(jsonData);
        return dataDecode;
      }else{
        return "Error";
      }
    }
    catch(errMsg)
    {
      return "Error";
    }
  }


}