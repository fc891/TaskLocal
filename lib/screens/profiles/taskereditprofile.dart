// ignore_for_file: prefer_const_constructor

//Contributors: Bill

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tasklocal/Screens/profiles/taskerprofilepage.dart';
import 'package:tasklocal/screens/profiles/taskinfo.dart';
import 'package:tasklocal/screens/profiles/pickimage.dart';
import 'package:tasklocal/screens/profiles/profilepageglobals.dart' as globals;

//Bill's edit profile screen/UI (for Tasker)
class TaskerEditProfile extends StatefulWidget {
  const TaskerEditProfile({super.key});
  @override
  State<TaskerEditProfile> createState() => _TaskerEditProfileState();
}

//Customer profile edit screen
class _TaskerEditProfileState extends State<TaskerEditProfile> {
  var fnameController = TextEditingController();
  var lnameController = TextEditingController();
  var usernameController = TextEditingController();
  var emailController = TextEditingController();
  String profilePictureURL =
      "https://firebasestorage.googleapis.com/v0/b/authtutorial-a4202.appspot.com/o/profilepictures%2Ftasklocaltransparent.png?alt=media&token=31e20dcc-4b9a-41cb-85ed-bc82166ac836";

  bool _setProfilePicture = false;
  final dB = FirebaseStorage.instance;

  Uint8List? _image;

  //Prompt user to select image from device gallery
  void selectImage() async {
    //Pick image from device and convert to Uint8List type
    Uint8List image = await pickImage(ImageSource.gallery);
    setState(() {
      _image = image;
      _setProfilePicture = true;
    });
  }

  //Save the selected image from selectImage() function to the database
  void setImage() async {
    var current = FirebaseAuth.instance.currentUser!;
    var currentemail = current.email;

    // Create a storage reference from our app
    final storageRef = FirebaseStorage.instance.ref();
    // Create a reference to "profilepicture.jpg"
    final profileRef = storageRef.child("profilepictures/$currentemail/profilepicture.jpg");
    // Create a reference to 'images/profilepicture.jpg'
    final profileImageRef = storageRef.child("images/$currentemail/profilepicture.jpg");
    // While the file names are the same, the references point to different files
    assert(profileRef.name == profileImageRef.name);
    assert(profileRef.fullPath != profileImageRef.fullPath);
    //Insert to Firebase storage
    await profileRef.putData(_image!);

    globals.checkProfilePictureTasker =
        true; //Set to true so that the new profile picture is displayed on the profile page after changes are confirmed
  }

  //Get the profile picture link of the current user
  void getProfilePicture(String id) async {
    final ref = dB.ref().child("profilepictures/$id/profilepicture.jpg");
    final url = await ref.getDownloadURL(); //Convert profile picture from Firebase storage to link
    setState(() {
      profilePictureURL = url; //Update profilePictureURL field so that it contains the link to Firebase where the profile picture is located
    });
  }

  //Confirms all changes made by the user
  void confirmChanges() async {
    var current = FirebaseAuth.instance.currentUser!;

    var collection = FirebaseFirestore.instance.collection('Taskers');
    var docSnapshot = await collection.doc(current.email!).get();
    Map<String, dynamic> data = docSnapshot.data()!;

    var newUserName = data['username'];
    var newFirstName = data['first name'];
    var newLastName = data['last name'];

    final currentDB = FirebaseFirestore.instance
        .collection("Taskers")
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

      setImage();
      getProfilePicture(current.email!);

      //Update the current user based on entered information
      transaction.update(currentDB, {
        "username": newUserName,
        "first name": newFirstName,
        "last name": newLastName,
        "profile picture": profilePictureURL,
      });
    }).then(
      (value) => print("DocumentSnapshot successfully updated!"),
      onError: (e) => print("Error updating document $e"),
    );
  }

//Bill's Tasker edit profile screen/UI code
  @override
  Widget build(BuildContext context) {
    var current = FirebaseAuth.instance.currentUser!;
    getProfilePicture(current.email!);
    return Scaffold(
        //Background color of UI
        //backgroundColor: Colors.green[500],
        //UI Appbar (bar at top of screen)
        appBar: AppBar(
          title: Text('Edit Tasker Profile Page'),
          centerTitle: true,
          //backgroundColor: Colors.green[800],
          elevation: 0.0,
        ),
        //Tasker profile picture
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 30, bottom: 20),
            ),
            Center(
                child: Stack(
              children: <Widget>[
                Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                        border: Border.all(
                          width: 4,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                        boxShadow: [
                          BoxShadow(
                              spreadRadius: 2,
                              blurRadius: 10,
                              color: Theme.of(context).colorScheme.secondary)
                        ],
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: _setProfilePicture
                              ? MemoryImage(
                                  _image!) //If user has selected an image from their gallery, display it
                              : NetworkImage(
                                      profilePictureURL) //If user has NOT selected an image from their gallery, display their original profile picture
                                  as ImageProvider,
                          fit: BoxFit.cover,
                        ))),
                //Select image button (next to the profile picture itself)
                Positioned(
                    bottom: 0.0,
                    right: 0.0,
                    child: Container(
                        height: 40.0,
                        width: 40.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(width: 1, color: Theme.of(context).colorScheme.secondary),
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                        child: IconButton(
                          icon: Icon(Icons.edit, color: Theme.of(context).colorScheme.secondary),
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
            //Confirm changes button
            ElevatedButton(
              onPressed: () {
                confirmChanges();
                Navigator.pop(context);
              },
              child: Text("Confirm Changes", style: TextStyle(color: Colors.black)),
            ),
          ],
        )));
  }
}
