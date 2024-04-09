// Customer Address Input UI/Screen
// Contributors: Eric C.

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tasklocal/Screens/customer_requests/tasker_selection.dart';
import 'package:tasklocal/screens/customer_requests/address_book.dart';

class AddressInputPage extends StatefulWidget {
  const AddressInputPage({Key? key}) : super(key: key);

  @override
  _AddressInputPageState createState() => _AddressInputPageState();
}

// TODO: make it so that it grabs the user's last used address when choosing a task
class _AddressInputPageState extends State<AddressInputPage> {
  TextEditingController _addressController = TextEditingController();
  TextEditingController _unitController = TextEditingController();
  bool _isGeolocationPermissionGranted = false;

  void _navigateToTaskerSelectionPage() {
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
      _saveAddressToFirestore();
    }
  }

  void _handleGeolocationPermission() {
    setState(() {
      _isGeolocationPermissionGranted = true;
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
            .doc('latestAddressInput') // Assuming there's a document named 'latestAddressInput' holding the latestAddressInput address
            .get();

        if (addressSnapshot.exists) {
          Map<String, dynamic> addressData = addressSnapshot.data() as Map<String, dynamic>;
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

  void _saveAddressToFirestore() async {
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
        });

        // Close the loading dialog
        Navigator.pop(context);

        // Navigate to tasker selection page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TaskerSelectionPage()),
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
                  TextButton(
                    onPressed: _handleGeolocationPermission,
                    child: Text('Use Current Location'),
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
                        icon: Icon(Icons.contacts),
                        label: Text('Address Book'),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton.icon(
                        onPressed: _loadRecentAddresses,
                        icon: Icon(Icons.history),
                        label: Text('Most Recent'),
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
                onPressed: _navigateToTaskerSelectionPage,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    'Continue',
                    style: TextStyle(fontSize: 18),
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
