/*
import 'package:flutter/material.dart';


import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MyWidget extends StatelessWidget {
  final TextEditingController pickUpTextEditingController = TextEditingController();
  final TextEditingController destinationTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final BorderRadiusGeometry radius = BorderRadius.only(topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0));

    return Scaffold(
      body: SlidingUpPanel(
        panel: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.only(top:10),
                    height: 5,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4.0,),
              SafeArea(
                top: false,
                child: Column(
                  children: [
                    const Text(
                      "Set your destination",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 4.0,),
                    const Text(
                      "Type and pick from suggestion",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    const Divider(height: 30,color: Colors.grey,),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Column(
                            children: [
                              Container(
                                height: 8.0,
                                width: 8.0,
                                margin: const EdgeInsets.all(2.0),
                                decoration: const BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Container(
                                height: 40.0,
                                width: 2.0,
                                decoration: const BoxDecoration(
                                  color: Colors.green,
                                ),
                              ),
                              Container(
                                height: 8.0,
                                width: 8.0,
                                margin: const EdgeInsets.all(2.0),
                                decoration: const BoxDecoration(color: Colors.green,),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 20.0),
                            child: Column(
                              children: [
                                TextFormField(
                                  readOnly: true,
                                  controller: pickUpTextEditingController,
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    prefixIcon: Icon(Icons.search),
                                    border: InputBorder.none,
                                  ),
                                ),
                                TextFormField(
                                  onChanged: (inpuText){

                                  },
                                  controller: destinationTextEditingController,
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    prefixIcon: Icon(Icons.search),
                                    hintText: "Where go ?",
                                    border: InputBorder.none,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    // List of suggestions
                    Container(
                      height: MediaQuery.of(context).size.height * 0.5, // Adjust height as needed
                      child: ListView.builder(
                        itemCount: 1,
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: const Icon(Icons.location_on),
                            title: Text("Index select is $index"),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Index Address is $index"),
                                Container(
                                  height: 1,
                                  margin: const EdgeInsets.only(top:8.0),
                                  color: Colors.black,
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        collapsed: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: radius,
          ),
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.only(top:10),
                    height: 10,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        borderRadius: radius,
      ),
    );
  }
}
*/
