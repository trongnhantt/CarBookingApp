import 'dart:ui';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';


class CommonMethods{
  checkConnectivity(BuildContext context) async{
    var connectionResult = await Connectivity().checkConnectivity();
    if(connectionResult != ConnectivityResult.mobile && connectionResult != ConnectivityResult.wifi){
      if(!context.mounted) return;
      DisplayBox(context, "Oh No !!!! ", "Connection errors!! Please check the connection",ContentType.warning);
    }
  }


  DisplaySnackBar(String message,BuildContext context){
    var snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  DisplayBox(BuildContext context,String titleOfBox, String messageOfBox, ContentType contentTypeOfBox){
    /*final snackBar = SnackBar(
      /// need to set following properties for best effect of awesome_snackbar_content
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: titleOfBox,
        message: messageOfBox,
        /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
        contentType: contentTypeOfBox,
      ),
    );
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);*/





    /*final materialBanner = MaterialBanner(
      elevation: 0,
      backgroundColor: Colors.transparent,
      forceActionsBelow: false,
      content: AwesomeSnackbarContent(
        title: titleOfBox,
        message: messageOfBox,
        contentType: contentTypeOfBox,
        // to configure for material banner
        inMaterialBanner: true,
      ),
      actions: const [SizedBox.shrink()],
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentMaterialBanner()
      ..showMaterialBanner(materialBanner);*/

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
    Future.delayed(Duration(seconds: 2), () {
      ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
    });
  }

}