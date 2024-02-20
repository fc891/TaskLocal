// Customer Address Input UI/Screen
// Contributors: Eric C.

import 'package:flutter/material.dart';
import 'package:tasklocal/Screens/customer_requests/tasker_selection.dart';
import 'package:tasklocal/screens/customer_requests/address_book.dart';

// Eric's code for AddressInputPage class
class AddressInputPage extends StatefulWidget {
  const AddressInputPage({Key? key}) : super(key: key);

  @override
  _AddressInputPageState createState() => _AddressInputPageState();
}

class _AddressInputPageState extends State<AddressInputPage> {
  TextEditingController _addressController = TextEditingController();
  bool _isGeolocationPermissionGranted = false; // Track geolocation permission

  // Dummy data for recent addresses
  List<String> _recentAddresses = [
    '123 Main St, Anytown, USA',
    '456 Elm St, Anycity, USA',
    '789 Oak St, Anyville, USA',
  ];

  void _navigateToTaskerSelectionPage() {
    // Validate the address before navigating here
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskerSelectionPage()),
    );
  }

  void _handleGeolocationPermission() {
    // Implement logic to request geolocation permission
    // Set _isGeolocationPermissionGranted accordingly
    setState(() {
      _isGeolocationPermissionGranted = true; // Temporary flag for demonstration
    });
  }

  void _loadFromAddressBook(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddressBook()),
    );
  }

  void _loadRecentAddresses() {
    // Implement functionality to load recent addresses
    // For demonstration purposes, let's set the recent addresses in the text field
    setState(() {
      _addressController.text = _recentAddresses.join('\n');
    });
  }

  // Eric's code for screen's UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Address'),
      ),
      body: Container(
        color: Colors.white, // Set background color to white
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Where is today's job at?",
                style: TextStyle(fontSize: 18),
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
              SizedBox(height: 10), // Adjusted height here
              TextButton(
                onPressed: _handleGeolocationPermission,
                child: Text('Use Current Location'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _navigateToTaskerSelectionPage,
                child: Text('Continue'),
              ),
              SizedBox(height: 20),
              Text(
                'Or select address from:',
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
              SizedBox(height: 20),
              Text(
                'Or select location on map:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              // Implement map integration here
            ],
          ),
        ),
      ),
    );
  }
}
