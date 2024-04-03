


import 'package:app_car_booking/Models/AddressModel.dart';
import 'package:flutter/cupertino.dart';

class AppInfor extends ChangeNotifier{
  AddressModel? pickUpAddress;
  AddressModel? dropOffAddress;


  void updatePickUpAddress(AddressModel pickUpAddress){
    this.pickUpAddress = pickUpAddress;
    notifyListeners();
  }


  void updateDropOffAddress(AddressModel dropOffAddress){
    this.dropOffAddress = dropOffAddress;
    notifyListeners();
  }

}