import 'package:flutter/material.dart';


void main(){
  runApp(const MaterialApp(
    home: SafeArea(
      child: Scaffold(
          body: Center(
              child: Text("Hello World",
                style:TextStyle(
                    color: Colors.cyan,
                    fontWeight: FontWeight.bold,
                    fontSize: 30.0
                )
              )
          )
      ),
    ),
  ));

}