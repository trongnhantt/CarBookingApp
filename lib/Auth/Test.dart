import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import '../Methods/common_methods.dart';
import '../Pages/page_home.dart';
import '../Widgets/loading_dialog.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late Color myColor;
  late Size mediaSize;
  bool rememberUser = false;

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
    /*showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context)=>LoadingDialog(messageText: "Allowing you to login ...")
    );
    final User? userFirebase = (
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailEditText.text.trim(),
            password: passwordEditText.text.trim()
        ).catchError((erroMsg){
          commonMethods.DisplayBox(context, "Error !!! ", "Login failed", ContentType.failure);
        })
    ).user;
    if(!context.mounted) return;
    Navigator.pop(context);
    if(userFirebase != null){
      DatabaseReference userRefDatabase = FirebaseDatabase.instance.ref().child("users").child(userFirebase.uid);
      userRefDatabase.once().then((snap){
        if(snap.snapshot.value != null){
          if((snap.snapshot.value as Map)["blockedStatus"] == "no"){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
          }
          else
          {
            FirebaseAuth.instance.signOut();
            commonMethods.DisplayBox(context, "Error", "This account is blocked. Contact with admin", ContentType.failure);
          }
        }
        else{
          commonMethods.DisplayBox(context, "Ooops", "Account not exists !!!!", ContentType.warning);
        }
      });
    }*/
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => LoadingDialog(messageText: "Allowing you to login ..."),
    );

    bool loginSuccess = false; // Thêm biến boolean này

    try {
      final User? userFirebase = (await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailEditText.text.trim(),
        password: passwordEditText.text.trim(),
      )).user;

      loginSuccess = true; // Đánh dấu đăng nhập thành công

      if (userFirebase != null) {
        DatabaseReference userRefDatabase = FirebaseDatabase.instance.ref().child("users").child(userFirebase.uid);
        userRefDatabase.once().then((snap) {
          if (snap.snapshot.value != null) {
            if ((snap.snapshot.value as Map)["blockedStatus"] == "no") {
              Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
            } else {
              FirebaseAuth.instance.signOut();
              commonMethods.DisplayBox(context, "Error", "This account is blocked. Contact with admin", ContentType.failure);
            }
          } else {
            commonMethods.DisplayBox(context, "Ooops", "Account not exists !!!!", ContentType.warning);
          }
        });
      }
    } catch (error) {
      // Đăng nhập thất bại
      commonMethods.DisplayBox(context, "Error !!! ", "Login failed", ContentType.failure);
    }
    if (!context.mounted) return;
    if (!loginSuccess) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    myColor = Colors.purpleAccent;
    mediaSize = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
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
            size: 100,
            color: Colors.white,
          ),
          Text(
            "MOVE EASE",
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
        const Text(
          "Welcome",
          style: TextStyle(
              color: Colors.purpleAccent, fontSize: 32, fontWeight: FontWeight.w500),
        ),
        _buildGreyText("Please login with your information"),
        const SizedBox(height: 60),
        _buildGreyText("Email address"),
        _buildInputField(emailEditText),
        const SizedBox(height: 40),
        _buildGreyText("Password"),
        _buildInputField(passwordEditText, isPassword: true),
        const SizedBox(height: 20),
        _buildRememberForgot(),
        const SizedBox(height: 20),
        _buildLoginButton(),
        const SizedBox(height: 20),
        _buildOtherLogin(),
      ],
    );
  }

  Widget _buildGreyText(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.grey),
    );
  }

  Widget _buildInputField(TextEditingController controller,
      {isPassword = false}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        suffixIcon: isPassword ? Icon(Icons.remove_red_eye) : Icon(Icons.email),
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

  Widget _buildLoginButton() {
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
      child: const Text("LOGIN"),
    );
  }

  Widget _buildOtherLogin() {
    return Center(
      child: Column(
        children: [
          _buildGreyText("Or Login with"),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Tab(icon: Image.asset("assets/images/facebook.png")),
              Tab(icon: Image.asset("assets/images/twitter.png")),
              Tab(icon: Image.asset("assets/images/github.png")),
            ],
          )
        ],
      ),
    );
  }
}