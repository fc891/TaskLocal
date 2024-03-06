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
        stream: _firestore.collection('Taskers').doc(_auth.currentUser!.email).collection('Constant Message Customers').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final customers = snapshot.data!.docs;
          return ListView.builder(
            itemCount: customers.length,
            itemBuilder: (context, idx) {
              final customerData = customers[idx].data() as Map<String, dynamic>;
              // print("TASKER DATA: ${customerData}, ${customers[idx]}");
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
                      '${customerData['first name']} ${customerData['last name']}\n@${customerData['username']}',
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
                          _addCustomerToCollection(customerData);
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
  // adds customer to tasker's messaging home page
  // updates the customer data in both the tasker's list of customers and messaging home page
  Future<void> _addCustomerToCollection(Map<String, dynamic> customerData) async {
    try {
      // Reference to the user's document
      DocumentReference userDocRef = _firestore.collection('Taskers').doc(_auth.currentUser!.email);

      /////////////
      DocumentSnapshot currCustomerDoc = await _firestore.collection('Customers').doc(customerData['email']).get();
      Map<String, dynamic> currCustomerData = currCustomerDoc.data() as Map<String, dynamic>;
      // print(customerData);
      // print("split");
      // print(currCustomerData);
      
      //////////////////////////////////////////
      // Check if the 'Message Taskers' collection exists in the user's document
      // DocumentSnapshot userDocSnapshot = await userDocRef.get();
      // if (!userDocSnapshot.exists) {
      //   // User's document doesn't exist, create it
      //   await userDocRef.set({});
      //   print("inside here yyyy");
      // }
      //////////////////////////////////////////
      
      // Add customer to the 'Message Customer' collection. Customer's data is also updated
      await userDocRef.collection('Message Customers').doc(customerData['email']).set(currCustomerData);
      await userDocRef.collection('Constant Message Customers').doc(customerData['email']).set(currCustomerData);
      
      // indicate the execution was successful
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Customer added'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print('Error adding customer: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add customer'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}