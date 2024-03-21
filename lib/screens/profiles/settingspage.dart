// ignore_for_file: prefer_const_constructor

//Contributors: Bill

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tasklocal/screens/profiles/taskereditprofile.dart';
import 'package:tasklocal/screens/profiles/taskinfo.dart';
import 'package:firebase_storage/firebase_storage.dart';

FirebaseAuth firebaseAuth = FirebaseAuth.instance;

//Bill's Settings Page Screen
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

//Bill's Settings Page Screen
class _SettingsPageState extends State<SettingsPage> {
  final dB = FirebaseStorage.instance;
  String defaultProfilePictureURL =
      "https://firebasestorage.googleapis.com/v0/b/authtutorial-a4202.appspot.com/o/profilepictures%2Ftasklocaltransparent.png?alt=media&token=31e20dcc-4b9a-41cb-85ed-bc82166ac836";
  late String profilePictureURL;
  bool _hasProfilePicture = false;
  //Bill's Settings Screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //Background color of UI
        backgroundColor: Colors.green[500],
        //UI Appbar (bar at top of screen)
        appBar: AppBar(
          title: Text('Settings'),
          centerTitle: true,
          backgroundColor: Colors.green[800],
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
                        color: Colors.white,
                      ),
                      boxShadow: [
                        BoxShadow(
                            spreadRadius: 1,
                            blurRadius: 10,
                            color: Colors.green)
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
              title: Text("Username",
                  style: TextStyle(fontSize: 20.0, color: Colors.white)),
              subtitle: Text("Tasker",
                  style: TextStyle(fontSize: 14.0, color: Colors.white)),
              trailing: IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TaskerEditProfile()));
                  },
                  icon: Icon(
                    Icons.edit_outlined,
                    color: Colors.white,
                    size: 30.0,
                  ))),
              //Divider (line)
          // Divider(
          //   height: 10.0,
          //   color: Colors.grey[1500],
          // ),
          Padding(
            padding: EdgeInsets.all(0.0),
            child: const Column(
              children: [
                Text("Settings", style: TextStyle(fontSize: 30.0, color: Colors.white))
              ])),
          // Divider(
          //   height: 10.0,
          //   color: Colors.grey[1500],
          // ),
          //Tiles that represent each scrollable entry on the settings page, change onTap() function to redirect to different pages
          ListTile(
            leading: Icon(Icons.edit),
            title: Text("Customize App Theme", style: TextStyle(fontSize: 16.0, color: Colors.white)),
            subtitle: Text("Change the appearance of the app", style: TextStyle(fontSize: 12.0, color: Colors.white)),
            trailing: Icon(Icons.settings),
            onTap: (){
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => SettingsPageName())); //Replace with actual screen name
            },
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text("settings option", style: TextStyle(fontSize: 16.0, color: Colors.white)),
            subtitle: Text("settings option description", style: TextStyle(fontSize: 12.0, color: Colors.white)),
            trailing: Text("trailing option", style: TextStyle(fontSize: 8.0, color: Colors.white)),
            onTap: (){
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => SettingsPageName())); //Replace with actual screen name
            },
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text("settings option", style: TextStyle(fontSize: 16.0, color: Colors.white)),
            subtitle: Text("settings option description", style: TextStyle(fontSize: 12.0, color: Colors.white)),
            trailing: Text("trailing option", style: TextStyle(fontSize: 8.0, color: Colors.white)),
            onTap: (){
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => SettingsPageName())); //Replace with actual screen name
            },
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text("settings option", style: TextStyle(fontSize: 16.0, color: Colors.white)),
            subtitle: Text("settings option description", style: TextStyle(fontSize: 12.0, color: Colors.white)),
            trailing: Text("trailing option", style: TextStyle(fontSize: 8.0, color: Colors.white)),
            onTap: (){
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => SettingsPageName())); //Replace with actual screen name
            },
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text("settings option", style: TextStyle(fontSize: 16.0, color: Colors.white)),
            subtitle: Text("settings option description", style: TextStyle(fontSize: 12.0, color: Colors.white)),
            trailing: Text("trailing option", style: TextStyle(fontSize: 8.0, color: Colors.white)),
            onTap: (){
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => SettingsPageName())); //Replace with actual screen name
            },
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text("settings option", style: TextStyle(fontSize: 16.0, color: Colors.white)),
            subtitle: Text("settings option description", style: TextStyle(fontSize: 12.0, color: Colors.white)),
            trailing: Text("trailing option", style: TextStyle(fontSize: 8.0, color: Colors.white)),
            onTap: (){
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => SettingsPageName())); //Replace with actual screen name
            },
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text("settings option", style: TextStyle(fontSize: 16.0, color: Colors.white)),
            subtitle: Text("settings option description", style: TextStyle(fontSize: 12.0, color: Colors.white)),
            trailing: Text("trailing option", style: TextStyle(fontSize: 8.0, color: Colors.white)),
            onTap: (){
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => SettingsPageName())); //Replace with actual screen name
            },
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text("settings option", style: TextStyle(fontSize: 16.0, color: Colors.white)),
            subtitle: Text("settings option description", style: TextStyle(fontSize: 12.0, color: Colors.white)),
            trailing: Text("trailing option", style: TextStyle(fontSize: 8.0, color: Colors.white)),
            onTap: (){
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => SettingsPageName())); //Replace with actual screen name
            },
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text("settings option", style: TextStyle(fontSize: 16.0, color: Colors.white)),
            subtitle: Text("settings option description", style: TextStyle(fontSize: 12.0, color: Colors.white)),
            trailing: Text("trailing option", style: TextStyle(fontSize: 8.0, color: Colors.white)),
            onTap: (){
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => SettingsPageName())); //Replace with actual screen name
            },
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text("settings option", style: TextStyle(fontSize: 16.0, color: Colors.white)),
            subtitle: Text("settings option description", style: TextStyle(fontSize: 12.0, color: Colors.white)),
            trailing: Text("trailing option", style: TextStyle(fontSize: 8.0, color: Colors.white)),
            onTap: (){
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => SettingsPageName())); //Replace with actual screen name
            },
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text("settings option", style: TextStyle(fontSize: 16.0, color: Colors.white)),
            subtitle: Text("settings option description", style: TextStyle(fontSize: 12.0, color: Colors.white)),
            trailing: Text("trailing option", style: TextStyle(fontSize: 8.0, color: Colors.white)),
            onTap: (){
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => SettingsPageName())); //Replace with actual screen name
            },
          ),
        ])));
  }
}
