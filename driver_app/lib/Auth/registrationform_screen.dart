import 'dart:io';
import 'package:driver_app/Auth/signup_screen.dart';
import 'package:driver_app/Methods/common_methods.dart';
import 'package:driver_app/Widgets/loading_dialog.dart';
import 'package:driver_app/pages/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';



class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  TextEditingController carModelEditText = TextEditingController();
  TextEditingController carColorEditText = TextEditingController();
  TextEditingController carNumberEditText = TextEditingController();
  CommonMethods cMethods = CommonMethods();
  XFile? imageFile;
  String urlOfUploadedImage = "";

  checkIfNetworkIsAvailable()
  {
    cMethods.checkConnectivity(context);

    if(imageFile != null) //image validation
        {
      registerInfo();
    }
    else
    {
      cMethods.DisplayBox(context,"Warning !!","Please choose image first.", ContentType.warning);
      return;
    }
  }
  registerInfo() {

    if (carColorEditText.text.isEmpty ||
        carModelEditText.text.isEmpty ||
        carNumberEditText.text.isEmpty)
    {
      cMethods.DisplayBox(
          context, "Warning !!", "Information cannot be left blank",
          ContentType.warning);
      return;
    }
    else
    {
      uploadImageToStorage();
    }
  }

  uploadImageToStorage() async
  {
    String imageIDName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference referenceImage = FirebaseStorage.instance.ref().child("Images").child(imageIDName);

    UploadTask uploadTask = referenceImage.putFile(File(imageFile!.path));
    TaskSnapshot snapshot = await uploadTask;
    urlOfUploadedImage = await snapshot.ref.getDownloadURL();

    setState(() {
      urlOfUploadedImage;
    });

    updateInfo();
  }

  updateInfo() async
  {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => LoadingDialog(messageText: "Update information..."),
    );

    String userId = FirebaseAuth.instance.currentUser!.uid;

    if(!context.mounted) return;
    Navigator.pop(context);

    DatabaseReference usersRef = FirebaseDatabase.instance.ref().child("drivers").child(userId);

    Map driverCarInfo = {
      "carModel": carModelEditText.text.trim(),
      "carColor": carColorEditText.text.trim(),
      "carNumber": carNumberEditText.text.trim(),
    };

    Map<String, Object> driverData = {
      "photo": urlOfUploadedImage,
      "car_details": driverCarInfo,
    };

    usersRef.update(driverData).then((_)
    {
      cMethods.DisplayBox(context, "Success", "Information updated", ContentType.success);
    }).catchError((error)
        {
          cMethods.DisplayBox(context, "Error", "Failed to update information: $error", ContentType.failure);
        });

    Navigator.push(context, MaterialPageRoute(builder: (c)=> Dashboard()));

  }

  chooseImageFromGallery() async
  {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if(pickedFile != null)
    {
      setState(() {
        imageFile = pickedFile;
      });
    }
  }

  Widget _buildInputField(TextEditingController controller, String label) {
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
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: label,
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none,
        ),
      ),
    );
  }

  final List<String> options_Model = ['Audi', 'Mercedes'];
  final List<String> options_Color = ['White', 'Black'];

  Widget _buildDropDownField(String label, String? selectedValue, List<String> options, Function(String?) onChanged)
  {
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
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: DropdownButton<String>(
        value: selectedValue,
        isExpanded: true,
        underline: Container(),
        icon: Icon(Icons.arrow_drop_down),
        items: options.map((item) => DropdownMenuItem(
          value: item,
          child: Text(
            item,
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
        ))
            .toList(),
        onChanged: onChanged,
        hint: Text(label, style: TextStyle(color: Colors.grey)),
        style: TextStyle(color: Colors.black),
        dropdownColor: Colors.white,
      ),
    );
  }

  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [

                  const SizedBox(height: 40,),

                  imageFile == null ?
                  const CircleAvatar(
                    radius: 86,
                    backgroundImage: AssetImage("assets/images/avatarman.png"),
                  ) : Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey,
                        image: DecorationImage(
                            fit: BoxFit.fitHeight,
                            image: FileImage(
                              File(
                                imageFile!.path,
                              ),
                            )
                        )
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  GestureDetector(
                    onTap: ()
                    {
                      chooseImageFromGallery();
                    },
                    child: const Text(
                      "Choose Image",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.lightBlue,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32,),

                  _buildDropDownField('Car Model', selectedValue, options_Model, (newValue) {
                    setState(() {
                      selectedValue = newValue;
                    });
                  }),
                  const SizedBox(height: 22,),
                  
                  _buildDropDownField('Car Color', selectedValue, options_Color, (newValue) {
                    setState(() {
                      selectedValue = newValue;
                    });
                  }),
                  const SizedBox(height: 22,),

                  _buildInputField(carNumberEditText, "Car Number"),
                  const SizedBox(height: 22,),

                  ElevatedButton(
                    onPressed: ()
                    {
                      checkIfNetworkIsAvailable();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 20)
                    ),
                    child: const Text(
                        "SAVE"
                    ),
                  ),
                ],
              ),
        ),
      ),
    );
  }
}

