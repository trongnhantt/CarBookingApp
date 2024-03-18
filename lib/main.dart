import 'package:app_car_booking/Auth/Test.dart';
import 'package:app_car_booking/Auth/login_screen.dart';
import 'package:app_car_booking/Auth/sign_up_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';




Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{

  const MyApp({super.key});
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: const ScreenLogin(),
      title: "Fluter App",
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black
      ),
      debugShowCheckedModeBanner: false,
    );
  }

}




