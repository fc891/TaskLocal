// ignore_for_file: prefer_const_constructor

//Contributors: Bill

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tasklocal/screens/profiles/taskereditprofile.dart';
import 'package:tasklocal/screens/profiles/taskinfo.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasklocal/Screens/app_theme/theme_provider.dart';

FirebaseAuth firebaseAuth = FirebaseAuth.instance;

//Bill's App Theme Customization Screen
class AppThemeCustomization extends ConsumerStatefulWidget {
  const AppThemeCustomization({super.key});
  @override
  ConsumerState<AppThemeCustomization> createState() =>
      _AppThemeCustomizationState();
}

//Bill's App Theme Customization Screen
class _AppThemeCustomizationState extends ConsumerState<AppThemeCustomization> {
  //Bill's Settings Screen
  @override
  Widget build(BuildContext context) {
    var isDarkMode = ref.watch(appThemeProvider);
    return Scaffold(
        //Background color of UI
        //backgroundColor: Colors.green[500],
        //UI Appbar (bar at top of screen)
        appBar: AppBar(
          title: Text('App Theme Customization'),
          centerTitle: true,
          //backgroundColor: Colors.green[800],
          elevation: 0.0,
        ),
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
            child: Column(children: [
          //Divider (line)
          // Divider(
          //   height: 10.0,
          //   color: Colors.grey[1500],
          // ),
          // Padding(
          //     padding: EdgeInsets.all(0.0),
          //     child: const Column(children: [
          //       Text("App Theme Customization",
          //           style: TextStyle(fontSize: 30.0, color: Colors.white))
          //     ])),
          // Divider(
          //   height: 10.0,
          //   color: Colors.grey[1500],
          // ),
          //Tiles that represent each scrollable entry on the settings page, change onTap() function to redirect to different pages
          ListTile(
            leading: Icon(
              Icons.edit_outlined,
              color: Colors.white,
            ),
            title: Text("Classic Theme",
                style: TextStyle(fontSize: 16.0)),
            subtitle: Text("Green/white classic app theme",
                style: TextStyle(fontSize: 12.0)),
            trailing: Text(""),
            onTap: () {
              ref.read(appThemeProvider.notifier).state = false;
            },
          ),
          ListTile(
            leading: Icon(
              Icons.sunny_snowing,
              color: Colors.white,
            ),
            title: Text("Dark Theme",
                style: TextStyle(fontSize: 16.0)),
            subtitle: Text("Black/grey dark app theme",
                style: TextStyle(fontSize: 12.0)),
            trailing: Text(""),
            onTap: () {
              ref.read(appThemeProvider.notifier).state = true;
            },
          ),
          // ListTile(
          //   leading: Icon(
          //     Icons.settings,
          //     color: Colors.white,
          //   ),
          //   title: Text("settings option",
          //       style: TextStyle(fontSize: 16.0, color: Colors.white)),
          //   subtitle: Text("settings option description",
          //       style: TextStyle(fontSize: 12.0, color: Colors.white)),
          //   trailing: Text("trailing option",
          //       style: TextStyle(fontSize: 8.0, color: Colors.white)),
          //   onTap: () {
          //     // Navigator.push(
          //     //     context,
          //     //     MaterialPageRoute(
          //     //         builder: (context) => SettingsPageName())); //Replace with actual screen name
          //   },
          // ),
        ])));
  }
}
