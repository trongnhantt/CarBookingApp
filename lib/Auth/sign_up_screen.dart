import 'package:flutter/material.dart';



class ScreenSignUp extends StatefulWidget {
  const ScreenSignUp({super.key});
  @override
  State<ScreenSignUp> createState() => _ScreenSignUpState();
}

class _ScreenSignUpState extends State<ScreenSignUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Image.asset(
                "assets/images/001 logo.png"
              ),
            ],
          ),
        ),
      ),
    );
  }
}

