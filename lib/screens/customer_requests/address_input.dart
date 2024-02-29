// Customer Address Input UI/Screen
// Contributors: Eric C.

import 'package:flutter/material.dart';
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
  TextEditingController _unitController = TextEditingController(); // Add this line
  // ! permission to get user's current location
  bool _isGeolocationPermissionGranted = false;
  List<String> _recentAddresses = [
    '123 Main St, Anytown, USA',
    // '456 Elm St, Anycity, USA',
    // '789 Oak St, Anyville, USA',
  ];

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
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TaskerSelectionPage()),
      );
    }
  }

  void _handleGeolocationPermission() {
    setState(() {
      _isGeolocationPermissionGranted = true;
    });
  }

  void _loadFromAddressBook(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddressBook()),
    );
  }

  void _loadRecentAddresses() {
    setState(() {
      _addressController.text = _recentAddresses.join('\n');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Address'),
      ),
      body: Column(
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
                  controller: _unitController, // Use _unitController here
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
                      label: Text('Recent Addresses'),
                    ),
                  ],
                ),
                // ! DO or DO NOT include map
                // ! Uncomment or comment out
                // SizedBox(height: 20),
                // Text(
                  // 'Or select a location on the map:',
                  // style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                // ),
              ],
            ),
          ),
          Expanded(
            child: Container(),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
              onPressed: _navigateToTaskerSelectionPage,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Text(
                  'Continue',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}
