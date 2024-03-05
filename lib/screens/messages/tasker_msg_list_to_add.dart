import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TaskerMsgListToAdd extends StatefulWidget {
  const TaskerMsgListToAdd({super.key});

  @override
  State<TaskerMsgListToAdd> createState() => _TaskerMsgListToAddState();
}

class _TaskerMsgListToAddState extends State<TaskerMsgListToAdd> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        title: Text('Add Customer to Message', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
        centerTitle: true,
        backgroundColor: Colors.green[800],
      ),
      body: StreamBuilder<QuerySnapshot>(
        // taskers can only chat with customers that were initiated by them
        stream: _firestore.collection('Taskers').doc(_auth.currentUser!.email).collection('Message Customers').snapshots(),
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
  Future<void> _addTaskerToCollection(Map<String, dynamic> taskerData) async {
  try {
    // Reference to the user's document
    DocumentReference userDocRef = _firestore.collection('Taskers').doc(_auth.currentUser!.email);
    
    // Check if the 'Message Taskers' collection exists in the user's document
    DocumentSnapshot userDocSnapshot = await userDocRef.get();
    if (!userDocSnapshot.exists) {
      // User's document doesn't exist, create it
      await userDocRef.set({});
    }
    
    // Add customer to the 'Message Customer' collection
    await userDocRef.collection('Message Customers').doc(taskerData['email']).set(taskerData);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tasker added to collection.'),
        duration: Duration(seconds: 2),
      ),
    );
    } catch (e) {
      print('Error adding customer to collection: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add customer to collection.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}