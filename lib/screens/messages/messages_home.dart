// Contributors: Richard N.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tasklocal/screens/messages/chat_page.dart';

class MessagesHome extends StatefulWidget {
  const MessagesHome({super.key});

  @override
  State<MessagesHome> createState() => _MessagesHomeState();
}

class _MessagesHomeState extends State<MessagesHome> {
  // final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messages', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.green[800],
        elevation: 0.0,
      ),
      body: _createListOfTaskers(),
    );
  }

  // creates the record of taskers that the customer is in contact with
  Widget _createListOfTaskers() {
    return StreamBuilder<QuerySnapshot>(
      // later find a way to have customers add and remove taskers to their messages page
      stream: FirebaseFirestore.instance.collection('Taskers').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('error');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('');
        }
        return ListView(
          children: snapshot.data!.docs.map<Widget>((doc) => _createEachListOfTaskers(doc)).toList(),
        );
      },
    );
  }

  // create each taskers record object
  Widget _createEachListOfTaskers(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
    // shows the entire taskers
    return ListTile(
      leading: CircleAvatar(
        child: Icon(Icons.account_circle),
      ),
      title: Text("@${data['username']} ${data['first name']} ${data['last name']} "),
      onTap: () {
        Navigator.push(context, 
          MaterialPageRoute(
            builder: (context) => ChatPage(
              receiverFirstName: data['first name'],
              receiverLastName: data['last name'],
              receiverUsername: data['username'],
              receiverEmail: data['email'],
            ),
          )
        );
      },
    );
  }
}