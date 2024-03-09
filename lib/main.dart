import 'package:flutter/material.dart';


/*void main(){
  // Hello World Programing
  // Push Test
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

}*/


void main(){
  runApp(MaterialApp(
    home: SafeArea(
      child: Scaffold(
          body: Center(
              child: MyWiget(true)
          )
      ),
    ),
  ));
}

class MyWiget extends StatelessWidget{
  final bool loading;
  MyWiget(this.loading);
  @override
  Widget build(BuildContext context) {
    return loading ? const CircularProgressIndicator() : const Text("loading is false");
  }

}

