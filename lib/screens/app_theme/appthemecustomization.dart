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
import 'package:tasklocal/screens/app_theme/theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    return Scaffold(
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
          //Tiles that represent each scrollable entry on the settings page, change onTap() function to redirect to different pages
          //Classic theme button
          ListTile(
            leading: Icon(
              Icons.edit_outlined,
              color: Theme.of(context).colorScheme.secondary,
            ),
            title: Text("Classic Theme", style: TextStyle(fontSize: 16.0, color: Theme.of(context).colorScheme.secondary)),
            subtitle: Text("Green/white classic app theme",
                style: TextStyle(fontSize: 12.0, color: Theme.of(context).colorScheme.secondary)),
            trailing: Text(""),
            onTap: () {
              ref.read(isDarkProvider.notifier).toggleTheme(false);
            },
          ),
          //Dark theme button
          ListTile(
            leading: Icon(
              Icons.sunny_snowing,
              color: Theme.of(context).colorScheme.secondary,
            ),
            title: Text("Dark Theme", style: TextStyle(fontSize: 16.0, color: Theme.of(context).colorScheme.secondary)),
            subtitle: Text("Black/grey dark app theme",
                style: TextStyle(fontSize: 12.0, color: Theme.of(context).colorScheme.secondary)),
            trailing: Text(""),
            onTap: () {
              ref.read(isDarkProvider.notifier).toggleTheme(true);
            },
          ),
        ])));
  }
}
