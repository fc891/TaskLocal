// Contributors: Eric C.,

// - display additional information of tasker (task category, )

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tasklocal/screens/reservations/reservation_form.dart';
import 'package:tasklocal/screens/messages/msg_list_to_add.dart';

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Please select a tasker to make a reservation with',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder(
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
                          title: Text(tasker['name'] ?? '', style: TextStyle(color: Colors.white)),
                          subtitle: Text(tasker['description'] ?? '', style: TextStyle(color: Colors.white)),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReservationFormScreen(taskerData: tasker),
                              ),
                            );
                          },
                          trailing: IconButton(
                            icon: Icon(Icons.message, color: Colors.white), // Add message icon
                            onPressed: () {
                              // Navigate to the messages screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => MsgListToAdd(taskerData: tasker)),
                              );
                            },
                          ),
                          // You can customize the display of selected taskers data as per your UI requirements
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MsgListToAdd extends StatefulWidget {
  const MsgListToAdd({super.key, required Map<String, dynamic> taskerData});

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
        title: Text('Add Tasker to Message', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
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
                    Text(
                      '${taskerData['first name']} ${taskerData['last name']} \n@${taskerData['username']}',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
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
