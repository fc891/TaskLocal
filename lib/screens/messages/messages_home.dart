// Contributors: Richard N.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MessagesHome extends StatefulWidget {
  const MessagesHome({super.key});

  @override
  State<MessagesHome> createState() => _MessagesHomeState();
}

class _MessagesHomeState extends State<MessagesHome> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

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

  // creates the record of taskers that the customer is contact with
  Widget _createListOfTaskers(DocumentSnapshot document) {
    return StreamBuilder<QuerySnapshot>(
      // later find a way to have customers add and remove taskers to their messages page
      stream: FirebaseFirestore.instance.collection('taskers').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('error');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('');
        }
        return ListView(
          children: snapshot.data!.docs.map<Widget>((doc) => _createEachListOfTaskers(doc)).toList(),
        ) 
      },
    );
  }

  // create each taskers record object
  Widget _createEachListOfTaskers(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
    // shows the entire taskers
    return ListTile(
      title: data['email'],
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(),))
      },
    );
  }
}