import 'package:driver_app/Auth/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'firebase_options.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Permission.locationWhenInUse.isDenied.then((valuePermission){
    if(valuePermission){
      Permission.locationWhenInUse.request();
    }
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{

  const MyApp({super.key});

  @override

  Widget build(BuildContext context)
  {
    return  MaterialApp(

        home: FirebaseAuth.instance.currentUser == null ? LoginPage() : LoginPage(),
        title: "Flutter App",
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Colors.black
        ),
        debugShowCheckedModeBanner: false,
    );
  }

}




