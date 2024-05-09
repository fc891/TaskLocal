// ignore_for_file: prefer_const_constructor

//Contributors: Bill

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tasklocal/Screens/app_theme/appthemecustomization.dart';
import 'package:tasklocal/screens/gps_services/current_location.dart';
import 'package:tasklocal/screens/gps_services/marker_info.dart';
import 'package:tasklocal/screens/profiles/taskereditprofile.dart';
import 'package:tasklocal/screens/profiles/customereditprofile.dart';
import 'package:tasklocal/screens/profiles/taskinfo.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tasklocal/screens/profiles/profilepageglobals.dart' as globals;
//import 'package:tasklocal/supportpage/profiles/supportpage.dart';

FirebaseAuth firebaseAuth = FirebaseAuth.instance;

//Bill's Settings Page Screen
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, required this.userType});
  final String userType;
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

//Bill's Settings Page Screen
class _SettingsPageState extends State<SettingsPage> {
  String username = "TaskLocalUser";
  String firstname = "First";
  String lastname = "Last";
  final dB = FirebaseStorage.instance;
  String defaultProfilePictureURL =
      "https://firebasestorage.googleapis.com/v0/b/authtutorial-a4202.appspot.com/o/profilepictures%2Ftasklocaltransparent.png?alt=media&token=31e20dcc-4b9a-41cb-85ed-bc82166ac836";
  late String profilePictureURL;
  bool _hasProfilePicture = false;
  bool runOnce = true;

  //Bill's get user's info using testid (email right now)
  void getUserInfo(String testid) async {
    var collection = FirebaseFirestore.instance.collection(widget.userType);
    var docSnapshot = await collection.doc(testid).get();
    Map<String, dynamic> data = docSnapshot.data()!;
    setState(() {
      username = data['username'];
      firstname = data['first name'];
      lastname = data['last name'];
    });
  }

  //Bill's get user's profile picture using id
  void getProfilePicture(String id) async {
    try {
      final ref = dB.ref().child("profilepictures/$id/profilepicture.jpg");
      final url = await ref.getDownloadURL();
      setState(() {
        profilePictureURL = url;
      });
      _hasProfilePicture = true;
      globals.checkProfilePictureTasker =
          false; //Set to false after one check so that this function does not run multiple times
    } catch (err) {
      _hasProfilePicture = false;
      globals.checkProfilePictureTasker =
          false; //Set to false after one check so that this function does not run multiple times
    }
  }

  //Bill's function to run all getters above to initialize variables
  void runGetters() async {
    var current = FirebaseAuth.instance
        .currentUser!; //Use to get the info of the currently logged in user
    String testid = current.email!; //Get email of current user
    if (globals.checkProfilePictureTasker) {
      getProfilePicture(testid);
    }
    getUserInfo(testid);
  }

  //Bill's Settings Screen
  @override
  Widget build(BuildContext context) {
    if (runOnce) {
      globals.checkProfilePictureTasker =
          true; //Check once in case user has a profile page set but did not set a new one
      globals.checkMedia = true;
      runOnce = false;
    }
    runGetters(); //Run all getter functions
    return Scaffold(
        //Background color of UI
        //backgroundColor: Colors.green[500],
        //UI Appbar (bar at top of screen)
        appBar: AppBar(
          title: Text("${widget.userType} Settings Page"),
          centerTitle: true,
          //backgroundColor: Colors.green[800],
          elevation: 0.0,
        ),
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
            child: Column(children: [
          ListTile(
              leading: Container(
                  width: 50,
                  height: 100,
                  decoration: BoxDecoration(
                      border: Border.all(
                        width: 2,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                      boxShadow: [
                        BoxShadow(
                            spreadRadius: 1,
                            blurRadius: 10,
                            color: Theme.of(context).colorScheme.secondary)
                      ],
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: _hasProfilePicture
                            ? NetworkImage(
                                profilePictureURL) //If user has selected an image from their gallery, display it
                            : NetworkImage(
                                    defaultProfilePictureURL) //If user has NOT selected an image from their gallery, display their original profile picture
                                as ImageProvider,
                        fit: BoxFit.cover,
                      ))),
              title: Text(firstname + " " + lastname,
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Theme.of(context).colorScheme.secondary)),
              subtitle: Text("@" + username,
                  style: TextStyle(
                      fontSize: 14.0,
                      color: Theme.of(context).colorScheme.secondary)),
              trailing: Text("")),
          //Divider (line)
          // Divider(
          //   height: 10.0,
          //   color: Colors.grey[1500],
          // ),
          Padding(
              padding: EdgeInsets.all(0.0),
              child: Column(children: [
                Text("Settings",
                    style: TextStyle(
                        fontSize: 30.0,
                        color: Theme.of(context).colorScheme.secondary))
              ])),
          // Divider(
          //   height: 10.0,
          //   color: Colors.grey[1500],
          // ),
          //Tiles that represent each scrollable entry on the settings page, change onTap() function to redirect to different pages
          ListTile(
            leading: Icon(
              Icons.edit_outlined,
              color: Theme.of(context).colorScheme.secondary,
            ),
            //Manage account button (manage display name, username, etc.)
            title: Text("Manage Account",
                style: TextStyle(
                    fontSize: 16.0,
                    color: Theme.of(context).colorScheme.secondary)),
            subtitle: Text("Modify account details",
                style: TextStyle(
                    fontSize: 12.0,
                    color: Theme.of(context).colorScheme.secondary)),
            trailing: Text(""),
            onTap: () {
              if (widget.userType == "Taskers") {
                //If current user is type tasker, lead to tasker edit profile page
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TaskerEditProfile()));
              } else if (widget.userType == "Customers") {
                //If current user is type customer, lead to customer edit profile page
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CustomerEditProfile()));
              }
            },
          ),
          //Manage app theme (dark/classic mode)
          ListTile(
            leading: Icon(
              Icons.sunny_snowing,
              color: Theme.of(context).colorScheme.secondary,
            ),
            title: Text("Customize App Theme",
                style: TextStyle(
                    fontSize: 16.0,
                    color: Theme.of(context).colorScheme.secondary)),
            subtitle: Text("Change the appearance of the app",
                style: TextStyle(
                    fontSize: 12.0,
                    color: Theme.of(context).colorScheme.secondary)),
            trailing: Text(""),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          AppThemeCustomization()));
            },
          ),
          //show Map view (temp)
          ListTile(
            leading: Icon(
              Icons.location_pin,
              color: Theme.of(context).colorScheme.secondary,
            ),
            title: Text("Map View",
                style: TextStyle(
                    fontSize: 16.0,
                    color: Theme.of(context).colorScheme.secondary)),
            subtitle: Text("Map View for Users",
                style: TextStyle(
                    fontSize: 12.0,
                    color: Theme.of(context).colorScheme.secondary)),
            trailing: Text(""),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CurrentLocation(
                          userType: widget
                              .userType)));
            },
          ),
          //Manage notifications (turn on/off)
          ListTile(
            leading: Icon(
              Icons.contact_support,
              color: Theme.of(context).colorScheme.secondary,
            ),
            title: Text("Support Page",
                style: TextStyle(
                    fontSize: 16.0,
                    color: Theme.of(context).colorScheme.secondary)),
            subtitle: Text("Contact support",
                style: TextStyle(
                    fontSize: 12.0,
                    color: Theme.of(context).colorScheme.secondary)),
            trailing: Text("",
                style: TextStyle(
                    fontSize: 8.0,
                    color: Theme.of(context).colorScheme.secondary)),
            // onTap: () {
            //   Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //           builder: (context) => SupportPage())); //Replace with actual screen name
            // },
          ),
        ])));
  }
}
