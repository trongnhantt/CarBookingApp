import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class ScreenSignUp extends StatefulWidget {
  const ScreenSignUp({super.key});
  @override
  State<ScreenSignUp> createState() => _ScreenSignUpState();
}

class _ScreenSignUpState extends State<ScreenSignUp> {

  // Init edit text for user
  TextEditingController emailEditText = TextEditingController();
  TextEditingController usernameEditText = TextEditingController();
  TextEditingController passwordEditText = TextEditingController();
  TextEditingController confirmPwdEditText = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: Column(
            children: [
              Image.asset(
                "assets/images/logo.png"
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
                      )
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

