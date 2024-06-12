import 'package:flutter/material.dart';

class TripPage extends StatefulWidget {
  const TripPage({super.key});

  @override
  State<TripPage> createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
            child: Text(
              "TripsPage",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            )
        )
    );
  }
}
