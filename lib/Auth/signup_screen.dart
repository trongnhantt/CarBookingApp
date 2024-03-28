import 'dart:io';
import 'package:app_car_booking/Auth/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../Methods/common_methods.dart';
import '../Pages/page_home.dart';
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

    DatabaseReference userRef = FirebaseDatabase.instance.ref().child("users").child(userFirebase!.uid);

    Map userDataMap = {
      "email": emailEditText.text.trim(),
      "name" : usernameEditText.text.trim(),
      "phone": phoneEditText.text.trim(),
      "password" : passwordEditText.text.trim(),
      "blockedStatus" : "no",
    };
    userRef.set(userDataMap);
    commonMethods.DisplayBox(context, "Congratulations", "Registered successfully", ContentType.success);
    Navigator.push(context, MaterialPageRoute(builder: (c)=>LoginPage()));
  }
  bool rememberUser = false;

  @override
  Widget build(BuildContext context) {
    myColor = Colors.purpleAccent;
    mediaSize = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        color:  Colors.transparent,
        image: DecorationImage(
          image: const AssetImage("assets/images/bg.png"),
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
        children: [
          Icon(
            Icons.location_on_sharp,
            size: 90,
            color: Colors.white,
          ),
          Text(
            "MOVE  EASE",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 30,
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
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
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
        /*Text(
          "Welcome",
          style: TextStyle(
              color: myColor, fontSize: 30, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 20),*/

        _buildGreyText("Email address"),
        _buildInputField(emailEditText,Icons.email),
        const SizedBox(height: 15),

        _buildGreyText("Username"),
        _buildInputField(usernameEditText,Icons.account_circle),
        const SizedBox(height: 15),


        _buildGreyText("Phone number"),
        _buildInputField(phoneEditText,Icons.phone),
        const SizedBox(height: 15),

        _buildGreyText("Password"),
        _buildInputField(passwordEditText,Icons.remove_red_eye, isPassword: true),
        const SizedBox(height: 15),

        _buildGreyText("Conform password"),
        _buildInputField(confirmPwdEditText,Icons.remove_red_eye, isPassword: true),
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

  Widget _buildInputField(TextEditingController controller,IconData icon ,
      {isPassword = false}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        suffixIcon: isPassword ? Icon(Icons.remove_red_eye) : Icon(icon),
      ),
      obscureText: isPassword,
    );
  }

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
        shadowColor: myColor,
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
                  child: _buildColorText("Log in now !!! ",Colors.purpleAccent),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}