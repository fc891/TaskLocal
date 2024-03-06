import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MsgListToAdd extends StatefulWidget {
  const MsgListToAdd({super.key});

  @override
  State<MsgListToAdd> createState() => _MsgListToAddState();
}

class _MsgListToAddState extends State<MsgListToAdd> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        title: Text('Add Tasker to Message', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
        centerTitle: true,
        backgroundColor: Colors.green[800],
      ),
      body: StreamBuilder<QuerySnapshot>(
        // updates the customer's list of taskers
        stream: _firestore.collection('Taskers').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final taskers = snapshot.data!.docs;
          return ListView.builder(
            itemCount: taskers.length,
            itemBuilder: (context, idx) {
              final taskerData = taskers[idx].data() as Map<String, dynamic>;
              // print("TASKER DATA: ${taskerData}, ${taskers[idx]}");
              return Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Text(
                      '${taskerData['first name']} ${taskerData['last name']}\n@${taskerData['username']}',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                     Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[300], // Set background color of the icon
                      ),
                      child: IconButton(
                        onPressed: () {
                          _addTaskerToCollection(taskerData);
                        },
                        icon: Icon(
                          Icons.add,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
  // adds tasker to customer's messaging home page
  // updates the tasker data in the customer's messaging home page
  Future<void> _addTaskerToCollection(Map<String, dynamic> taskerData) async {
    try {
      // Reference to the user's document
      DocumentReference userDocRef = _firestore.collection('Customers').doc(_auth.currentUser!.email);
      DocumentReference userDocRef2 = _firestore.collection('Taskers').doc(taskerData['email']);
      // DocumentReference userDocRef3 = _firestore.collection('Taskers').doc(taskerData['email']);

      ///////
      // _firestore.collection('Taskers').snapshots();
      // final taskers = snapshots.data!.docs;
      DocumentSnapshot customerDoc = await _firestore.collection('Customers').doc(_auth.currentUser!.email).get();
      Map<String, dynamic> customerData = customerDoc.data() as Map<String, dynamic>;

      ///////////////////////////////////
      // Check if the 'Message Taskers' collection exists in the user's document
      // DocumentSnapshot userDocSnapshot = await userDocRef.get();
      // if (!userDocSnapshot.exists) {
      //   // User's document doesn't exist, create it
      //   await userDocRef.set({});
      //   await userDocRef2.set({});
      //   print("hereeeeee");
      // }
      ///////////////////////////////////

      // Add tasker's data to the 'Message Taskers' collection and tasker's data is updated as well
      await userDocRef.collection('Message Taskers').doc(taskerData['email']).set(taskerData);
      
      // Tasker's side
      // create 2 collections here in order to initialize the collections for the Taskers
      // size of collection is updated from tasker's "tasker's_msg_list_to_add.dart"
      await userDocRef2.collection('Message Customers').doc(_auth.currentUser!.email).set(customerData);
      // size of collection remains the same
      await userDocRef2.collection('Constant Message Customers').doc(_auth.currentUser!.email).set(customerData);
      
      // continuing customer's side
      // indicate the execution was successful
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tasker added'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print('Error adding tasker: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add tasker'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}