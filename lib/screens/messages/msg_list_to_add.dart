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
  Future<void> _addTaskerToCollection(Map<String, dynamic> taskerData) async {
  try {
    // Reference to the user's document
    DocumentReference userDocRef = _firestore.collection('Customers').doc(_auth.currentUser!.email);
    
    // Check if the 'Message Taskers' collection exists in the user's document
    DocumentSnapshot userDocSnapshot = await userDocRef.get();
    if (!userDocSnapshot.exists) {
      // User's document doesn't exist, create it
      await userDocRef.set({});
    }
    
    // Add taskerId to the 'Message Taskers' collection
    await userDocRef.collection('Message Taskers').doc(taskerData['email']).set(taskerData);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tasker added to collection.'),
        duration: Duration(seconds: 2),
      ),
    );
    } catch (e) {
      print('Error adding tasker to collection: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add tasker to collection.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}