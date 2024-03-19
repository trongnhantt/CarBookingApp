import 'package:app_car_booking/Auth/sign_up_screen.dart';
import 'package:app_car_booking/Methods/common_methods.dart';
import 'package:app_car_booking/Pages/page_home.dart';
import 'package:app_car_booking/Widgets/loading_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class ScreenLogin extends StatefulWidget {
  const ScreenLogin({super.key});

  @override
  State<ScreenLogin> createState() => _ScreenLoginState();
}

class _ScreenLoginState extends State<ScreenLogin> {
  TextEditingController emailEditText = TextEditingController();
  TextEditingController usernameEditText = TextEditingController();
  TextEditingController passwordEditText = TextEditingController();
  CommonMethods commonMethods = new CommonMethods();

  checkIfNetworkIsAvailable(){
    commonMethods.checkConnectivity(context);
    checkFormatLogin();
  }


  checkFormatLogin(){

    if(emailEditText.text.isEmpty ||
        passwordEditText.text.isEmpty)
    {
      commonMethods.DisplayBox(context, "Warning !!", "Information cannot be left blank", ContentType.warning);
      return;
    }
    if(!emailEditText.text.trim().contains("@")){
      commonMethods.DisplayBox(context, "Ooops !!", "Please write email format", ContentType.failure);
      emailEditText.text = "";
    }
    else{
      signInUser();
    }
  }

  signInUser() async{
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context)=>LoadingDialog(messageText: "Allowing you to login ...")
    );
    /*final User? userFirebase = (
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailEditText.text.trim(),
          password: passwordEditText.text.trim()
      ).catchError((erroMsg){
        commonMethods.DisplayBox(context, "Error !!! ", "Login failed", ContentType.failure);
      })
    ).user;
    if(!context.mounted) return;
    Navigator.pop(context);*/

    try{
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: emailEditText.text.trim(),
              password: passwordEditText.text.trim(),
          );

      if(!context.mounted) return;
      Navigator.pop(context);
      if(FirebaseAuth.instance.currentUser != null){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
      }
      else
      {
        // Sign In fail
        commonMethods.DisplayBox(context, "Failed !!! ", "Login failed", ContentType.failure,);
      }
    }
    catch (errorMsg){
      // Dismiss the loading dialog
      Navigator.pop(context);
      // Display error message to user
      commonMethods.DisplayBox(
        context,
        "Error !!! ",
        "Login failed: $errorMsg",
        ContentType.failure,
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: Column(
            children: [
              Image.asset(
                "assets/images/logo.png",
                width: 400,
                height: 400,
              ),
              const Text(
                "Login",
                style: TextStyle(
                  fontSize: 26.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    TextField(
                      controller: emailEditText,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: "Enter your Email",
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue, width: 2.0),
                        ),
                        prefixIcon: Icon(Icons.mail),
                      ),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 15.0,
                      ),
                    ),
                    const SizedBox(height: 7,),
                    TextField(
                      controller: passwordEditText,
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        hintText: "Enter your password",
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue,width: 2.0),
                        ),
                        prefixIcon: Icon(Icons.password),
                      ),
                      style: const TextStyle(
                          fontSize: 15.0,
                          color: Colors.grey
                      ),
                    ),
                    const SizedBox(height: 150,),
                    // Button Sign up
                    ElevatedButton(
                      onPressed: () {
                        checkFormatLogin();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Text(
                        "Login",
                      ),
                    ),
                    // Text Button transition Login screen
                    TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (c) => ScreenSignUp()));
                      },
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                            // Màu sẽ thay đổi khi TextButton được nhấn
                            if (states.contains(MaterialState.pressed)) {
                              return Colors.purple; // Màu khi nhấn vào
                            }
                            return Colors.grey; // Màu mặc định
                          },
                        ),
                      ),
                      child: const Text(
                        "Do not have an account ? Register now",
                        style: TextStyle(
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
