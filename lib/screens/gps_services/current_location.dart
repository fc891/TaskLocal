// ignore_for_file: prefer_const_constructor

//Contributors: Bill

import 'dart:async';
import 'dart:ffi' as ffi;
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:math' show cos, sqrt, asin;
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
  const CurrentLocation({super.key, required this.userType});
  final String userType;
  State<CurrentLocation> createState() => CurrentLocationState();
}

//enum UrlType { IMAGE, VIDEO, UNKNOWN }

//Bill's Current Location Screen
class CurrentLocationState extends State<CurrentLocation> {
  bool hasLocationSelected = false;
  bool _displayOtherUserInfo = false;
  String? currentAddress;
  Position? currentPosition;
  String selectedUserName = "Loading user info...";
  String selectedFirstName = "";
  String selectedLastName = "";
  double selectedDistance = 0.0;

  late GoogleMapController mapController;
  List<Marker> _markers = [];
  List<Marker> _markersOtherUser = [];
  List<LatLng> _positions = [];
  List<LatLng> _positionsOtherUser = [];
  LatLng _centerOtherUser = LatLng(33.7854, -118.1086);
  LatLng _center = LatLng(33.7830, -118.1129);

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    loadMarkerData();
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

  //Getting network image from a URL path
  Future<ui.Image> getImageFromPath(String imagePath) async {
    //File imageFile = File(imagePath);

    Uint8List imageBytes = await loadNetworkImage(imagePath);

    final Completer<ui.Image> completer = new Completer();

    ui.decodeImageFromList(imageBytes, (ui.Image img) {
      return completer.complete(img);
    });

    return completer.future;
  }

  //Getting marker icon and displaying it on the map (circular user icons)
  Future<BitmapDescriptor> getMarkerIcon(
      String imagePath, ui.Size size, String type) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();

    final Canvas canvas = Canvas(pictureRecorder);
    final Radius radius = Radius.circular(size.width / 2);

    final Paint shadowPaint = Paint()..color = Colors.green.withAlpha(100);
    final double shadowWidth = 0.0;

    final Paint borderPaint = Paint()..color = Colors.white;
    final double borderWidth = 7.0;

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

    // Add border circle
    if (type == "Self") {
      final Paint borderPaint = Paint()..color = Colors.green;
      canvas.drawRRect(
          RRect.fromRectAndCorners(
            Rect.fromLTWH(
                shadowWidth,
                shadowWidth,
                size.width - (shadowWidth * 2),
                size.height - (shadowWidth * 2)),
            topLeft: radius,
            topRight: radius,
            bottomLeft: radius,
            bottomRight: radius,
          ),
          borderPaint);
    } else if (type == "Other") {
      final Paint borderPaint = Paint()..color = Colors.red;
      canvas.drawRRect(
          RRect.fromRectAndCorners(
            Rect.fromLTWH(
                shadowWidth,
                shadowWidth,
                size.width - (shadowWidth * 2),
                size.height - (shadowWidth * 2)),
            topLeft: radius,
            topRight: radius,
            bottomLeft: radius,
            bottomRight: radius,
          ),
          borderPaint);
    }

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

  //Loading network image (link) and converting it to a Uint8List for display on map
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

  //Getting current user's profile picture URL from database, returns a string as URL
  Future<String> getProfilePicturePath() async {
    var current = FirebaseAuth.instance
        .currentUser!; //Use to get the info of the currently logged in user
    String userID = current.email!; //Get email of current user
    final dB = FirebaseStorage.instance;
    final ref = dB.ref().child("profilepictures/$userID/profilepicture.jpg");
    final url = await ref.getDownloadURL();
    return url;
  }

  //Getting current user's profile picture URL from database, returns a string as URL
  Future<String> getProfilePicturePathOtherUser(String id) async {
    String returnVal =
        "https://firebasestorage.googleapis.com/v0/b/authtutorial-a4202.appspot.com/o/profilepictures%2Ftasklocaltransparent.png?alt=media&token=31e20dcc-4b9a-41cb-85ed-bc82166ac836";
    try {
      final dB = FirebaseStorage.instance;
      final ref = dB.ref().child("profilepictures/$id/profilepicture.jpg");
      final url = await ref.getDownloadURL();
      returnVal = url;
    } on FirebaseAuthException catch (e) {
      print("Error fetching profile picture: $e");
      print("$id has no profile picture set, displaying app default instead");
    }
    return returnVal;
  }

  //Bill's get user's info using email id
  void getUserInfo(String id) async {
    var collection = FirebaseFirestore.instance.collection(widget.userType);
    if (widget.userType == "Customers") {
      collection = FirebaseFirestore.instance.collection("Taskers");
    } else if (widget.userType == "Taskers") {
      collection = FirebaseFirestore.instance.collection("Customers");
    }
    var docSnapshot = await collection.doc(id).get();
    Map<String, dynamic> data = docSnapshot.data()!;
    setState(() {
      selectedUserName = data['username'];
      selectedFirstName = data['first name'];
      selectedLastName = data['last name'];
    });
  }

  //Calculate distance between two points (current user and selected user on map) in kilometers (km)
  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  //Load marker data
  void loadMarkerData() async {
    //User's marker on map (always load)
    String pfpPath = await getProfilePicturePath();
    _markers.add(Marker(
        markerId: MarkerId("Self"),
        position: _center,
        icon: await getMarkerIcon(pfpPath, Size(120.0, 120.0), "Self"),
        onTap: () {
          setState(() {
            _displayOtherUserInfo = false;
          });
        }));

    //TODO: Add all customers to map based on certain distance and if they have posted a request (add button to show request details too)
    //Test (temporary)
    if (widget.userType == "Taskers") {
      String id = "test1234@gmail.com";
      String pfpPathOtherUser = await getProfilePicturePathOtherUser(id);
      _markers.add(
        Marker(
            markerId: MarkerId(id),
            icon: await getMarkerIcon(
                pfpPathOtherUser, Size(120.0, 120.0), "Other"),
            position: _centerOtherUser,
            onTap: () {
              //TODO: Add a call to a method here that draws a route to selected customer
              //drawRoute();
              setState(() {
                getUserInfo(id);
                _displayOtherUserInfo = true;
                selectedDistance = double.parse(calculateDistance(
                        _center.latitude,
                        _center.longitude,
                        _centerOtherUser.latitude,
                        _centerOtherUser.longitude)
                    .toStringAsFixed(2));
              });
            }),
      );

      //TODO: Add tasker that is completing task to the map for customer to track
      //Test (temporary)
    } else if (widget.userType == "Customers") {
      String id = "test123@gmail.com";
      String pfpPathOtherUser = await getProfilePicturePathOtherUser(id);
      _markers.add(
        Marker(
            markerId: MarkerId(id),
            icon: await getMarkerIcon(
                pfpPathOtherUser, Size(120.0, 120.0), "Other"),
            position: _centerOtherUser,
            onTap: () {
              //TODO: Add a call to a method here that tracks tasker
              //drawRoute();
              setState(() {
                getUserInfo(id);
                _displayOtherUserInfo = true;
                selectedDistance = double.parse(calculateDistance(
                        _center.latitude,
                        _center.longitude,
                        _centerOtherUser.latitude,
                        _centerOtherUser.longitude)
                    .toStringAsFixed(2));
              });
            }),
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Background color of UI
      //backgroundColor: Colors.green[500],
      //UI Appbar (bar at top of screen)
      appBar: AppBar(
        title: Text('${widget.userType} Location Services', style: TextStyle(fontSize: 22.0)),
        centerTitle: true,
        //backgroundColor: Colors.green[800],
        elevation: 0.0,
      ),
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(children: [
          //Display a map
          //if (hasLocationSelected)
          SizedBox(
            width: 400.0,
            height: 600.0,
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition:
                  CameraPosition(target: _center, zoom: 14.0),
              markers: Set<Marker>.of(_markers),
              mapType: MapType.normal,
            ),
          ),
          const SizedBox(height: 20.0),
          //Selected user details
          if (_displayOtherUserInfo)
            Padding(
                padding: EdgeInsets.fromLTRB(40.0, 0.0, 40.0, 10.0),
                child: Text(
                    "$selectedFirstName $selectedLastName @$selectedUserName",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      letterSpacing: 1.0,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ))),
          if (_displayOtherUserInfo)
            Padding(
                padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                child: Text("$selectedDistance km away",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      letterSpacing: 1.0,
                      fontSize: 16.0,
                    ))),
          // const SizedBox(height: 20.0),
          //Select location button
          // ElevatedButton(
          //     child:
          //         Text("Get Location", style: TextStyle(color: Colors.black)),
          //     onPressed: () async {
          //       await getLocation();
          //     }),
          // const SizedBox(height: 20.0),
        ]),
      ),
    );
  }
}
