// Customer Address Input UI/Screen
// Contributors: Eric C.

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tasklocal/screens/customer_requests/tasker_selection.dart';
import 'package:tasklocal/screens/customer_requests/address_book.dart';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class AddressInputPage extends StatefulWidget {
  final String jobCategory;

  const AddressInputPage({Key? key, required this.jobCategory})
      : super(key: key);

  @override
  _AddressInputPageState createState() => _AddressInputPageState();
}

class _AddressInputPageState extends State<AddressInputPage> {
  TextEditingController _addressController = TextEditingController();
  TextEditingController _unitController = TextEditingController();
  bool _isGeolocationPermissionGranted = false;

  String? currentAddress;
  Position? currentPosition;
  String loadingText = "Use Current Location";

  void _navigateToTaskerSelectionPage(String jobCategory) {
    if (_addressController.text.trim().isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Address Required'),
            content: Text('Please enter your address.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      _saveAddressToFirestore(jobCategory);
    }
  }

  //Grabs user's current address
  void _handleGeolocationPermission() async {
    await getLocation();
    setState(() {
      //Getting geolocation and then setting "address" String variable to the current user's device location
      _isGeolocationPermissionGranted = true;
    });
  }

  //Sets addressController to current address when pressed by user
  void _setAddressToCurrentLocation() {
    setState(() {
      _addressController.text = currentAddress!;
    });
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
    setState(() {
      loadingText = "Loading...";
    });
    final hasPermission = await checkLocationPermission();
    if (hasPermission == false) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() async {
        currentPosition = position;
        await getAddressFromLatLong(currentPosition!);
        loadingText = "Use Current Location";
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
        currentAddress = street + ", " + city + ", " + state + ", " + zip + ", " + country;
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  void _loadFromAddressBook(BuildContext context) async {
    final selectedAddress = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddressBook()),
    );

    if (selectedAddress != null) {
      setState(() {
        _addressController.text = selectedAddress;
      });
    }
  }

  void _loadRecentAddresses() async {
    try {
      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Reference to the "Customer Address" document for the current user
        DocumentSnapshot addressSnapshot = await FirebaseFirestore.instance
            .collection('Customers')
            .doc(user.email) // Use user's email as document ID
            .collection('Customer Address')
            .doc(
                'latestAddressInput') // Assuming there's a document named 'latestAddressInput' holding the latestAddressInput address
            .get();

        if (addressSnapshot.exists) {
          Map<String, dynamic> addressData =
              addressSnapshot.data() as Map<String, dynamic>;
          setState(() {
            _addressController.text = addressData['address'] ?? '';
            _unitController.text = addressData['unit'] ?? '';
          });
        } else {
          // No recent address found
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('No recent address found.'),
            ),
          );
        }
      } else {
        throw 'User not logged in.';
      }
    } catch (e) {
      print('Error loading recent addresses: $e');
    }
  }

  void _saveAddressToFirestore(String jobCategory) async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Reference to the "Customer Address" document for the current user
        DocumentReference customerAddressRef = FirebaseFirestore.instance
            .collection('Customers')
            .doc(user.email) // Use user's email as document ID
            .collection('Customer Address')
            .doc('latestAddressInput');

        // Update the address in the document
        await customerAddressRef.set({
          'address': _addressController.text,
          'unit': _unitController.text,
          'jobCategory': jobCategory, // Store the selected job category
        });

        // Close the loading dialog
        Navigator.pop(context);

        // Navigate to tasker selection page
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  TaskerSelectionPage(jobCategory: jobCategory)),
        );
      } else {
        throw 'User not logged in.';
      }
    } catch (e) {
      // Close the loading dialog
      Navigator.pop(context);

      // Show error dialog
      _showErrorDialog(e.toString());
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Address'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Where is today's job at?",
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      labelText: 'Address',
                      border: OutlineInputBorder(),
                      hintText: 'Enter your address',
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(height: 20),
                  TextField(
                    controller: _unitController,
                    decoration: InputDecoration(
                      labelText: 'Optional unit or apt #',
                      border: OutlineInputBorder(),
                      hintText: 'Enter your unit or apt #',
                    ),
                  ),
                  SizedBox(height: 10),
                  //TextButton that displays "Use Current Location" if not currently grabbing address. Otherwise, display "Loading..." while grabbing address.
                  TextButton(
                    onPressed: _handleGeolocationPermission,
                    child: Text(loadingText, style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  //Display address if found
                  if (currentAddress != null)
                    TextButton(
                      onPressed: _setAddressToCurrentLocation,
                      child: Text("$currentAddress"),
                    ),
                  SizedBox(height: 10),
                  SizedBox(height: 20),
                  Text(
                    'Or select an address from:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          _loadFromAddressBook(context);
                        },
                        icon: Icon(Icons.contacts,
                            color: Colors.black), // Change icon color to black
                        label: Text(
                          'Address Book',
                          style: TextStyle(
                              color:
                                  Colors.black), // Change text color to black
                        ),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton.icon(
                        onPressed: _loadRecentAddresses,
                        icon: Icon(Icons.history,
                            color: Colors.black), // Change icon color to black
                        label: Text(
                          'Most Recent',
                          style: TextStyle(
                              color:
                                  Colors.black), // Change text color to black
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Container(
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                onPressed: () {
                  _navigateToTaskerSelectionPage(widget.jobCategory);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    'Continue',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black), // Change text color to black
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
