// Contributors: Richard N.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:tasklocal/screens/profiles/test_non_logged_in_profile/nonloggedin_taskerprofile.dart';

class MsgListToAdd extends StatefulWidget {
  const MsgListToAdd({Key? key}) : super(key: key);

  @override
  State<MsgListToAdd> createState() => _MsgListToAddState();
}

class _MsgListToAddState extends State<MsgListToAdd> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.green,
      appBar: AppBar(
        title: Text(
          'Add Tasker to Message',
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        //backgroundColor: Colors.green[800],
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
              return Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: CircleAvatar(
                        child: Icon(Icons.account_circle),
                      ),
                      // allow customer to view the tasker's profile before messaging them
                      // child: GestureDetector(
                      //   onTap: () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(builder: (context) => NonLoggedInTaskerProfilePage(email: taskerData['email'])),
                      //     );
                      //   },
                      //   child: CircleAvatar(
                      //     child: Icon(Icons.account_circle),
                      //   ),
                      // ),
                    ),
                    Expanded(
                      child: DefaultTextStyle(
                        style: TextStyle(
                          color: Colors.black, // Change text color to black
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${taskerData['first name']} ${taskerData['last name']}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '@${taskerData['username']}',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[300],
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
      DocumentReference customerDocRef = _firestore.collection('Customers').doc(_auth.currentUser!.email);
      DocumentReference taskerDocRef = _firestore.collection('Taskers').doc(taskerData['email']);

      DocumentSnapshot customerDoc = await _firestore.collection('Customers').doc(_auth.currentUser!.email).get();
      Map<String, dynamic> customerData = customerDoc.data() as Map<String, dynamic>;

      // Add tasker's data to the 'Message Taskers' collection and tasker's data is updated as well
      await customerDocRef.collection('Message Taskers').doc(taskerData['email']).set(taskerData);

      // Tasker's side
      // create 2 collections here in order to initialize the collections for the Taskers
      // size of collection is updated from tasker's "tasker's_msg_list_to_add.dart"
      await taskerDocRef.collection('Message Customers').doc(_auth.currentUser!.email).set(customerData);
      // size of collection remains the same
      await taskerDocRef.collection('Constant Message Customers').doc(_auth.currentUser!.email).set(customerData);

      // continuing customer's side
      // indicate the execution was successful
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tasker added'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      // print('Error adding tasker: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add tasker'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
