


import 'package:flutter/material.dart';



class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Row(
          children: [
            Text(
                "Page_Home",
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.cyan,
                ),
            )
          ],
        ),
      ),
    );
  }
}
