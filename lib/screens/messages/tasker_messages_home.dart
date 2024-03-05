// Contributors: Richard N.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tasklocal/screens/messages/chat_page.dart';
import 'package:tasklocal/screens/messages/tasker_msg_list_to_add.dart';

class TaskerMessagesHome extends StatefulWidget {
  const TaskerMessagesHome({super.key});

  @override
  State<TaskerMessagesHome> createState() => _TaskerMessagesHomeState();
}

class _TaskerMessagesHomeState extends State<TaskerMessagesHome> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messages', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,),),
        centerTitle: true,
        backgroundColor: Colors.green[800],
        elevation: 0.0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TaskerMsgListToAdd())
              );
            },
            icon: Icon(
              Icons.person_add,
              color: Colors.grey[300],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: _createListOfTaskers(),
      ),
    );
  }

  Widget _createListOfTaskers() {
    return StreamBuilder<QuerySnapshot>(
      stream: _fireStore.collection('Taskers').doc(_auth.currentUser!.email).collection('Message Customers').snapshots(),
      builder: (context, snapshot) {
        // Ensures there is no error when loading in the widget
        if (snapshot.hasError) {
          return const Text('Error');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        // provides a view of the list of taskers
        return ListView(
          children: snapshot.data!.docs.map((doc) => _createEachTasker(doc)).toList(),
        );
      },
    );
  }

  Widget _createEachTasker(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
    // shows all the taskers in list of rows
    if(_auth.currentUser!.email != data['email']) {    
        return ListTile(
        leading: CircleAvatar(
          child: Icon(Icons.account_circle),
        ),
        title: Text("${data['first name']} ${data['last name']} @${data['username']}"),
        trailing: IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            // Access the logged in customer's collection of taskers that they want to message and
            // remove the tasker document from the collection
            _fireStore.collection('Taskers').doc(_auth.currentUser!.email)
                      .collection('Message Customers').doc(data['email']).delete()
            .then((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Customer removed'),
                ),
              );
            })
            .catchError((error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: $error'),
                ),
              );
            });
          },
        ),
        onTap: () {
          Navigator.push(context, 
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiverFirstName: data['first name'],
                receiverLastName: data['last name'],
                receiverEmail: data['email'],
                taskersOrCustomersCollection: 'Taskers',
              ),
            )
          );
        },
      );
    }
    return Container();
  }
}