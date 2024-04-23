// ignore_for_file: prefer_const_constructor

//Contributors: Bill

import 'dart:async';
import 'dart:ffi' as ffi;
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tasklocal/screens/profiles/profilepageglobals.dart' as globals;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

//Bill's Current Location Screen
class CurrentLocation extends StatefulWidget {
  const CurrentLocation({super.key});
  State<CurrentLocation> createState() => CurrentLocationState();
}

//enum UrlType { IMAGE, VIDEO, UNKNOWN }

//Bill's Current Location Screen
class CurrentLocationState extends State<CurrentLocation> {
  bool hasLocationSelected = false;
  String? currentAddress;
  Position? currentPosition;

  late GoogleMapController mapController;
  List<Marker> _markers = [];
  List<LatLng> _positions = [];
  LatLng _center = LatLng(33.7830, -118.1129);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    loadData();
  }

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
    if (hasPermission == false) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() async {
        currentPosition = position;
        await getAddressFromLatLong(currentPosition!);
        hasLocationSelected = true;
        _center = LatLng(position.latitude, position.longitude);
      });
    }).catchError((e) {
      print("Error Detected Getting Location");
      debugPrint(e);
    });
  }

  //Function to convert from a lat/long (Position) to a string address
  Future<void> getAddressFromLatLong(Position position) async {
    String street = "";
    String city = "";
    String state = "";
    String zip = "";
    String country = "";
    await placemarkFromCoordinates(position.latitude, position.longitude)
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

  // void addMarker(String id, LatLng loc) async {
  //   final dB = FirebaseStorage.instance;
  //   final ref = dB.ref().child(
  //       "profilepictures/$id/profilepicture.jpg"); //change id here, not correct
  //   final url = await ref.getDownloadURL();

  //   final File markerImageFile = await DefaultCacheManager().getSingleFile(url);
  //   final Uint8List markerImageBytes = await markerImageFile.readAsBytes();
  //   BitmapDescriptor.fromBytes(markerImageBytes);
  //   final int targetWidth = 60;
  //   final ui.Codec markerImageCodec = await ui.instantiateImageCodec(
  //     markerImageBytes,
  //     targetWidth: targetWidth,
  //   );
  //   final ui.FrameInfo frameInfo = await markerImageCodec.getNextFrame();
  //   final ByteData? byteData = await frameInfo.image.toByteData(
  //     format: ui.ImageByteFormat.png,
  //   );
  //   final Uint8List resizedMarkerImageBytes = byteData!.buffer.asUint8List();

  //   var marker = Marker(
  //       markerId: MarkerId(id),
  //       position: loc,
  //       icon: BitmapDescriptor.fromBytes(resizedMarkerImageBytes));

  //   _markers.add(marker);
  //   setState(() {});
  // }

  Future<ui.Image> getImageFromPath(String imagePath) async {
    //File imageFile = File(imagePath);

    Uint8List imageBytes = await loadNetworkImage(imagePath);

    final Completer<ui.Image> completer = new Completer();

    ui.decodeImageFromList(imageBytes, (ui.Image img) {
      return completer.complete(img);
    });

    return completer.future;
  }

  Future<BitmapDescriptor> getMarkerIcon(String imagePath, ui.Size size) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Radius radius = Radius.circular(size.width / 2);

    final Paint shadowPaint = Paint()..color = Colors.green.withAlpha(100);
    final double shadowWidth = 15.0;

    final Paint borderPaint = Paint()..color = Colors.white;
    final double borderWidth = 3.0;

    final double imageOffset = shadowWidth + borderWidth;

    // Add shadow circle
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(0.0, 0.0, size.width, size.height),
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        ),
        shadowPaint);

    // // Add border circle
    // canvas.drawRRect(
    //     RRect.fromRectAndCorners(
    //       Rect.fromLTWH(shadowWidth, shadowWidth,
    //           size.width - (shadowWidth * 2), size.height - (shadowWidth * 2)),
    //       topLeft: radius,
    //       topRight: radius,
    //       bottomLeft: radius,
    //       bottomRight: radius,
    //     ),
    //     borderPaint);

    // Oval for the image
    Rect oval = Rect.fromLTWH(imageOffset, imageOffset,
        size.width - (imageOffset * 2), size.height - (imageOffset * 2));

    // Add path for oval image
    canvas.clipPath(Path()..addOval(oval));
    // Add image
    ui.Image image = await getImageFromPath(
        imagePath); // Alternatively use your own method to get the image
    paintImage(canvas: canvas, image: image, rect: oval, fit: BoxFit.fitWidth);

    // Convert canvas to image
    final ui.Image markerAsImage = await pictureRecorder
        .endRecording()
        .toImage(size.width.toInt(), size.height.toInt());

    // Convert image to bytes
    final ByteData? byteData =
        await markerAsImage.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List uint8List = byteData!.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(uint8List);
  }

  Future<Uint8List> loadNetworkImage(String url) async {
    final completer = Completer<ImageInfo>();
    var image = NetworkImage(url);

    image.resolve(const ImageConfiguration()).addListener(
        ImageStreamListener((info, _) => completer.complete(info)));

    final imageInfo = await completer.future;
    final byteData =
        await imageInfo.image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  Future<String> getProfilePicturePath() async {
    var current = FirebaseAuth.instance
        .currentUser!; //Use to get the info of the currently logged in user
    String userID = current.email!; //Get email of current user
    final dB = FirebaseStorage.instance;
    final ref = dB.ref().child("profilepictures/$userID/profilepicture.jpg");
    final url = await ref.getDownloadURL();
    return url;
  }

  void loadData() async {
    if (_positions.contains(_center) == false) {
      _positions.add(_center);
    }
    var current = FirebaseAuth.instance
        .currentUser!; //Use to get the info of the currently logged in user
    String userID = current.email!; //Get email of current user
    final dB = FirebaseStorage.instance;
    final ref = dB.ref().child("profilepictures/$userID/profilepicture.jpg");
    final url = await ref.getDownloadURL();

    for (int i = 0; i < _positions.length; i++) {
      Uint8List? image = await loadNetworkImage(url);

      final ui.Codec imageCodecMaker = await ui.instantiateImageCodec(
        image.buffer.asUint8List(),
        targetHeight: 100,
        targetWidth: 100,
      );

      final ui.FrameInfo frameInfo = await imageCodecMaker.getNextFrame();
      final ByteData? byteData =
          await frameInfo.image.toByteData(format: ui.ImageByteFormat.png);

      final Uint8List imageMarkerResized = byteData!.buffer.asUint8List();

      String pfpPath = await getProfilePicturePath();
      _markers.add(Marker(
          markerId: MarkerId(currentAddress!),
          position: _center,
          icon: await getMarkerIcon(pfpPath, Size(120.0, 120.0))));

      setState(() {});
    }
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
          //If location selected, display a map
          if (hasLocationSelected)
            SizedBox(
              width: 400.0,
              height: 400.0,
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition:
                    CameraPosition(target: _center, zoom: 11.0),
                markers: Set<Marker>.of(_markers),
              ),
            ),
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
