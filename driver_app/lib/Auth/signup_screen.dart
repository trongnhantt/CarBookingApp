import 'dart:io';
import 'package:driver_app/Auth/login_screen.dart';
import 'package:driver_app/Auth/registrationform_screen.dart';
import 'package:driver_app/pages/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../Methods/common_methods.dart';
import '../Widgets/loading_dialog.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';


class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPage();
}

class _SignUpPage extends State<SignUpPage> {
  late Color myColor;
  late Size mediaSize;
  // Init edit text for user
  TextEditingController emailEditText = TextEditingController();
  TextEditingController phoneEditText = TextEditingController();
  TextEditingController usernameEditText = TextEditingController();
  TextEditingController passwordEditText = TextEditingController();
  TextEditingController confirmPwdEditText = TextEditingController();
  CommonMethods commonMethods = CommonMethods();

  checkIfNetworkIsAvailable(){
    checkFormatSignUp();
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
    }else{
      regristerNewUser();
    }
  }


  regristerNewUser() async{
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => LoadingDialog(messageText: "Registering your account ....."),
    );

    // Add user in firebase
    final User? userFirebase = (
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailEditText.text.trim(),
            password: passwordEditText.text.trim()
        ).catchError((errMsg){
          Navigator.pop(context);
          String msgError  = commonMethods.extractContent(errMsg.toString());
          commonMethods.DisplayBox(context, "Error !!!!", msgError, ContentType.failure);
        })
    ).user;
    if(!context.mounted) return;
    Navigator.pop(context);

    DatabaseReference userRef = FirebaseDatabase.instance.ref().child("drivers").child(userFirebase!.uid);

    Map driverCarInfo = {
      "carModel": "",
      "carColor": "",
      "carNumber": "",
    };

    Map DriverDataMap = {

      "email": emailEditText.text.trim(),
      "name" : usernameEditText.text.trim(),
      "phone": phoneEditText.text.trim(),
      "password" : passwordEditText.text.trim(),
      "blockedStatus" : "no",
    };

    userRef.set(DriverDataMap);
    commonMethods.DisplayBox(context, "Congratulations", "Registered successfully", ContentType.success);
    Navigator.push(context, MaterialPageRoute(builder: (c)=>RegistrationPage()));
  }
  bool rememberUser = false;

  @override
  Widget build(BuildContext context) {
    myColor = Colors.green;
    mediaSize = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        image: DecorationImage(
          image: const AssetImage("assets/images/uberexec.png"),
          fit: BoxFit.cover,
          colorFilter:
          ColorFilter.mode(myColor.withOpacity(0.2), BlendMode.dstATop),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(children: [
          Positioned(top: 80, child: _buildTop()),
          Positioned(bottom: 0, child: _buildBottom()),
        ]),
      ),
    );
  }

  Widget _buildTop() {
    return SizedBox(
      width: mediaSize.width,
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "EASY MOVE",
            style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 30,
                fontFamily: 'Hokjesgeest',
                letterSpacing: 2),
          )
        ],
      ),
    );
  }

  Widget _buildBottom() {
    return SizedBox(
      width: mediaSize.width,
      child: Card(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            )),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: _buildForm(),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Driver With EASY MOVE",
          style: TextStyle(
              color: Colors.white, fontSize: 23, fontWeight: FontWeight.w400),
        ),
        const SizedBox(height: 20),

        //_buildGreyText("Email"),
        _buildInputField(emailEditText,"Email",Icons.email),
        const SizedBox(height: 15),

        //_buildGreyText("Username"),
        _buildInputField(usernameEditText,"Username",Icons.account_circle),
        const SizedBox(height: 15),


        //_buildGreyText("Phone number"),
        _buildInputField(phoneEditText,"Phone number",Icons.phone),
        const SizedBox(height: 15),

        //_buildGreyText("Password"),
        _buildInputField(passwordEditText,"Password",Icons.remove_red_eye, isPassword: true),
        const SizedBox(height: 15),

        //_buildGreyText("Conform password"),
        _buildInputField(confirmPwdEditText,"Conform password",Icons.remove_red_eye, isPassword: true),
        const SizedBox(height: 20),

        _buildSignUpButton(),
        const SizedBox(height: 25),
        _transittionLogin(),
      ],
    );
  }

  Widget _buildGreyText(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.grey),
    );
  }

  Widget _buildColorText(String text,Color c) {
    return Text(
      text,
      style:  TextStyle(
        color: c,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildInputField(TextEditingController controller, String label, IconData icon, {bool isPassword = false}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: label,
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none,
          suffixIcon: Icon(icon, color: Colors.grey,),
        ),
      ),
    );
  }


  // Widget _buildInputField(TextEditingController controller,IconData icon ,
  //     {isPassword = false}) {
  //   return TextField(
  //     controller: controller,
  //     decoration: InputDecoration(
  //       suffixIcon: isPassword ? Icon(Icons.remove_red_eye) : Icon(icon),
  //     ),
  //     obscureText: isPassword,
  //   );
  // }

  Widget _buildRememberForgot() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(
                value: rememberUser,
                onChanged: (value) {
                  setState(() {
                    rememberUser = value!;
                  });
                }),
            _buildGreyText("Remember me"),
          ],
        ),
        TextButton(
            onPressed: () {}, child: _buildGreyText("I forgot my password"))
      ],
    );
  }

  Widget _buildSignUpButton() {
    return ElevatedButton(
      onPressed: () {
        checkIfNetworkIsAvailable();
      },
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        elevation: 20,
        backgroundColor: Colors.green,
        minimumSize: const Size.fromHeight(60),
      ),
      child: const Text("SIGN UP"),
    );
  }

  Widget _transittionLogin() {
    return Center(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: _buildGreyText("Already have an account."),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (c)=>LoginPage()));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: _buildColorText("Log in now !!! ",Colors.green),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}