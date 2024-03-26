// Contributors: Eric C.,

// TODO: Allow customer to interact (message, etc.) from list.

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyTaskersPage extends StatefulWidget {
  @override
  _MyTaskersPageState createState() => _MyTaskersPageState();
}

class _MyTaskersPageState extends State<MyTaskersPage> {
  // Fetch selected taskers data from Firestore
  Future<List<Map<String, dynamic>>> fetchSelectedTaskers() async {
    // Get the currently logged-in user's email
    String currentUserEmail = FirebaseAuth.instance.currentUser!.email!;

    // Query the "Selected Taskers" collection under the current customer's document
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Customers')
        .doc(currentUserEmail)
        .collection('Selected Taskers')
        .get();

    List<Map<String, dynamic>> selectedTaskers = [];
    querySnapshot.docs.forEach((doc) {
      Map<String, dynamic> taskerData = doc.data() as Map<String, dynamic>;
      taskerData['id'] = doc.id; // Use document ID (tasker's email) as the ID
      selectedTaskers.add(taskerData);
    });
    return selectedTaskers;
  }

  // Function to delete selected tasker
  Future<void> deleteSelectedTasker(String taskerEmail) async {
    // Get the currently logged-in user's email
    String currentUserEmail = FirebaseAuth.instance.currentUser!.email!;

    // Delete the selected tasker from Firestore
    await FirebaseFirestore.instance
        .collection('Customers')
        .doc(currentUserEmail)
        .collection('Selected Taskers')
        .doc(taskerEmail) // Use tasker's email as document ID
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Taskers'),
      ),
      body: FutureBuilder(
        future: fetchSelectedTaskers(),
        builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No selected taskers.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final tasker = snapshot.data![index];
                return Dismissible(
                  key: Key(tasker['id']), // Use tasker's email as key
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  confirmDismiss: (direction) async {
                    return await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Confirm"),
                          content: Text("Are you sure you want to delete this tasker?"),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: Text("CANCEL"),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: Text("DELETE"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  onDismissed: (direction) {
                    // If confirmed, delete the tasker
                    if (direction == DismissDirection.endToStart) {
                      deleteSelectedTasker(tasker['id']);
                    }
                  },
                  child: ListTile(
                    title: Text(tasker['name'] ?? ''),
                    subtitle: Text(tasker['description'] ?? ''),
                    // You can customize the display of selected taskers data as per your UI requirements
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
