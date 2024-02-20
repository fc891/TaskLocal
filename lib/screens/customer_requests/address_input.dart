// Customer Address Input UI/Screen
// Contributors: Eric C.

import 'package:flutter/material.dart';
import 'package:tasklocal/Screens/customer_requests/tasker_selection.dart';

// Eric's code for AddressInputPage class
class AddressInputPage extends StatefulWidget {
  const AddressInputPage({Key? key}) : super(key: key);

  @override
  _AddressInputPageState createState() => _AddressInputPageState();
}

class _AddressInputPageState extends State<AddressInputPage> {
  TextEditingController _addressController = TextEditingController();

  void _navigateToTaskerSelectionPage() {
    // Validate the address before navigating here
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskerSelectionPage()),
    );
  }

  // Eric's code for screen's UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Address'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Please enter your address:',
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
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _navigateToTaskerSelectionPage,
              child: Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
