import 'package:flutter/material.dart';

// Dummy data representing addresses from the user's address book
List<String> dummyAddresses = [
  '123 Main St, Anytown, USA',
  '456 Elm St, Anycity, USA',
  '789 Oak St, Anyville, USA',
];

class AddressBook extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Address Book'),
      ),
      body: ListView.builder(
        itemCount: dummyAddresses.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(dummyAddresses[index]),
            // You can add more functionality like selecting addresses here
          );
        },
      ),
    );
  }
}
