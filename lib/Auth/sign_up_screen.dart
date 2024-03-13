
import 'package:app_car_booking/Auth/login_screen.dart';
import 'package:app_car_booking/Methods/common_methods.dart';
import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';



class ScreenSignUp extends StatefulWidget {
  const ScreenSignUp({super.key});
  @override
  State<ScreenSignUp> createState() => _ScreenSignUpState();
}

class _ScreenSignUpState extends State<ScreenSignUp> {

  // Init edit text for user
  TextEditingController emailEditText = TextEditingController();
  TextEditingController phoneEditText = TextEditingController();
  TextEditingController usernameEditText = TextEditingController();
  TextEditingController passwordEditText = TextEditingController();
  TextEditingController confirmPwdEditText = TextEditingController();
  CommonMethods commonMethods = CommonMethods();

  checkIfNetworkIsAvailable(){
    commonMethods.checkConnectivity(context);
  }


  checkFormatSignUp(){

    if(usernameEditText.text.isEmpty ||
        emailEditText.text.isEmpty ||
        usernameEditText.text.isEmpty ||
        phoneEditText.text.isEmpty ||
        passwordEditText.text.isEmpty||
        confirmPwdEditText.text.isEmpty)
    {
      commonMethods.DisplayBox(context, "Warning !!", "Information cannot be left blank", ContentType.warning);
      return;
    }
    if(usernameEditText.text.trim().length < 3){
      commonMethods.DisplayBox(context, "Ooops !!", "Your name must be longer than 4 characters", ContentType.failure);
      usernameEditText.text = "";
    }
    else if(!emailEditText.text.contains("@")){
      commonMethods.DisplayBox(context, "Ooops !!", "Please write email format", ContentType.failure);
    }
    else if(phoneEditText.text.trim().length<7){
      commonMethods.DisplayBox(context, "Ooops !!", "Phone number must be more than 8 digits", ContentType.failure);
    }
    else if(int.tryParse(phoneEditText.text) == null){
      commonMethods.DisplayBox(context, "Ooops !!", "Please write phone number format", ContentType.failure);
    }
    else if(passwordEditText.text.trim().toString() != confirmPwdEditText.text.trim().toString()){
      commonMethods.DisplayBox(context, "Ooops !!", "Confirm password are not match", ContentType.failure);
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
                width: 270.0,
                height: 270.0,
              ),
              const Text(
                "Create a User\'s Account",
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
                          labelText: "Email",
                          labelStyle: TextStyle(
                            fontSize: 14.0,
                          ),
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
                        controller: phoneEditText,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Phone number",
                          labelStyle: TextStyle(
                            fontSize: 14.0
                          ),
                          hintText: "Enter your name",
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue,width: 2.0),
                          ),
                          prefixIcon: Icon(Icons.phone),
                        ),
                        style: const TextStyle(
                            fontSize: 15.0,
                            color: Colors.grey
                        ),
                      ),
                      const SizedBox(height: 7,),
                      TextField(
                        controller: usernameEditText,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          labelText: "User name",
                          labelStyle: TextStyle(
                            fontSize: 14.0,
                          ),
                          hintText: "Enter your name",
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue,width: 2.0),
                          ),
                          prefixIcon: Icon(Icons.person),
                        ),
                        style: const TextStyle(
                          fontSize: 15.0,
                          color: Colors.grey
                        ),
                      ),
                      const SizedBox(height: 7,),
                      TextField(
                        controller: passwordEditText,
                        obscureText: true,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          labelText: "Password",
                          labelStyle: TextStyle(
                            fontSize: 14.0,
                          ),
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
                      const SizedBox(height: 7,),
                      TextField(
                        controller: confirmPwdEditText,
                        obscureText: true,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          labelText: "Confirm password",
                          labelStyle: TextStyle(
                            fontSize: 14.0
                          ),
                          hintText: "Enter confirm password",
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue,width: 2.0)
                          ),
                          prefixIcon: Icon(Icons.password),
                        ),
                        style: const TextStyle(
                          fontSize: 15.0,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 20,),
                      // Button Sign up
                      ElevatedButton(
                        onPressed: () {
                          checkIfNetworkIsAvailable();
                          checkFormatSignUp();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: const Text(
                          "Sign Up",
                        ),
                      ),
                      // Text Button transition Login screen
                      TextButton(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder:(c) => ScreenLogin()));
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
                            "Do you have an account ??? Login now",
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.grey,
                            ),
                          )
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

