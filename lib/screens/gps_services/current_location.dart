// ignore_for_file: prefer_const_constructor

//Contributors: Bill

import 'dart:ffi';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tasklocal/screens/profiles/profilepageglobals.dart' as globals;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

//Bill's Current Location Screen
class CurrentLocation extends StatefulWidget {
  const CurrentLocation({super.key});
  State<CurrentLocation> createState() => _CurrentLocationState();
}

//enum UrlType { IMAGE, VIDEO, UNKNOWN }

//Bill's Current Location Screen
class _CurrentLocationState extends State<CurrentLocation> {
  bool hasLocationSelected = false;
  String? currentAddress;
  Position? currentPosition;

  //Check for GPS services on the current device. If permissions are disabled, prompt user to enable.
  Future<bool> checkLocationPermission() async {
    bool isServiceEnabled;
    LocationPermission permission;

    isServiceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!isServiceEnabled) {
      //If GPS services are disabled, request to enable
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              "GeoLocation services disabled, please enable location services for this app")));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      //Try to request access to GPS services
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        //If user declines access to GPS services, prompt to enable
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                "App was denied access to location permissions, please enable location services for this app")));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      //If user's device has GPS services disabled, prompt to enable
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              "Location permissions are permanently denied, please enable location services for this app")));
      return false;
    }
    return true;
  }

  //Function to get user's current location
  Future<void> getLocation() async {
    final hasPermission = await checkLocationPermission();
    print("running2 $hasPermission");
    if (hasPermission == false) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() {
        currentPosition = position;
        getAddressFromLatLong(position);
        hasLocationSelected = true;
      });
    }).catchError((e) {
      print("Error Detected");
      debugPrint(e);
    });
  }

  Future<void> getAddressFromLatLong(Position position) async {
    String street = "";
    String city = "";
    String state = "";
    String zip = "";
    String country = "";
    await placemarkFromCoordinates(
            currentPosition!.latitude, currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        street = "${place.street}";
        city = "${place.locality}";
        state = "${place.administrativeArea}";
        zip = "${place.postalCode}";
        country = "${place.country}";
        currentAddress =
            street + ", " + city + ", " + state + ", " + zip + ", " + country;
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Background color of UI
      //backgroundColor: Colors.green[500],
      //UI Appbar (bar at top of screen)
      appBar: AppBar(
        title: Text('Current Location'),
        centerTitle: true,
        //backgroundColor: Colors.green[800],
        elevation: 0.0,
      ),
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(children: [
          if (hasLocationSelected)
            Flexible(
                child: Container(
                  width: 500.0,
                  height: 500.0,
              color: Theme.of(context).colorScheme.tertiary,
              //TODO: Implement map view here
              child: Text("MAP WIP")
            )),
          const SizedBox(height: 20.0),
          //Image details
          if (hasLocationSelected)
          Padding(
            padding: EdgeInsets.fromLTRB(40.0, 0.0, 40.0, 10.0),
            child: Text("Current Location:",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  letterSpacing: 1.0,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ))),
          if (hasLocationSelected)
          Padding(
            padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
            child: Text("$currentAddress",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  letterSpacing: 1.0,
                  fontSize: 16.0,
                ))),
          const SizedBox(height: 20.0),
          //Select media button
          ElevatedButton(
              child:
                  Text("Get Location", style: TextStyle(color: Colors.black)),
              onPressed: () async {
                await getLocation();
              }),
          const SizedBox(height: 20.0),
          //Upload media button (only display once user selects an image)
          // if (hasLocationSelected)
          //   ElevatedButton(
          //       child: const Text("Upload Media",
          //           style: TextStyle(color: Colors.black)),
          //       onPressed: () async {
          //         if (selected != null) {
          //           await uploadMedia();
          //           print("Successfully uploaded!");
          //           Navigator.pop(context);
          //         } else if (selected == null) {
          //           print("Null value, not uploading");
          //         }
          //       }),
        ]),
      ),
    );
  }
}
