import 'package:app_car_booking/Auth/sign_up_screen.dart';
import 'package:flutter/material.dart';




void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{

  const MyApp({super.key});
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: const ScreenSignUp(),
      title: "Fluter App",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),

      ),
    );
  }

}




