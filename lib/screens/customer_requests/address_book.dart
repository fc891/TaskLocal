import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddressBook extends StatefulWidget {
  @override
  _AddressBookState createState() => _AddressBookState();
}

class _AddressBookState extends State<AddressBook> {
  TextEditingController _newAddressController = TextEditingController();
  List<String> _addresses = [];

  @override
  void initState() {
    super.initState();
    _fetchAddresses();
  }

  Future<void> _fetchAddresses() async {
    try {
      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Reference to the "Address Book" document for the current user
        DocumentSnapshot addressBookSnapshot = await FirebaseFirestore.instance
            .collection('Customers')
            .doc(user.email) // Use user's email as document ID
            .collection('AddressBook')
            .doc('addressBookList')
            .get();

        if (addressBookSnapshot.exists) {
          Map<String, dynamic> data = addressBookSnapshot.data() as Map<String, dynamic>;
          setState(() {
            _addresses = List<String>.from(data['addresses']);
          });
        } else {
          // Address book document doesn't exist, initialize it
          await FirebaseFirestore.instance
              .collection('Customers')
              .doc(user.email) // Use user's email as document ID
              .collection('AddressBook')
              .doc('addressBookList')
              .set({'addresses': []});
        }
      } else {
        throw 'User not logged in.';
      }
    } catch (e) {
      print('Error fetching addresses: $e');
    }
  }

  Future<void> _saveAddress() async {
    try {
      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Reference to the "Address Book" document for the current user
        DocumentReference addressBookRef = FirebaseFirestore.instance
            .collection('Customers')
            .doc(user.email) // Use user's email as document ID
            .collection('AddressBook')
            .doc('addressBookList');

        // Add the new address to the list and update the document
        await addressBookRef.update({
          'addresses': FieldValue.arrayUnion([_newAddressController.text]),
        });

        // Fetch updated addresses
        await _fetchAddresses();

        // Clear the text field
        _newAddressController.clear();
      } else {
        throw 'User not logged in.';
      }
    } catch (e) {
      print('Error saving address: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Address Book'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _newAddressController,
              decoration: InputDecoration(
                labelText: 'Add New Address',
                suffixIcon: IconButton(
                  onPressed: _saveAddress,
                  icon: Icon(Icons.add),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _addresses.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_addresses[index]),
                  onTap: () {
                    // Pass selected address back to previous screen
                    Navigator.pop(context, _addresses[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
