


class AddressModel{
  String? addressHumman;
  double? latPosition;
  double? longPosition;



  AddressModel(String address, double lat, double long){
    this.addressHumman = address;
    this.latPosition = lat;
    this.longPosition = long;
  }
}