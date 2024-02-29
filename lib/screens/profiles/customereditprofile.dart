// ignore_for_file: prefer_const_constructor

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tasklocal/Screens/profiles/customerprofilepage.dart';
import 'package:tasklocal/screens/profiles/taskinfo.dart';
import 'package:tasklocal/screens/profiles/pickimage.dart';

class CustomerEditProfile extends StatefulWidget {
  const CustomerEditProfile({super.key});
  @override
  State<CustomerEditProfile> createState() => _CustomerEditProfileState();
}

//Customer profile edit screen
class _CustomerEditProfileState extends State<CustomerEditProfile> {
  var fnameController = TextEditingController();
  var lnameController = TextEditingController();
  var usernameController = TextEditingController();
  var emailController = TextEditingController();

  Uint8List? _image;

  //WIP: Controllers to edit password
  // var passwordController = TextEditingController();
  // var confirmPasswordController = TextEditingController();
  // bool _obscurePassword = true;
  // bool _obscureConfirmPassword = true;

  void confirmChanges() async {
    var current = FirebaseAuth.instance.currentUser!;

    var collection = FirebaseFirestore.instance.collection('Customers');
    var docSnapshot = await collection.doc(current.email!).get();
    Map<String, dynamic> data = docSnapshot.data()!;

    var newUserName = data['username'];
    var newFirstName = data['first name'];
    var newLastName = data['last name'];

    final currentDB = FirebaseFirestore.instance
        .collection("Customers")
        .doc("${current.email}");
    FirebaseFirestore.instance.runTransaction((transaction) async {
      //Changing values based on user entry. If empty, do not change (keep same)
      if (usernameController.text.isNotEmpty) {
        newUserName = usernameController.text;
      }
      if (fnameController.text.isNotEmpty) {
        newFirstName = fnameController.text;
      }
      if (lnameController.text.isNotEmpty) {
        newLastName = lnameController.text;
      }

      //Update the current user based on entered information
      transaction.update(currentDB, {
        "username": newUserName,
        "first name": newFirstName,
        "last name": newLastName,
        "profile picture":
            'https://firebasestorage.googleapis.com/v0/b/authtutorial-a4202.appspot.com/o/asaur.png?alt=media&token=29af6d0f-4385-4afa-a460-43b8ab1fa312',
      });
    }).then(
      (value) => print("DocumentSnapshot successfully updated!"),
      onError: (e) => print("Error updating document $e"),
    );
  }

  void selectImage() async {
    
    //Pick image from device and convert to Uint8List type
    Uint8List image = await pickImage(ImageSource.gallery);
    setState(() {
      _image = image;
    });

    var current = FirebaseAuth.instance.currentUser!;
    var currentemail = current.email;
    // Create a storage reference from our app
    final storageRef = FirebaseStorage.instance.ref();
    // Create a reference to "profilepicture.jpg"
    final profileRef = storageRef.child("{$currentemail}profilepicture.jpg");
    // Create a reference to 'images/profilepicture.jpg'
    final profileImageRef = storageRef.child("images/{$currentemail}profilepicture.jpg");
    // While the file names are the same, the references point to different files
    assert(profileRef.name == profileImageRef.name);
    assert(profileRef.fullPath != profileImageRef.fullPath);
    //Insert to Firebase storage
    await profileRef.putData(_image!);
  }

//Bill's Customer edit profile screen/UI code
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //Background color of UI
        backgroundColor: Colors.green[500],
        //UI Appbar (bar at top of screen)
        appBar: AppBar(
          title: Text('Edit Customer Profile Page'),
          centerTitle: true,
          backgroundColor: Colors.green[800],
          elevation: 0.0,
        ),
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 30, bottom: 20),
            ),
            //Customer profile picture
            Center(
                child: Stack(
              children: <Widget>[
                Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                        border: Border.all(
                          width: 4,
                          color: Colors.white,
                        ),
                        boxShadow: [
                          BoxShadow(
                              spreadRadius: 2,
                              blurRadius: 10,
                              color: Colors.grey)
                        ],
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                              'https://firebasestorage.googleapis.com/v0/b/authtutorial-a4202.appspot.com/o/asaur.png?alt=media&token=29af6d0f-4385-4afa-a460-43b8ab1fa312'),
                        ))),
                Positioned(
                    bottom: 0.0,
                    right: 0.0,
                    child: Container(
                        height: 40.0,
                        width: 40.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(width: 1, color: Colors.white),
                          color: Colors.white,
                        ),
                        child: IconButton(
                          icon: Icon(Icons.edit, color: Colors.grey),
                          onPressed: () {
                            selectImage();
                          },
                        ))),
              ],
            )),
            //First name entry field
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 37, vertical: 10),
              child: SizedBox(
                width: 400,
                child: TextField(
                  controller: fnameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[250],
                    labelText: "First Name",
                  ),
                ),
              ),
            ),
            //Last name entry field
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 37, vertical: 10),
              child: SizedBox(
                width: 400,
                child: TextField(
                  controller: lnameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[250],
                    labelText: "Last Name",
                  ),
                ),
              ),
            ),
            //Username entry field
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 37, vertical: 10),
              child: SizedBox(
                width: 400,
                child: TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[250],
                    labelText: "Username",
                  ),
                ),
              ),
            ),
            // //Email entry field
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 37, vertical: 10),
            //   child: SizedBox(
            //     width: 400,
            //     child: TextField(
            //       controller: emailController,
            //       decoration: InputDecoration(
            //         border: OutlineInputBorder(),
            //         filled: true,
            //         fillColor: Colors.grey[250],
            //         labelText: "Email Address",
            //       ),
            //     ),
            //   ),
            // ),
            // //Password entry field
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 37, vertical: 10),
            //   child: SizedBox(
            //     width: 400,
            //     child: TextField(
            //       obscureText: _obscurePassword,
            //       controller: passwordController,
            //       decoration: InputDecoration(
            //         border: OutlineInputBorder(),
            //         filled: true,
            //         fillColor: Colors.grey[250],
            //         labelText: "Password",
            //         suffixIcon: IconButton(
            //           icon: Icon(
            //             _obscurePassword
            //                 ? Icons.visibility
            //                 : Icons.visibility_off,
            //             color: Colors.grey[500],
            //           ),
            //           onPressed: () {
            //             setState(() {
            //               _obscurePassword = !_obscurePassword;
            //             });
            //           },
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            // //CONFIRM Password entry field
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 37, vertical: 10),
            //   child: SizedBox(
            //     width: 400,
            //     child: TextField(
            //       obscureText: _obscureConfirmPassword,
            //       controller: confirmPasswordController,
            //       decoration: InputDecoration(
            //         border: OutlineInputBorder(),
            //         filled: true,
            //         fillColor: Colors.grey[250],
            //         labelText: "Confirm Password",
            //         suffixIcon: IconButton(
            //           icon: Icon(
            //             _obscureConfirmPassword
            //                 ? Icons.visibility
            //                 : Icons.visibility_off,
            //             color: Colors.grey[500],
            //           ),
            //           onPressed: () {
            //             setState(() {
            //               _obscureConfirmPassword = !_obscureConfirmPassword;
            //             });
            //           },
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            //Register account button
            ElevatedButton(
              onPressed: () {
                confirmChanges();
                Navigator.pop(context);
              },
              child: const Text("Confirm Changes"),
            ),
          ],
        )));
  }
}
